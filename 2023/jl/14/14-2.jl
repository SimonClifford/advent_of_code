function stack_col(col::AbstractArray{Char})
    out_index = 1
    spaces = 0
    rocks = 0
    out_col = similar(col)
    for (i, c) in enumerate(col)
        if c == '.'
            spaces += 1
        elseif c == 'O'
            rocks += 1
        elseif c == '#'
            @views out_col[out_index:out_index+spaces-1] .= '.'
            @views out_col[out_index+spaces:out_index+spaces+rocks-1] .= 'O'
            @views out_col[i] = '#'
            @assert out_index+spaces+rocks == i
            out_index += spaces + rocks + 1
            spaces = 0
            rocks = 0
        end
    end
    if spaces + rocks > 0
        @views out_col[out_index:out_index+spaces-1] .= '.'
        @views out_col[out_index+spaces:out_index+spaces+rocks-1] .= 'O'
    end
    return out_col
end

function main(filename::AbstractString)
    plat = parse_input(filename)

    (loop_s, loop_e) = find_loop(plat)
    println("$loop_s $loop_e")
    for n in range(loop_e, loop_e+loop_e-loop_s)
        println("$n: $(score_plat(plat))")
        plat = cycle(plat)
    end
    println((1000000000-loop_s)%(loop_e-loop_s))
end

function find_loop(plat::AbstractArray{Char})
    all_plats = Dict{Matrix{Char}, Int}()
    cycles = 1
    while cycles < 1000000000
        plat = cycle(plat)
        if plat in keys(all_plats)
            println("repeat at $cycles from $(all_plats[plat])")
            return (all_plats[plat], cycles)
        end
        all_plats[collect(plat)] = cycles
        cycles += 1
    end
end

function cycle(plat::AbstractArray{Char})
    for (i, c) in enumerate(eachcol(plat))
        @views plat[end:-1:1, i] = stack_col(c[end:-1:1])
    end
    for (i, c) in enumerate(eachrow(plat))
        @views plat[i, end:-1:1] = stack_col(c[end:-1:1])
    end
    for (i, c) in enumerate(eachcol(plat))
        @views plat[1:end, i] = stack_col(c)
    end
    for (i, c) in enumerate(eachrow(plat))
        @views plat[i, 1:end] = stack_col(c)
    end
    return plat
end

function score_plat(plat::AbstractArray{Char})
    score_row = size(plat, 1)
    tot_score = 0
    for c in eachrow(plat)
        tot_score += score_row * count(c .== 'O')
        score_row -= 1
    end
    return tot_score
end

function parse_input(filename::AbstractString)
    lines = readlines(open(filename))
    plat = Matrix{Char}(undef, length(lines[1]), length(lines))
    for (i, l) in enumerate(lines)
        plat[i, 1:end] = collect(l)
    end
    return plat
end

if !isinteractive()
    main(ARGS[1])
end
