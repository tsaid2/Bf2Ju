unclude("analyser.jl")
using .analyser

include("Bf.jl")
using .BfInterpreter


mutable struct Tmodel
    bfCode :: String
    variables :: Dict
    functions :: Dict
    indentation :: Int
    nV :: Int
    nF :: Int
    code :: String
    # TODO continue this
end

struct BracketError <: Exception
    message :: String
end

#Constants
global instructionsSet = ['<', '>', '+', '-', '.', ',', '[', ']'] # , '$', '!', '*']



"""
    pre_parser(model)

documentation
"""
function pre_parser(model)
    # clear the code
    model.bfCode = join(clearCode!(model.bfCode))

    # Verify brackets
    b , indexopen, indexclose, i = v_brackets(model.bfCode)
    if !b && i == -1
        throw(BracketError("Bracket(s) not closed : $indexopen \n"))
    elseif !b
        throw(BracketError("There is not a bracket matching with the closer bracket ch. $i \n"))
    end # if

    # check Warnings

end # function


"""
    getCodesSet()

documentation
"""
function getCodesSet(model)
    PyInstructions = Dict()
    PyInstructions['+'] = n => ' '^model.indentation * "cells[p] +=$n\n"
    PyInstructions['-'] = n => ' '^model.indentation * "cells[p] +=$n\n"
    PyInstructions['>'] = n => ' '^model.indentation * "p +=$n\n"
    PyInstructions['-'] = n => ' '^model.indentation * "p +=$n\n"
    PyInstructions['.'] = _ => ' '^model.indentation * "print(cells[p])\n"
    PyInstructions[','] = _ => ' '^model.indentation * "( print(\"insert a byte :\");parse(UInt8, readline()))\n"
    PyInstructions['['] = _ => (str = ' '^model.indentation * "while cells[p] != 0\n"; model.indentation+=3; str)
    PyInstructions[']'] = _ => (model.indentation-=3 ; ' '^model.indentation * model.indentation * "end\n")
    PyInstructions
end # function

"""
    getCode(model)

documentation
"""
function getCode(model)
    body
end # function


function main(file :: String)
    io = open(file,"r")
    pgrm = ""
    rl = readline(io)
    pgrm *= rl
    while rl != ""
        rl = readline(io)
        pgrm *= rl
    end
    model = Tmodel(pgrm)
    preparser(model)
    execute(model.bfCode)
    model.code *= getCode(model)
    fileName, ext = split(file,'.')
    newFName = fileName * ".jl"
    ioff = open(newFName, "w")
    write(ioff, code)
    close(ioff)
end
