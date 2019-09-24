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
        variables :: Dict
        functions :: Dict
        indentation :: Int
        nC :: Int
        code :: String
        # TODO continue this
        Tmodel(pgm :: String) = new(pgm, Dict(), Dict(), 0, 0, "")
    end

    struct BracketError <: Exception
        message :: String
    end

    #Constants
    global instructionsSet = ['<', '>', '+', '-', '.', ',', '[', ']'] # , '$', '!', '*']



    #="""
        pre_parser(model)

    documentation
    """=#
    function pre_parser(model)
        # clear the code
        model.bfCode = join(clearCode!(model.bfCode, instructionsSet))

        # Verify brackets
        b , indexopen, indexclose, i = v_brackets(model.bfCode)
        if !b && i == -1
            throw(BracketError("Bracket(s) not closed : $indexopen \n"))
        elseif !b
            throw(BracketError("There is not a bracket matching with the closer bracket ch. $i \n"))
        end # if

        # check Warnings

    end # function


    #="""
        getCodesSet()

    documentation
    """=#
    function getCodesSet(model)
        juInstructions = Dict()
        juInstructions['+'] = (n -> ' '^model.indentation * "cells[p] = (cells[p] + 1) % 256 \n")
        juInstructions['-'] = (n -> ' '^model.indentation * "cells[p] = (cells[p] - 1) % 256 \n")
        juInstructions['>'] = (n -> ' '^model.indentation * "p += 1\n")
        juInstructions['<'] = (n -> ' '^model.indentation * "p -= 1\n")
        juInstructions['.'] = (n -> ' '^model.indentation * "print(Char(cells[p]))\n")
        #juInstructions[','] = (n -> ' '^model.indentation * "( print(\"insert a byte :\");parse(UInt8, readline()))\n")
        juInstructions[','] = (n ->(
                            ' '^model.indentation * "try\n" *
                            ' '^model.indentation * "   print(\"insert a byte :\"); cells[p] = UInt8(readline()[1])\n" *
                            ' '^model.indentation * "catch\n" *
                            ' '^model.indentation * "   print(\"insert a byte :\"); cells[p] = UInt8(0)\n" *
                            ' '^model.indentation * "end\n" ))
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
        juInstructions = getCodesSet(model)
        #bfcFreq = countmap([c for c in model.bfCode])
        #code = "global p=1 # pointer \ncells = fill(UInt8(0),$(get(bfcFreq,'>',0)+1),1)\n"
        code = "global p=1 # pointer \ncells = fill(UInt8(0),($(model.nC)+50),1)\n"
        for c in model.bfCode
            code *= juInstructions[c](1)
        end # for
        code
    end # function


    function mainf(file :: String)
        io = open(file,"r")
        pgrm = ""
        rl = readline(io)
        pgrm *= rl
        while rl != ""
            rl = readline(io)
            pgrm *= rl
        end
        model = Tmodel(pgrm)
        pre_parser(model)
        output, moves = execute(model.bfCode) # TODO
        model.nC = moves
        model.code *= getCode!(model)
        fileName, ext = split(file,'.')
        newFName = fileName * ".jl"
        ioff = open(newFName, "w")
        write(ioff, model.code)
        close(ioff)
        close(io)
    end

end  # module main
