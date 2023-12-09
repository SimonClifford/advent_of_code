function parse_file(filename::AbstractString)
    f = open(filename)
    inputs = map(split.(readlines(f))) do c parse.(Int, c) end
    return inputs
end

function main()
    inputs::Vector{Vector{Int}} = parse_file(ARGS[1])
    ans = sum(get_next.(inputs))
    println("Answer: $ans")
end

"""
A recursive solution to the problem.

Given a Vector of Ints find the next element by
recursively finding the next element in the sequences of
the differences.
"""
function get_next(seq::Vector{Int})
    differences = diff(seq)
    if all(e->e==0, differences)
        return seq[1]
    end
    return seq[1] - get_next(differences)
end

if ! isinteractive()
    main()
end
