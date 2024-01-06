struct Beam
    start_coord :: CartesianIndex
    direction  :: CartesianIndex
end
Beam(r::Int, c::Int, dr::Int, dc::Int) = Beam(CartesianIndex(r, c), CartesianIndex(dr, dc))
Beam(coord::CartesianIndex, dr::Int, dc::Int) = Beam(coord, CartesianIndex(dr, dc))


"""
Given a Beam, which has a starting postition and a direction,
walk the Beam through the layout until it ends.
It ends if:
*) it passes out of the layout
*) it reaches a non-empty element in layout that would change its
   direction
If necessary we generate 1 or 2 more Beams.  If they are not present
in seen_beams we propagate them too.

Modifies visited and seen_beams.
"""
function send_beam!(
    visited::BitMatrix,
    seen_beams::Set{Beam},
    layout::Matrix{Char},
    beam::Beam,
    )

    # println("Beam start at $(beam.start_coord) going $(beam.direction)")

    if beam in seen_beams
            # println("  seen")
        return
    end
    push!(seen_beams, beam)

    new_coord = beam.start_coord
    new_beams = Vector{Beam}()

    # Start moving
    while true
        new_coord += beam.direction
        # println("  Checking $new_coord")

        # Outside bounds
        if any([ !(c in a) for (c, a) in zip(Tuple(new_coord), axes(layout))])
            # println("  left map")
            return
        end

        # Mark visited (there may be a way to combine this step?)
        visited[new_coord] = 1

        # Mirrors
        if layout[new_coord] == '/'
            # println("    reflected in /, new heading $(-beam.direction[2]), $(-beam.direction[1])")
            push!(new_beams, Beam(new_coord, -beam.direction[2], -beam.direction[1]))
            break
        elseif layout[new_coord] == '\\' # a single backslash
            # println("    reflected in \\, new heading $(beam.direction[2]), $(beam.direction[1])")
            push!(new_beams, Beam(new_coord, beam.direction[2], beam.direction[1]))
            break
        end

        # Splitters
        if layout[new_coord] == '|' && beam.direction[2] != 0
            # println("    split in |, going (1, 0) and (-1, 0)")
            push!(new_beams, Beam(new_coord, 1, 0))
            push!(new_beams, Beam(new_coord, -1, 0))
            break
        elseif layout[new_coord] == '-' && beam.direction[1] != 0
            # println("    split in -, going (0, 1) and (0, -1)")
            push!(new_beams, Beam(new_coord, 0, 1))
            push!(new_beams, Beam(new_coord, 0, -1))
            break
        end

    end
    map(new_beams) do b
        send_beam!(visited, seen_beams, layout, b)
    end
    return
end

function parse_input(filename::AbstractString)
    lines = readlines(open(filename))
    layout = Matrix{Char}(undef, length(lines), length(lines[1]))
    for (index, line) in enumerate(lines)
        layout[index, 1:end] .= collect(line)
    end
    return layout
end

function compute_visited(layout::Matrix{Char}, beam::Beam)
    visited = BitMatrix(false for x in layout[1:end, 1], y in layout[1, 1:end])
    seen_beams = Set{Beam}()
    send_beam!(visited, seen_beams, layout, beam)
    return count(visited)
end

function main(filename::AbstractString)
    layout = parse_input(filename)
    first_beam = Beam(1, 0, 0, 1)
    ans = compute_visited(layout, first_beam)
    println("Answer to part 1 is: $(ans)")
    # There might be a neat trick of re-using past runs to avoid
    # re-computing paths we've already seen, but the code is
    # sufficiently fast that I don't need it.
    counts = Vector{Int}()
    for row in axes(layout, 1)
        first_beam = Beam(row, 0, 0, 1)
        push!(counts, compute_visited(layout, first_beam))
        first_beam = Beam(row, lastindex(layout, 2) + 1, 0, -1)
        push!(counts, compute_visited(layout, first_beam))
    end
    for col in axes(layout, 2)
        first_beam = Beam(0, col, 1, 0)
        push!(counts, compute_visited(layout, first_beam))
        first_beam = Beam(lastindex(layout, 1) + 1, 0, -1, 0)
        push!(counts, compute_visited(layout, first_beam))
    end
    println("Answer to part 2 is: $(maximum(counts))")
end

if !isinteractive()
    main(ARGS[1])
end
