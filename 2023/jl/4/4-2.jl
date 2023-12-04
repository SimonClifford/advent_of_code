function main()
    total:: Int = 0
    the_cards = Dict{Int, Int}()
    for line in eachline()
        card_part, the_rest = split(line, ": ")
        card_num = parse(Int, split(card_part, " ")[end])

        # This counts the card we just drew
        the_cards[card_num] = get(the_cards, card_num, 0) + 1

        # Parse as before
        winners_s, my_nums_s = split(the_rest, " | ")
        winners = Set(parse.(Int, split(winners_s, " ", keepempty=false)))
        my_nums = Set(parse.(Int, split(my_nums_s, " ", keepempty=false)))
        intersection = intersect(winners, my_nums)

        # For each new card, add the count of copies of *this* card
        # to its count.
        for index = 1: length(intersection)
            temp = get(the_cards, card_num+index, 0)
            the_cards[card_num + index] = temp + the_cards[card_num]
        end
    end

    # We are told the value cannot go over the number of cards.
    # If this weren't true our sum here would have to be only over
    # our cards.
    println("Total is $(sum(values(the_cards)))")
end

main()
