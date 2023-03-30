using VRPGeneticAlgorithm
using Test

@testset "VRPGeneticAlgorithm.jl" begin
    # Write your tests here.

    @testset "Crossover" begin
        @testset "Test getRepetition" begin
            @test VRPGeneticAlgorithm.getRepetition([1, 1, 1, 2, 2, 2, 3, 3, 3], 3) ==
                  [3, 3, 3]
        end
        @testset "Requests with repetition" begin
            numberOfRequests = 3
            r1 = [1, 1, 1, 2, 2, 2, 3, 3, 3]
            r2 = [3, 3, 3, 2, 2, 2, 1, 1, 1]
            repetition = [3, 3, 3] # means that we have 3 requests repeated 3 times
            start = 3
            len = 4

            r3 = VRPGeneticAlgorithm.crossRequestsWithRepetition(
                r1,
                r2,
                repetition,
                start,
                len,
            )
            @test VRPGeneticAlgorithm.getRepetition(r3, numberOfRequests) == repetition
        end
    end
end
