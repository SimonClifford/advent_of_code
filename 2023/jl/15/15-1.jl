function parse_input(filename::AbstractString)
    line = readline(open(filename))
    return split(line, ',')
end

function main(filename::AbstractString)
    inputs = parse_input(filename)
    ans = sum(
        map(inputs) do i
            reduce(hash_char, map(c->Int(c), collect(i)), init=0)
        end
    )
    println("Answer 1 is $ans")
end

"""
Given current hash value and another Char
return the new hash value
"""
function hash_char(char_val::Int, hash_val::Int)
    new_val = hash_val + char_val
    new_val *= 17
    new_val %= 256
    return new_val
end

if ! isinteractive()
    main(ARGS[1])
end
