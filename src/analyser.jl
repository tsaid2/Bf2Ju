module analyser

    export BracketError, MermoryBfVM

    struct BracketError <: Exception
        message :: String
    end

    struct MermoryBfVM <: Exception
        message :: String
    end

    function v_brackets(bfcode)
        n = length(bfcode)
        indexopen = []  # :: Array{Any,1} # Array of the left sqare bracket positions
        indexclose = [] #:: Array{A   ny,1}  # Array of the matching right square bracket positions
        brstack = [] # Stack for matching bracket positions
        for i=1:n
            if bfcode[i] == '['
                append!(indexopen,i)
                append!(indexclose,0)
                mem = length( indexopen )
                push!(brstack, mem)
                # println(stderr,"[ ", i, " ", length(indexo))
            elseif bfcode[i] == ']'
                try
                    j = pop!(brstack)
                    indexclose[j] = i
                catch
                    return false, indexopen, indexclose, i
                end
                # println(stderr,"]", i, length(brstack))
            end
        end
        #_result = (length(brstack) == 0)
        return ( (length(brstack) == 0), indexopen, indexclose, -1)
    end

end  # module analyser
