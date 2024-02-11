using LinearAlgebra

function main(filename::AbstractString)
    dirs = Dict{Char, CartesianIndex}(
        '3' => CartesianIndex(0, -1),  # U
        '1' => CartesianIndex(0, 1),   # D
        '2' => CartesianIndex(-1, 0),  # L
        '0' => CartesianIndex(1, 0),   # R
    )
    f = open(filename)
    lines = readlines(f)
    first_point = CartesianIndex(0, 0)
    cur_point = first_point
    area = 0
    perimeter = 0
    for line in lines
        (_, _, hex_code) = split(line)
        @views count = parse(Int, hex_code[3:7], base=16)
        @views dir = hex_code[8]
        next_point = cur_point + dirs[dir] * count
        area += round(
            Int,
            det(
                [cur_point[1] next_point[1];
                 cur_point[2] next_point[2]]
            )
        )
        diff = next_point - cur_point
        perimeter += abs(diff[1]) + abs(diff[2])
        # println("$cur_point $next_point $area $diff $perimeter")
        cur_point = next_point
    end
#    area += round(
#        Int,
#        det(
#            [cur_point[1] first_point[1];
#             cur_point[2] first_point[2]]
#        )
#    )
    area = div(area, 2)
    ans1 = round(Int, area - 0.5 * perimeter + 1) + perimeter
    # Pick formula
    println("Ans 2: $ans1")
end

if !isinteractive()
    main(ARGS[1])
end
