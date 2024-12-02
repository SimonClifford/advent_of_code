"""
We reduce the graphics to a list of coordinates of the rocks.
These are 3-Vectors (x, y, 1.0).

Looping over possible values of d We then perform a reflection + translation by
d and just a translation. We collect the results into sets and do a Set
difference. If there are fewer elements in the difference set we check that all
its points lie outside the reflected zone.

"""
function main(filename::AbstractString)
    horiz_refl = [-1.0 0.0 0.0; 0.0  1.0 0.0; 0.0 0.0 1.0]
    vert_refl =  [ 1.0 0.0 0.0; 0.0 -1.0 0.0; 0.0 0.0 1.0]
    horiz_tran = [ 1.0 0.0 0.0; 0.0  1.0 0.0; 0.0 0.0 1.0]
    vert_tran =  [ 1.0 0.0 0.0; 0.0  1.0 0.0; 0.0 0.0 1.0]

    refl_mats = [ horiz_refl, vert_refl ]
    tran_mats = [ horiz_tran, vert_tran ]

    # Main loop
    tot = 0
    #for pat in parse_input(filename)
    pats = parse_input(filename)
    pat = pats[1]
        for index in range(1, 2)
            println("Trying $pat at $index")
            tot += inner_bit(pat, tran_mats[index], refl_mats[index], index)
        end
    #end
    println("Ans 1: $tot")
end

function inner_bit(pat::Vector{Vector{Float64}}, tran_mat::Matrix{Float64}, ref_mat::Matrix{Float64}, index::Int)
    max_cols = maximum(map(p->p[index], pat))
    for d in range(2, max_cols)
        println("looking at $(0.5-d) index: $index")
        tran_mat[index, 3] = 0.5 - d
        new_rocks = Set(do_symop(pat, ref_mat * tran_mat))
        old_rocks = Set(do_symop(pat, tran_mat))
        set_diff = setdiff(new_rocks, old_rocks)
        # If there are fewer unmatched elements we can check
        # to see if any are in the zone.
        if length(set_diff) < length(new_rocks)
            if check_in_zone(set_diff, max_cols, d, index)
                println("A hit! returned $(index == 1 ? (d-1) : 100(d-1))")
                return index == 1 ? d-1 : 100(d-1)
            end
        end
    end
    return 0
end

function check_in_zone(set_diff::Set{Vector{Float64}}, max_cols::Float64, d::Float64, index::Int)
    println("checking $set_diff with $(0.5-d) $(d-0.5) $index")
    max_dev = minimum((max_cols-d+0.5, d-0.5-1.0))
    if any(v->abs(v[index]+0.5-d) > max_cols, set_diff)
        return false
    end
    if any(v->abs(v[index]-0.5+d) < 1.0, set_diff)
        return false
    end
    return true
end

function do_symop(rocks::Vector{Vector{Float64}}, symop::Matrix{Float64})
    return map(rocks) do r
        symop * r
    end
end

function parse_input(filename::AbstractString)
    inputs = Vector{Vector{Vector{Float64}}}()
    lines = readlines(open(filename))
    index = 1
    next_empty = 1
    while next_empty < length(lines)
        next_empty = findnext(l->l=="", lines, index)
        if isnothing(next_empty)
            next_empty = length(lines)
        end
        @views push!(inputs, parse_matrix(lines[index:next_empty-1]))
        index = next_empty + 1
    end
    return inputs
end

"""
Given something like:
#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#

return a Vector of 3-Vectors of (x, y, 1.0) of each '#'
"""
function parse_matrix(lines::AbstractArray{String})
    output = Vector{Vector{Float64}}()
    for (r, line) in enumerate(lines)
        for (c, ch) in enumerate(line)
            if ch == '#'
                push!(output, [c, r, 1.0])
            end
        end
    end
    return output
end

if ! isinteractive()
    main(ARGS[1])
end
