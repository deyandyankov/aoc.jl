using aoc
using Test

@testset "aoc.jl" begin
    @test aoc.solve(aoc.day1) == 858496
    @test aoc.solve(aoc.day2) == 396
end
