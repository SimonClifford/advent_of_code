function main()
    if length(ARGS) != 1
        println("Needs file argument")
        exit(1)
    end
    lines = readlines(open(ARGS[1]))
    @views directions = lines[1]
    tree_dict = process_lines(lines)
    current_locs = [l for l in keys(tree_dict) if endswith(l, 'A')]
    steps = 0
    for d in Iterators.cycle(directions)
        # println("$steps $current_locs")
        if mod(steps, 1000000) == 0
            println("$steps")
        end
        if all(c->endswith(c, 'Z'), current_locs)
            break
        end
        current_locs = map(current_locs) do l
            move_loc(tree_dict, l, d)
        end
        steps += 1
    end
    println("Took $steps steps")
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
