"""
Probably easier to examine each square T of the map and see if:
1) It's within Manhattan range of S.
2) It's on an even number of steps from S.
3) There's at least one path to S.
"""

"""
Parse the input, return a Matrix{Char}
"""
function parse_input(filename::AbstractString)
    lines = readlines(open(filename))
    inp = Matrix{Char}(undef,length(lines), length(lines[1]))
    for (i, l) in enumerate(lines)
        inp[i, begin:end] = collect(l)
    end
    return inp
end

function search(garden::Matrix{Char}, start_node::CartesianIndex)
end
