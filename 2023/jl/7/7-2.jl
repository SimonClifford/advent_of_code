import Base.isequal
import Base.isless

@enum HandType high pair twopair three full four five
struct Hand
    hand::String
    hand_type::HandType
end

Hand(s::AbstractString) = Hand(s, get_handtype(s))

card_values::String = "J23456789TQKA"
split_card_values = collect(card_values)

function get_handtype(h_s::AbstractString)
    hv = @views (sort ∘ map)(split_card_values[2:end]) do c count(c, h_s) end
    jokers = count('J', h_s)
    if hv[end] + jokers == 5
        return five
    end
    if hv[end] + jokers == 4
        return four
    end
    if hv[end] + jokers == 3
        if hv[end-1] == 2
            return full
        end
        return three
    end
    if hv[end] + jokers == 2
        if hv[end-1] == 2
            return twopair
        end
        return pair
    end
    return high
end

# Define a total ordering, so native `sort` will work with Hand types
function isless(hand1::Hand, hand2::Hand)
    if hand1.hand_type != hand2.hand_type
        return hand1.hand_type < hand2.hand_type
    end
    for (h1c, h2c) in zip(collect(hand1.hand), collect(hand2.hand))
        rem = findfirst(h1c, card_values) - findfirst(h2c, card_values)
        if rem < 0
            return true
        elseif rem > 0
            return false
        end
    end
    return false
end

function main()
    f = open(ARGS[1])
    inputs = stack(split.(readlines(f)))
    hands = @views Hand.(inputs[1, :])
    sp = sortperm(hands)
    ans = @views zip(range(1, length(sp)), parse.(Int, inputs[2, :])[sp]) .|> prod |> sum
    println("Answer $ans")
end

main()
