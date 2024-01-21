using DataStructures

"""
A node for consideration by the A* algo.  The same location (`loc`)
can appear many times, since how we reach each one matters.

`prev_step` is the step taken to get to `loc`.  `num_steps` is
the number of previous steps taken that match `prev_step`.
"""
struct GraphNode
    loc::CartesianIndex
    prev_step::CartesianIndex
	num_steps::Int
end

"""
A constructor that uses the track of an existing GraphNode
to create a new one.  We assume it's a valid step.

`loc` is the new location
`prev_gn` is the previous GraphNode
"""
GraphNode(loc::CartesianIndex, prev_gn::GraphNode) = begin
	this_step = loc - prev_gn.loc
	if this_step != prev_gn.prev_step
	    return GraphNode(loc, this_step, 1)
    end
    return GraphNode(loc, this_step, prev_gn.num_steps + 1)
end

import Base.==
function ==(g1::GraphNode, g2::GraphNode)
    return g1.loc == g2.loc &&
           g1.prev_step == g2.prev_step &&
           g1.num_steps == g2.num_steps
end

import Base.hash
function hash(g::GraphNode)
	h = hash(g.loc)
	h = hash(g.prev_step, h)
	return hash(g.num_steps, h)
end

"""
Compute possible neighbours for `current`.  The neighbours must obey
the rule of three.  It must also not return the nwighbour that came
before current in this track.
"""
function neighbours(
    current::GraphNode,
    city::Matrix{Int},
)
    neighs = Vector{GraphNode}()
    for t in ((0, 1), (0, -1), (1, 0), (-1, 0))
        c = CartesianIndex(t)
        # Check if just came from there
        if current.prev_step == CartesianIndex(0, 0) - c
            continue
        end
        # Check if we've already moved 3 times in this direction already.
        if current.prev_step == c && current.num_steps == 3
            continue
        end
        # Check if not in city
        if any([!(i in a) for (i, a) in zip(Tuple(c + current.loc), axes(city))])
            continue
        end
        # It's good, create it and push it
        push!(
            neighs,
            GraphNode(c + current.loc, current),
        )
    end
    return neighs
end

"""
Returns the cost of going from `current` to `next`.
We assume this is a valid transition.
"""
function get_cost(current::GraphNode, next::GraphNode,
    city::Matrix{Int})
    return city[next.loc]
end

"""
Return the Manhattan distance between `current` and `goal`
"""
function man_dist(current::CartesianIndex, goal::CartesianIndex)
    return abs(current[1] - goal[1]) + abs(current[2] - goal[2])
end

"""
The Wikipedia article on A* has pseudocode.  Here it is!
A* finds a path from start to goal.  h is the heuristic function. h(n)
estimates the cost to reach goal from node n.
"""
function a_Star(start::GraphNode, goal::CartesianIndex, city::Matrix{Int})
    # The set of discovered nodes that may need to be (re-)expanded.
    # Initially, only the start node is known.  This is usually implemented as
    # a min-heap or priority queue rather than a hash-set.
    openSet = DataStructures.PriorityQueue{GraphNode, Int}()
    openSet[start] = man_dist(start.loc, goal)

    # For node n, cameFrom[n] is the node immediately preceding it on the
    # cheapest path from the start to n currently known.
    #   This is now encoded into the GraphNode.

    # For node n, gScore[n] is the cost of the cheapest path from start to n
    # currently known.
    gScore = DefaultDict{GraphNode, Int}(typemax(Int))
    gScore[start] = 0

    count = 0
    while !(isempty(openSet))
        # This operation can occur in O(Log(N)) time if openSet is a min-heap
        # or a priority queue
        current = dequeue!(openSet)
        if gScore[current] == typemax(Int)
            continue
        end
        # println("Trying $(gScore[current]) $(city[current.loc]) $current")
        count += 1
        if current.loc == goal
            println("Arrived after $count steps!")
            return gScore[current]
        end

        for neighbour in neighbours(current, city)
            # println("  neigh: $neighbour")
            # get_cost(current,neighbour) is the weight of the edge from current to
            # neighbour 
            # tentative_gScore is the distance from start to the neighbour
            # through current
            tentative_gScore = gScore[current] + get_cost(current, neighbour, city)
            if tentative_gScore < gScore[neighbour]
                # This path to neighbour is better than any previous one. Record
                # it!
                # println("    it's good gScore=$tentative_gScore")
                gScore[neighbour] = tentative_gScore
                if !haskey(openSet, neighbour)
                    # println("    added to openSet with $(tentative_gScore + man_dist(neighbour.loc, goal))")
                    openSet[neighbour] = tentative_gScore + man_dist(neighbour.loc, goal)
                end
            end
        end
    end

    # Open set is empty but goal was never reached
    return -1
end

function parse_input(filename::AbstractString)
    lines = readlines(open(filename))
    city = Matrix{Int}(undef, length(lines), length(lines[1]))
    for (index, line) in enumerate(lines)
        city[index, begin:end] .= parse.(Int, collect(line))
    end
    return city
end

function main(filename::AbstractString)
    city = parse_input(filename)
    empty = CartesianIndex(0, 0)
    start = GraphNode(
        CartesianIndex(1, 1),
        CartesianIndex(0, 0),
        0
    )
    goal = CartesianIndex(size(city))
    ans = a_Star(start, goal, city)
    println("Ans 1: $ans")
end

if !isinteractive()
    main(ARGS[1])
end
