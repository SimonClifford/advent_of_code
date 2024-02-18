"""
So "x>10" becomes variable='x', operator=>, value=10
"""
struct Condition
    variable::Char
    operator::Char
    value::Int
end

"""
A Rule contains a condition and a workflow, which is where to go if the
condition is met.  If the condition is Nothing then it always evaluates true.
"""
struct Rule
    condition::Condition
    workflow::AbstractString
end
Rule(ch::AbstractString, o::AbstractString, i::Int, s::AbstractString) = 
    Rule(Condition(ch[1], o[1], i), s)

struct Workflow
    rules::Vector{Rule}
    final_workflow::AbstractString
end

"""
A PartRange represents all currently available ranges of
x, a, s, and m.

The NamedTuples are immutable so replace the whole entry for
each Char if you need to modify.
"""
PartRange = Dict{Char, @NamedTuple{min::Int, max::Int}}
function new_partrange(min::Int, max::Int)
    p = PartRange()
    for c in ['x', 's', 'm', 'a']
        p[c] = (; min=min, max=max)
    end
    return p
end

"""
Applies a Condition to a PartRange.  Returns one or two
PartRanges in a Vector.  The first is the range that satisfies
the Condition, the second is the range that doesn't.  `nothing`
is returned for any PartRange that vanishes.
"""
function process_condition(cond::Condition, pr::PartRange)
    newmin = Vector{Int}(undef, 2)
    newmax = Vector{Int}(undef, 2)
    if cond.operator == '>'
        newmin[1] = max(pr[cond.variable].min, cond.value + 1)
        newmax[1] = pr[cond.variable].max
        newmin[2] = pr[cond.variable].min
        newmax[2] = min(pr[cond.variable].max, cond.value)
    else
        newmin[1] = pr[cond.variable].min
        newmax[1] = min(pr[cond.variable].max, cond.value - 1)
        newmin[2] = max(pr[cond.variable].min, cond.value)
        newmax[2] = pr[cond.variable].max
    end
    return map([m for m in zip(newmin, newmax)]) do m
        if m[1] > m[2]
            return nothing
        end
        pr2 = copy(pr)
        pr2[cond.variable] = (; min=m[1], max=m[2])
        return pr2
    end
end

"""
Recursively process the workflows, accumulating the accepted
PartRanges as we go.

Hindsight suggests using the Part1 idea of having the final
Workflow rule might have worked well here, to avoid the
repetition of code after the loop.
"""
function process_workflow(workflow::Workflow, pr::PartRange,
    all_workflows::Dict{AbstractString, Workflow})
    accepted_prs = Vector{PartRange}()
    cur_pr = pr
    for r in workflow.rules
        if isnothing(cur_pr)
            break
        end
        (pass_pr, cur_pr) = process_condition(r.condition, cur_pr)
        if !isnothing(pass_pr)
            if r.workflow == "A"
                push!(accepted_prs, pass_pr)
            elseif r.workflow != "R"
                append!(accepted_prs,
                    process_workflow(
                        all_workflows[r.workflow],
                        pass_pr,
                        all_workflows,
                    )
                )
            end
        end
    end
    if !isnothing(cur_pr)
        if workflow.final_workflow == "A"
            push!(accepted_prs, cur_pr)
        elseif workflow.final_workflow != "R"
            append!(accepted_prs,
                process_workflow(
                    all_workflows[workflow.final_workflow],
                    cur_pr,
                    all_workflows,
                )
            )
        end
    end
    return accepted_prs
end

"""
Return the product of the ranges in `pr`
"""
function count_range(pr::PartRange)
    tot = 1
    for c in ['x', 'm', 's', 'a']
        tot *= (pr[c].max - pr[c].min + 1)
    end
    return tot
end

"""
Now must have PartRanges that are processed with the Workflows.
When a Condition is applied to a PartRange we end up with 1 or 2
PartRanges.
"""
function main(filename::AbstractString)
    file = open(filename)
    workflows = parse_workflows(file)
    start_pr = new_partrange(1, 4000)
    accepted_ranges = process_workflow(
        workflows["in"],
        start_pr,
        workflows,
    )
    tot = 0
    for pr in accepted_ranges
        tot += count_range(pr)
    end
    println("Ans 1: $tot")
end

"""
Read the input file, parse and return
a Vector of Workflows.
"""
function parse_workflows(file::IOStream)
    workflows = Dict{AbstractString, Workflow}()
    l = readline(file)
    while l != ""
        rules = Vector{Rule}()
        m = match(r"(\w+)\{(.*),(\w+)\}", l)
        workflow_name = m.captures[1]
        for rl in eachsplit(m.captures[2], ',')
            m1 = match(r"([asmx])([><])(\d+):(\w+)", rl)
            rule = Rule(
                m1.captures[1],
                m1.captures[2],
                parse(Int, m1.captures[3]),
                m1.captures[4],
            )
            push!(rules, rule)
        end
        workflows[workflow_name] = Workflow(rules, m.captures[3])
        l = readline(file)
    end
    return workflows
end

if !isinteractive()
    main(ARGS[1])
end
