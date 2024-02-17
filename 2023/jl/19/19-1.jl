"""

So "x>10" becomes variable='x', operator=>, value=10
"""
struct Condition
    variable::Symbol
    operator::Function
    value::Int
end

"""
A Rule contains a condition and a workflow, which is where to go if the
condition is met.  If the condition is Nothing then it always evaluates true.
"""
struct Rule
    condition::Union{Condition, Nothing}
    workflow::AbstractString
end
Rule(ch::AbstractString, f::Function, i::Int, s::AbstractString) = 
    Rule(Condition(Symbol(ch[1]), f, i), s)
Rule(s::AbstractString) = Rule(nothing, s)

struct Workflow
    rules::Vector{Rule}
end

"""
A Part represents a part to be processed.
"""
Part = @NamedTuple{x::Int, m::Int, a::Int, s::Int}

function process_condition(part::Part, cond::Condition)
    return cond.operator(
        getfield(part, cond.variable),
        cond.value
    )
end

function process_condition(part::Part, cond::Nothing)
    return true
end

"""
Returns the result for part traversing workflow.  Return value is a
String, either the next workflow or "R" or "A".
"""
function process_workflow(part::Part, workflow::Workflow)
    for rule in workflow.rules
        if process_condition(part, rule.condition)
            return rule.workflow
        end
    end
    @assert false "Shouldn't be able to reach here"
end

"""
Then, each part is sent through a series of workflows that will ultimately
accept or reject the part. Each workflow has a name and contains a list of
rules; each rule specifies a condition and where to send the part if the
condition is true. The first rule that matches the part being considered is
applied immediately, and the part moves on to the destination described by the
rule. (The last rule in each workflow has no condition and always applies if
reached.)

Consider the workflow ex{x>10:one,m<20:two,a>30:R,A}. This workflow is named ex
and contains four rules. If workflow ex were considering a specific part, it
would perform the following steps in order:

    Rule "x>10:one": If the part's x is more than 10, send the part to the
    workflow named one.
    Rule "m<20:two": Otherwise, if the part's m is less than 20, send the part
    to the workflow named two.
    Rule "a>30:R": Otherwise, if the part's a is more than 30, the part is
    immediately rejected (R).
    Rule "A": Otherwise, because no other rules matched the part, the part is
    immediately accepted (A).
"""
function main(filename::AbstractString)
    file = open(filename)
    workflows = parse_workflows(file)
#    println(workflows)
    accepted_tot = 0
    for l in eachline(file)
#        println(l)
        s = l[2:end-1]
        bits = split.(split(s, ','), '=')
        part = Part(
            NamedTuple([Symbol(b[1]) => parse(Int, b[2]) for b in bits])
        )
        workflow = "in"
#        println("Doing $part")
        while workflow != "A" && workflow != "R"
#            println("Doing $workflow")
            workflow = process_workflow(part, workflows[workflow])
#            println("Got $workflow")
        end
        if workflow == "A"
            accepted_tot += sum(part)
        end
    end
    println("Answer 1: $accepted_tot")
end

"""
Read the input file, parse and return
a Vector of Workflows.
"""
function parse_workflows(file::IOStream)
    workflows = Dict{AbstractString, Workflow}()
    op_dict = Dict("<" => <, ">" => >)
    l = readline(file)
    while l != ""
        rules = Vector{Rule}()
        m = match(r"(\w+)\{(.*),(\w+)\}", l)
        workflow_name = m.captures[1]
        for rl in eachsplit(m.captures[2], ',')
            m1 = match(r"([asmx])([><])(\d+):(\w+)", rl)
            rule = Rule(
                m1.captures[1],
                op_dict[m1.captures[2]],
                parse(Int, m1.captures[3]),
                m1.captures[4],
            )
            push!(rules, rule)
        end
        push!(rules, Rule(m.captures[3]))
        workflows[workflow_name] = Workflow(rules)
        l = readline(file)
    end
    return workflows
end

if !isinteractive()
    main(ARGS[1])
end
