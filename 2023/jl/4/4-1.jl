function main()
    total:: Int = 0
    for line in eachline()
        card_part, the_rest = split(line, ": ")
        winners_s, my_nums_s = split(the_rest, " | ")
        winners = Set{SubString{String}}(split(winners_s))
        my_nums = Set{SubString{String}}(split(my_nums_s))
        intersection = intersect(winners, my_nums)
        if (!isempty(intersection))
            total += 2^(length(intersection) -1)
        end
        #println(winners)
    end
    println("Total is $total")
end

main()
