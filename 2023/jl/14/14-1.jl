function tiltnorth(col::AbstractArray{Char})
    tot_load = 0
    max_col = length(col)
    load = max_col
    for (i, c) in enumerate(col)
        if c == 'O'
            tot_load += load
            load -= 1
        elseif c == '#'
            load = max_col - i
        end
    end
    return tot_load
end

function main(filename::AbstractString)
    lines = readlines(open(filename))
    plat = Matrix{Char}(undef, length(lines[1]), length(lines))
    for (i, l) in enumerate(lines)
        plat[i, 1:end] = collect(l)
    end
    ans = sum(map(c->tiltnorth(c), eachcol(plat)))
    println("Ans 1 is $ans")
end

if !isinteractive()
    main(ARGS[1])
end
