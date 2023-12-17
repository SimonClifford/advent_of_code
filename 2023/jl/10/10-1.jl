using LinearAlgebra

const global deltas = Dict{Char, Tuple{CartesianIndex{2}, CartesianIndex{2}}}(
    '|' => (CartesianIndex(0,1), CartesianIndex(0,-1)),
    '-' => (CartesianIndex(1,0), CartesianIndex(-1,0)),
    'L' => (CartesianIndex(0,-1), CartesianIndex(1,0)),
    'J' => (CartesianIndex(0,-1), CartesianIndex(-1,0)),
    '7' => (CartesianIndex(0,1), CartesianIndex(-1,0)),
    'F' => (CartesianIndex(0,1), CartesianIndex(1,0)),
)

function check_legit(locs::Vector{CartesianIndex{2}}, maxlen::Int)
    return filter(locs) do l
        all(e -> e>0 && e<=maxlen, Tuple(l))
    end
end

"""
Given a location in the pipemap return all legal next moves from
this location.

Returns empty Vector for '.' and 'S' locations.
Returns 0, 1, or 2 element Vector of CartesianIndex.
"""
function get_exits(pipemap::Matrix{Char}, loc::CartesianIndex{2})
    # Assume pipemap is square
    maxlen = size(pipemap, 1)
    new_locs = Vector{CartesianIndex{2}}([d + loc for d in deltas[pipemap[loc]]])
    return check_legit(new_locs, maxlen)
end

function main(filename::AbstractString)
    pipemap::Matrix{Char} = parse_input(filename)
    s_loc = findall(e->e=='S', pipemap)
    cur_loc = find_start_location(pipemap, s_loc[1])
    prev_loc = s_loc[1]

    length = 1
    pipe_coords = Vector{CartesianIndex{2}}()
    push!(pipe_coords, cur_loc)
    while cur_loc != s_loc[1]
        tmp = cur_loc
        cur_loc = first(filter(l->l != prev_loc, get_exits(pipemap, cur_loc)))
        prev_loc = tmp
        length += 1
        push!(pipe_coords, cur_loc)
    end

    ans1 = div(length, 2)
    println("Part 1 answer: $ans1")

    total::Int = 0
    for i in range(1, length-1)
        total += round(
            Int,
            det(
                [pipe_coords[i][1] pipe_coords[i+1][1];
                 pipe_coords[i][2] pipe_coords[i+1][2]]
            )
        )
    end
    total += round(
        Int,
        det(
            [pipe_coords[length][1] pipe_coords[1][1];
             pipe_coords[length][2] pipe_coords[1][2]]
        )
    )
    ans2 = div(abs(total), 2) - ans1 + 1 # Where did the +1 come from?
    println("Part 2 answer: $ans2")
end

"""
Given a loc (presumably with 'S' in it) in the pipemap
return first found location adjacent to it that could reach it.

I.e. for each adjacent location, get the exits and return the
location if an exit == loc

Returns a CartesianIndex{2}
"""
function find_start_location(pipemap::Matrix{Char}, loc::CartesianIndex{2})
    maxlen = size(pipemap, 1)
    adj_locs = Vector{CartesianIndex{2}}(
        [loc + d for d in (CartesianIndex(0,-1), CartesianIndex(0,1),
          CartesianIndex(-1,0), CartesianIndex(1,0))]
    )
    for al in check_legit(adj_locs, maxlen)
        if pipemap[al] == '.'
            continue
        end
        for e in get_exits(pipemap, al)
            if e == loc
                return al
            end
        end
    end
end

"""
Returns a Matrix{Char}, which is a synonym for
an Array{Char, 2} (a 2D Array).

If we were worried about memory we could map
the symbols to something smaller like Int8.
"""
function parse_input(filename::AbstractString)
    return stack(readlines(open(filename)))
end

if ! isinteractive()
    main(ARGS[1])
end
