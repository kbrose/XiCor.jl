using Random
using Statistics
using Test
using XiCor

@testset "Matches reference implementation in R" begin
    @test xicor(1:50, 1:50) ≈ 0.9411765 atol=0.00001
    @test xicor(1:100, 1:100) ≈ 0.970297 atol=0.00001
    @test xicor([1, 2, 3, 4, 5], [1, 1, 2, 2, 3]) ≈ 0.53125 atol=0.00001
    @test xicor([1, 2], [1, 0]) ≈ 0 atol=0.00001
    @test xicor([3.4, 2.3, 4.5, 1.2], [9.8, 7.6, 8.7, 6.5]) ≈ 0.2 atol=0.00001

    # The next test has ties in the x variable, which require randomization
    # The tolerance for matching against the R implementation is going to be
    # much more lenient for this particular test.
    x = div.(1:100, 10)
    y = rand(MersenneTwister(0), 100)
    @test mean([xicor(x, y, true, MersenneTwister(i)) for i in 1:100_000]) ≈ 0.01972526 atol=0.001
end
