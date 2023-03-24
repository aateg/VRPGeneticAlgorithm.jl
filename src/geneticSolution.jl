using StatsBase: sample
using Random: rand, AbstractRNG

struct Chromosome
    requests::Vector{Int64}
    vehicles::Vector{Int64}
end

# Crossover --------------------------------------------------
function crossover(
    chromosome::Chromosome,
    other::Chromosome,
    maxCrossLen::Float64,
    requestsWithRepetition::Bool = false,
    rng::AbstractRNG,
)
    N = length(chromosome.requests)

    # Select a random section of the chromosome
    len = floor(Int, min(N * maxCrossLen))     # length of the crossover section
    start = floor(Int, rand(rng, 1:(N-len)))     # starting index of the crossover section

    # cross the material
    if requestsWithRepetition
        newRequests =
            crossVectorsWithRepetition(chromosome.requests, other.requests, start, len)
    else
        newRequests = crossVectors(chromosome.requests, other.requests, start, len)
    end
    newVehicles =
        crossVectorsWithRepetition(chromosome.vehicles, other.vehicles, start, len)

    return Chromosome(newRequests, newVehicles)
end

function crossVectorsWithRepetition(
    v1::Vector{Int64},
    v2::Vector{Int64},
    start::Int64,
    len::Int64,
)
    v3 = copy(v1)
    v3[start:start+len-1] = v2[start:start+len-1]
    return v3
end

function crossVectors(v1::Vector{Int64}, v2::Vector{Int64}, start::Int64, len::Int64)
    # PMX Crossover
    N = length(v1)
    v3 = Vector{Int64}(undef, N)

    # cross the material
    v3[start:start+len-1] = v2[start:start+len-1]

    idx = 1
    for x in v1
        if start <= idx < start + len
            idx = start + len
        end

        if x ∉ v3[start:start+len-1]
            v3[idx] = x
            idx += 1
        end
    end
    return v3
end

# Mutation ---------------------------------------------------

function mutate!(chromosome::AbstractChromosome, rng::AbstractRNG)
    idx1, idx2 = sample(rng, 1:length(chromosome.requests), 2, replace = false)
    chromosome.requests[idx1], chromosome.requests[idx2] =
        chromosome.requests[idx2], chromosome.requests[idx1]
    chromosome.vehicles[idx1], chromosome.vehicles[idx2] =
        chromosome.vehicles[idx2], chromosome.vehicles[idx1]
end
