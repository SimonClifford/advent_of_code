function extract_nums(s::String)::String
    digits = Dict(
        "one"=>"1", "two"=>"2", "three"=>"3", "four"=>"4", "five"=>"5", "six"=>"6",
        "seven"=>"7", "eight"=>"8", "nine"=>"9"
    )
    new_s = ""
    for i = 1:lastindex(s)
        for k in keys(digits)
            if @views startswith(s[i:end], k)
                new_s *= digits[k]
                break
            end
        end
        new_s *= s[i]
    end
    return new_s
end

function main()::Int
    total = 0
    for line in eachline()
        # println(line)
        line = extract_nums(line)
        # println(line)
        only_nums = ""
        for c in line
            if isdigit(c)
                only_nums *= c
            end
        end
        concat_value = only_nums[1] * only_nums[end]
        total += parse(Int, concat_value)
    end
    return total
end

println(main())
