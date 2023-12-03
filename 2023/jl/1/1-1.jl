
function main()::Int
    total = 0
    for line in eachline()
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
