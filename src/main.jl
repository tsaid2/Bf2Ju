module main
    include("analyser.jl")
    using .analyser

    include("Bf.jl")
    using .BfInterpreter

    using StatsBase

    using ResumableFunctions

    export mainf

    mutable struct Tmodel
        bfCode :: String
        indentation :: Int
        nC :: Int
        code :: String
        input :: String
        Tmodel(pgm :: String) = new(pgm, 0, 0, "", "")
    end # mutable struct

    struct BracketError <: Exception
        message :: String
    end # struct


    #Constants
    global instructionsSet = ['<', '>', '+', '-', '.', ',', '[', ']'] # , '$', '!', '*']



    #="""
        pre_parser(model)

    documentation
    """=#
    function pre_parser(model)
        bfcFreq = countmap(collect(model.bfCode))
        # clear the code
        model.bfCode = join(clearCode!(model.bfCode, instructionsSet))

        # Verify brackets
        b , indexopen, indexclose, i = v_brackets(model.bfCode)
        if !b && i == -1
            model.code *= "@warn \"Bracket(s) not closed : $(filter!(s -> s ∉ indexclose, indexopen))\" \n"
        elseif !b
            model.code *= "@warn \"There is not a bracket matching with the closer bracket ch.\" $i \n"
        end # if

        # check Warnings
        if get(bfcFreq,'<',0) > get(bfcFreq,'>',0)
            model.code *= "@warn \"There are more '<' than '>'. There is a risk of negative pointer \"\n"
        end


    end # function


    #="""
        getCodesSet()

    documentation
    """=#
    function getCodesSet(model)
        juInstructions = Dict()
        juInstructions['+'] = (n -> if n !=0
                                        ' '^model.indentation * "cells[p] = (cells[p] + $n) % 256 \n"
                                    else
                                        ""
                                    end # if
                                )
        juInstructions['-'] = (n -> ' '^model.indentation * "cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - $n) \n")
        juInstructions['>'] = (n -> ' '^model.indentation * "p += $n\n")
        juInstructions['<'] = (n -> ' '^model.indentation * "p -= $n\n")
        juInstructions['.'] = (n -> (' '^model.indentation * "print(Char(cells[p]))\n")^n)
        #juInstructions[','] = (n -> ' '^model.indentation * "( print(\"insert a byte :\");parse(UInt8, readline()))\n")
        juInstructions[','] = (n ->(
                            ' '^model.indentation * "try\n" *
                            ' '^model.indentation * "   print(\"insert a byte :\"); cells[p] = UInt8(readline()[1])\n" *
                            ' '^model.indentation * "catch\n" *
                            ' '^model.indentation * "   print(\"insert a byte :\"); cells[p] = UInt8(0)\n" *
                            ' '^model.indentation * "end\n" )^n)
        juInstructions['['] = (n -> (str = ' '^model.indentation * "while (cells[p] != 0)\n"; model.indentation+=3;
                                    str * ' '^model.indentation * "global p\n"))
        juInstructions[']'] = (n -> (model.indentation-=3 ; (' '^model.indentation) * "end\n"))
        juInstructions
    end # function


    """
        getCode(model)

    documentation
    """
    function getCode!(model)
        miniSet = ['[',']']
        juInstructions = getCodesSet(model)
        #bfcFreq = countmap([c for c in model.bfCode])
        #code = "global p=1 # pointer \ncells = fill(UInt8(0),$(get(bfcFreq,'>',0)+1),1)\n"
        code = "global p=1 # pointer \ncells = fill(UInt8(0),($(model.nC)+50),1)\n"
        counter = 0
        prevChar = '+'
        doPrev = false
        for c in model.bfCode
            #=if prevChar == ' '
                prevChar = c
            end=#
            doPrev = true
            if (c ∈ miniSet)
                code *= juInstructions[prevChar](counter)
                code *= juInstructions[c](1)
                doPrev = false
                prevChar = '+'
                counter = 0
            elseif prevChar == c # && c ∉ miniSet && prevChar == c
                counter += 1
            else
                code *= juInstructions[prevChar](counter)
                prevChar = c
                counter = 1
            end # if
        end # for
        if doPrev
            code *= juInstructions[prevChar](counter)
        end # if
        code
    end # function


    function mainf(files...)
        for file in files
            mainf(file)
        end # for
    end # function

    function mainf(file :: String)
        io = open(file,"r")
        pgrm = ""
        rl = readline(io)
        pgrm *= rl
        while rl != ""
            rl = readline(io)
            pgrm *= rl
        end # while
        model = Tmodel(pgrm)
        pre_parser(model)
        # Preparse and Execute the algorithm
        try
            output, moves = execute(model.bfCode, model.input)
            model.nC = moves
        catch exc
            model.code *= "@warn \"Something went wrong: $(replace( "$exc","\"" => "\\\"") ) \" \n"
        end
        model.code *= getCode!(model)
        fileName, ext = split(file,'.')
        newFName = fileName * ".jl"
        ioff = open(newFName, "w")
        write(ioff, model.code)
        close(ioff)
        close(io)
    end # function

end  # module main
