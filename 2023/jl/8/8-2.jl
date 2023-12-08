function main()
    if length(ARGS) != 1
        println("Needs file argument")
        exit(1)
    end
    lines = readlines(open(ARGS[1]))
    @views directions = lines[1]
    tree_dict = process_lines(lines)
    start_locs = [l for l in keys(tree_dict) if endswith(l, 'A')]
    # Now for each start_loc we compute the cycle.
    cycles = map(s->get_cycle(tree_dict, directions, s), start_locs)
    # For annoying reasons there is a simple answer
    ans = lcm([c[3] for c in cycles])
    println("Answer: $ans")
    # But this makes a host of maybe unwarranted assumptions!
end


function is_within(cycle::Tuple{Int, Int}, index::Int)
    return mod(index, cycle[2]) == cycle[1]
end

"""
Given a starting location `start_loc` we compute the 'cycle' of
this location.

We start at start_loc and move through the tree noting all
occurances of winning locations (i.e. those that end with 'Z').
We do this until we reach somewhere we've been
while at the same point of the directions list.

Returns
    Tuple{Vector{Int}, Int} # winning locations, cycle length
"""
function get_cycle(
    tree::Dict{
               AbstractString,
               @NamedTuple{left::AbstractString, right::AbstractString}
              },
    directions::AbstractString,
    start_loc::AbstractString,
    )
    cur_loc = start_loc
    winners = Vector{Int}()
    past_locs = Dict{Tuple{AbstractString, Int}, Int}()
    past_locs[(cur_loc, 1)] = 1
    index = 0
    while true
        for (d_ind, d) in enumerate(directions)
#            println("$index: $cur_loc $d($d_ind)")
            if endswith(cur_loc, 'Z')
                append!(winners, index)
            end
            cur_loc = move_loc(tree, cur_loc, d)
            if get(past_locs, (cur_loc, d_ind), 0) != 0
#                println("would have gone to $cur_loc with $d($d_ind)")
                return (past_locs[(cur_loc, d_ind)], winners, index - past_locs[(cur_loc, d_ind)])
            end
            past_locs[(cur_loc, d_ind)] = index
            index += 1
        end
    end
end



function move_loc(
    tree:: Dict{
        AbstractString,
        @NamedTuple{left::AbstractString, right::AbstractString}
    },
    cur_loc::AbstractString,
    d::AbstractChar,
    )
    # Do NOT use d == "L", it does not catch d == 'L'
    if d == 'L'
        return tree[cur_loc].left
    else
        return tree[cur_loc].right
    end
end

"""
Given a Vector of AbstractStrings of the form:
AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)

parse it so each lines creates an entry in a Dict:
"AAA" => NamedTuple(left="BBB", right="CCC")
"BBB" => NamedTuple(left="DDD", right="EEE")
"CCC" => NamedTuple(left="ZZZ", right="GGG")

and return this Dict
"""
function process_lines(lines::Vector{String})
    part = map(lines[3:end]) do l
        s = match(r"(\w+) = \((\w+), (\w+)\)", l)
        s[1] => @NamedTuple{left::AbstractString, right::AbstractString}((s[2], s[3]))
    end
    d = Dict{
        AbstractString,
        @NamedTuple{left::AbstractString, right::AbstractString}
        }(part)
    return d
end

if ! isinteractive()
    main()
end
