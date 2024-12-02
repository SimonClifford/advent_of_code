struct SparseMap
    maps_from::String
    maps_to::String
    ranges::Vector{@NamedTuple{d_start::Int, s_start::Int, range::Int}}
end

# Outer constructor to convert Vector of Vectors to Vector of Tuples
SparseMap(from::AbstractString, to::AbstractString, aov::Vector{Vector{Int}}) =
    SparseMap(from, to, [@NamedTuple{d_start::Int, s_start::Int, range::Int}(v) for v in aov])

function range_matches(
        nt::NamedTuple{(:d_start, :s_start, :range),
                       Tuple{Int64, Int64, Int64}},
        index::Int
    )
    # Return the mapping from destination to source for
    # this index in this range.  If it's not mapped then
    # return -1
    if index >= nt.s_start && index <= nt.s_start + nt.range-1
        return nt.d_start + index - nt.s_start
    else
        return -1
    end
end

function maps_to(sparse_map::SparseMap, index)
    # Return the destination mapped to by the source `index`
    # for this SparseMap
    for range in sparse_map.ranges
        val = range_matches(range, index)
        if val > 0
            return val
        end
    end
    return index
end

function make_map(lines::Vector{String})
    from, to = match(r"^(\w+)-to-(\w+) ", lines[1])
    return SparseMap(
        from,
        to,
        Base.map(x->parse.(Int, x), split.(lines[2:end]))
    )
end

function parse_input(input::IOStream)
    # Parse the input stream and generate a Dict of SparseMaps
    # e.g. "seed" => {maps_to: "soil", ranges: [(50, 98, 2), (52, 50, 48)]}
    # would be the first map in the first test input:
    #
    # seed-to-soil map:
    # 50 98 2
    # 52 50 48
    out_dict = Dict{String, SparseMap}()
    lines = readlines(input)
    append!(lines, ("",))

    # Process first line
    seed_list = parse.(Int, split(lines[1][8:end]))

    # Process remaining lines
    empties = findall(x->x=="", lines[2:end])
    for (x, y) in zip(empties, empties[2:end])
        sp_map = make_map(lines[x+2:y])
        out_dict[sp_map.maps_from] = sp_map
    end

    return seed_list, out_dict
end

function find_location(seed::Int, sp_dict::Dict{String, SparseMap})
    index = seed
    the_map = sp_dict["seed"]
    while the_map.maps_to != "location"
        index = maps_to(the_map, index)
        the_map = sp_dict[the_map.maps_to]
    end
    index = maps_to(the_map, index)
end

function do_part_2(out_dict, chunk)
    locs = Vector()
    for c in chunk
        x, y = chunk
        println("$x and $y")
        locs = minimum([find_location(seed, out_dict) for seed in range(start=x, length=y+1)])
    end
    return minimum([find_location(seed, out_dict) for seed in range(start=x, length=y+1)])
end

function main()
    seed_list, out_dict = parse_input(open(ARGS[1]))
    locations = [find_location(seed, out_dict) for seed in seed_list]
    println("Part 1: $(minimum(locations))")
    min_loc_all = 99999999999999 # lol
    xys = [ (x, y) for (x, y) in zip(seed_list[1:2:end], seed_list[2:2:end])]
    println(xys)
    chunks = Iterators.partition(xys, 1)
    tasks = map(chunks) do chunk
        println("chunk $chunk")
        Threads.@spawn do_part_2(out_dict, chunk)
    end
    locations = fetch.(tasks)
    println("Part 2: $(min(locations))")
end

main()
