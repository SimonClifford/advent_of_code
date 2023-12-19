"""
Recursive search consuming the pattern and constraints.

Recursion terminates at:
* Empty pattern or constraints.
* We had a '#' character at the start of the pattern but
didn't match anything.

Uses a regex to actually match the current pattern (in match_pat)
"""

function search_pat(pattern::AbstractString, cons::AbstractArray{Int})
    #println("Enter with $pattern $cons")

    tot = 0
    # Consume initial .
    pattern = lstrip(pattern, '.')
#    index = 1
#    while pattern[index] == '.'
#        index += 1
#    end

    # Terminate the recursion.

    ## If no more constraints then we're done.
    ## Unless there are # in the remaining pattern!
    if length(cons) == 0
        if occursin('#', pattern)
            return 0
        end
        #println("Incremented tot")
        return 1
    end
    # If pattern empty or only . but matches remain then fail.
    if length(pattern) == 0 || ! occursin(r"[^.]", pattern) 
        #println("Bailed here")
        return 0
    end

    # Consider first char
    # If # then try the next constraint
    if pattern[1] == '#'
        #println("First is #")
        # If we match then recurse with remaining pattern and cons
        match_len =  match_pat(pattern, cons[1])
        if match_len != 0
            #println("Matched 1: $match_len")
            return tot + @views search_pat(pattern[match_len+1:end],
                                     cons[2:end])
        # Otherwise we failed to match - Terminate
        else
            return tot
        end
    # Must be ?
    else
        match_len = match_pat(pattern, cons[1])
        if match_len != 0
            #println("Matched 2: $match_len")
            tot += @views search_pat(pattern[match_len+1:end],
                                     cons[2:end])
        end
        tot += @views search_pat(pattern[2:end], cons)
        return tot
    end
    @assert false
end

"""
See if we can match count broken springs at start of pattern.
Returns true if allowed, false if not.

So "###.", 3 => true
   "?##?", 3 => true
   "?###", 3 => false
   "?##?", 3 => true
   "???",  3 => true
"""
function match_pat(pattern::AbstractString, count::Int)
    re = r"^" * r"[#?]" ^ count * r"(?:$|[.?])"
    m = match(re, pattern)
    if isnothing(m)
        return 0
    else
        return length(m.match)
    end
end

function main(filename::AbstractString)
    tot = 0
    for line in eachline(open(filename))
        (pattern, con_s) = split(line)
        cons = parse.(Int, split(con_s, ','))

        t = search_pat(pattern, cons)
        #println("$pattern $cons = $t")
        tot += t
    end
    println("Answer 1 is $tot")
end

if ! isinteractive()
    main(ARGS[1])
end
