"""
Reading is a bit more complex than usual.

We'll read in a line (row) at a time.  Then we parse the row.  Each time
we get a row with no galaxies we increment the row index.  We store the galaxies we
find with the correct row index under the original column index.

We create an offset map for the columns.

Then we return the result Vector{Tuple(Int, Int)} with the columns remapped
according to the offset map.
"""
function parse_input(filename::AbstractString)
    result = Dict{Int, Vector{Int}}()
    # First the rows
    row_index = 1
    max_cols = 0
    for line in eachline(open(filename))
        max_cols = length(line)  # Assume all equal length
        columns = findall('#', line)
        if length(columns) == 0
            row_index += 2
            continue
        end
        for col_index in columns
            push!(get!(result, col_index, Vector{Int}()), row_index)
        end
        row_index += 1
    end
    # Now the column offsets
    col_offset = 0
    result_vector = Vector{Tuple{Int, Int}}()
    for col_index in range(1, max_cols)
        if ! haskey(result, col_index)
            col_offset += 1
            continue
        end
        for row_index in result[col_index]
            push!(result_vector, (col_index + col_offset, row_index))
        end
    end
    return result_vector
end

"""
Compute the Manhattan distance between two Tuple{Int, Int}
"""
function manhattan_dist(pair1::Tuple{Int, Int}, pair2::Tuple{Int, Int})
    return abs(pair1[1] - pair2[1]) + abs(pair1[2] - pair2[2])
end

"""
Call parse_input to get Vector{Tuple{col, row}}, with both indices expanded.
Iterate through to find all unique pairs, compute Manhattan distance for each pair,
sum.
"""
function main(filename::AbstractString)
    galaxies = parse_input(filename)
    total_sum = 0
    for gal_index in range(1, length(galaxies))
        for inner_gal_index in range(gal_index+1, length(galaxies))
            dist = manhattan_dist(galaxies[gal_index], galaxies[inner_gal_index])
            total_sum += dist
        end
    end
    println("Answer 1 is $total_sum")
end

if ! isinteractive()
    main(ARGS[1])
end
