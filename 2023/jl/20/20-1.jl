import DataStructures
"""
A pulse that we're to process.
"""
struct Pulse
    value::Int
    source::AbstractString
    target::AbstractString
end

const pulses = DataStructures.Deque{Pulse}()
const pulse_counts = zeros(Int, 2)

"""
Supertype of all communication modules.
"""
abstract type CommModule end
function process_pulse(pulse::Pulse, modl::CommModule)
end

"""
Flip-flop modules (prefix %) are either on or off; they are initially off. If a
flip-flop module receives a high pulse, it is ignored and nothing happens.
However, if a flip-flop module receives a low pulse, it flips between on and
off. If it was off, it turns on and sends a high pulse. If it was on, it turns
off and sends a low pulse.
"""
mutable struct FlipFlopModule <: CommModule
    name::AbstractString
    state::Int
    outputs::Vector{AbstractString}
end
function process_pulse(pulse::Pulse, modl::FlipFlopModule)
    if pulse.value == 1
        return
    end
    modl.state = modl.state ⊻ 1
    output_pulse(modl.state, modl)
end

"""
Conjunction modules (prefix &) remember the type of the most recent pulse
received from each of their connected input modules; they initially default to
remembering a low pulse for each input. When a pulse is received, the
conjunction module first updates its memory for that input. Then, if it
remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends
a high pulse.
"""
struct ConjunctionModule <: CommModule
    name::AbstractString
    inputs::Dict{AbstractString, Int}
    outputs::Vector{AbstractString}
end
ConjunctionModule(name::AbstractString, outputs::Vector{<:AbstractString}) =
    ConjunctionModule(name::AbstractString, Dict{AbstractString, Int}(), outputs)
function process_pulse(pulse::Pulse, modl::ConjunctionModule)
    modl.inputs[pulse.source] = pulse.value
    if all(i->i == 1, values(modl.inputs))
        output_pulse(0, modl)
    else
        output_pulse(1, modl)
    end
end

"""
There is a single broadcast module (named broadcaster). When it receives a
pulse, it sends the same pulse to all of its destination modules.
"""
struct BroadcastModule <: CommModule
    name::AbstractString
    outputs::Vector{AbstractString}
end
function process_pulse(pulse::Pulse, modl::BroadcastModule)
    output_pulse(pulse.value, modl)
end

"""
Here at Desert Machine Headquarters, there is a module with a single button on
it called, aptly, the button module. When you push the button, a single low
pulse is sent directly to the broadcaster module.
"""
struct ButtonModule <: CommModule
    name::AbstractString
    outputs::Vector{AbstractString}
end
function process_pulse(pulse::Pulse, modl::ButtonModule)
    output_pulse(0, modl)
end

"""
Untyped module, doesn't do anything.
"""
struct UntypedModule <: CommModule
    name::AbstractString
    outputs::Vector{AbstractString}
end
UntypedModule(name::AbstractString) =
    UntypedModule(name, Vector{AbstractString}())

"""
A module emits a Pulse to each of its outputs.
"""
function output_pulse(value::Int, modl::CommModule)
    for s in modl.outputs
        push!(pulses, Pulse(value, modl.name, s))
        pulse_counts[value+1] += 1
    end
#    println("$(modl.name) [$(value)]-> $(modl.outputs)")
end


"""
Read the given file, output a dictionary containing all the modules.
"""
function parse_input(filename::AbstractString)
    modules = Dict{AbstractString, CommModule}()
    # Read the file
    file = open(filename)
    modules["button"] = ButtonModule("button", ["broadcaster"])
    for line in eachline(file)
        (mod_name, destinations) = split(line, " -> ")
        if startswith(mod_name, "%")
            @views mod_name = mod_name[2:end]
            modl = FlipFlopModule(mod_name, 0, split(destinations, ", "))
        elseif startswith(mod_name, "&")
            @views mod_name = mod_name[2:end]
            modl = ConjunctionModule(mod_name, split(destinations, ", "))
        elseif mod_name == "broadcaster"
            modl = BroadcastModule(mod_name, split(destinations, ", "))
        elseif mod_name == "button"
            modl = ButtonModule(mod_name, ["broadcaster"])
        end
        modules[mod_name] = modl
    end
    # For the ConjunctionModules, tot up all the inputs for each and
    # add to its inputs field.
    for (modl_name, modl) in modules
        for c in modl.outputs
            if !haskey(modules, c)
                modules[c] = UntypedModule(c)
            end
            if isa(modules[c], ConjunctionModule)
                modules[c].inputs[modl_name] = 0
            end
        end
    end
    return modules
end

function main(filename::AbstractString)
    modules = parse_input(filename)
    i = 0
    while i < 1000
        push!(pulses, Pulse(0, "", "button"))
        push_button(modules)
        i += 1
    end
#    println("$(pulse_counts[1]) low and $(pulse_counts[2]) high")
    println("Ans 1: $(prod(pulse_counts))")
end

function push_button(
    modules::Dict{AbstractString, CommModule}
)
    while !isempty(pulses)
        pulse = popfirst!(pulses)
        process_pulse(pulse, modules[pulse.target])
    end
end

if !isinteractive()
    main(ARGS[1])
end
