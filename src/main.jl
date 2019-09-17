mutable struct model
    fileName :: String
    bfCode :: String
    variables :: Dict
    functions :: Dict
    nV :: Int
    nF :: Int
    # TODO continue this
end

#Constants
global instructionSet = ['<', '>', '+', '-', '.', ',', '[', ']'] # , '$', '!', '*']


"""
    pre_parser(model)

documentation
"""
function pre_parser(model)

end # function


"""
    getPyInstructions(instructionSet)

documentation
"""
function getPyInstructions()
    PyInstructions = Dict()
    PyInstructions['+'] = n =>  "cells[p] +=$n"
    PyInstructions['-'] = n =>  "cells[p] +=$n"
    PyInstructions['>'] = n =>  "p +=$n"
    PyInstructions['-'] = n =>  "p +=$n"
    PyInstructions['.'] = "print(cells[p])"
    PyInstructions[','] = "( print(\"insert a byte :\");parse(UInt8, readline()))"
    PyInstructions['['] = "TODO"
    PyInstructions[']'] = "TODO"
end # function
