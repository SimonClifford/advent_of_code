function main()
    total:: Int = 0
    for line in eachline()
        card_part, the_rest = split(line, ": ")
        winners_s, my_nums_s = split(the_rest, " | ")
        winners = Set(parse.(Int, split(winners_s, " ", keepempty=false)))
        my_nums = Set(parse.(Int, split(my_nums_s, " ", keepempty=false)))
        intersection = intersect(winners, my_nums)
        if (!isempty(intersection))
            total += 2^(length(intersection) -1)
        end
        #println(winners)
    end
    println("Total is $total")
end

main()
