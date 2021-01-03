module day14
using Test

function readinput(filename)
    input = readlines(filename)
    inputs = []
    mask_re = r"^mask = (.{31})$"
    mem_re = r"^mem\[([0-9]*)] = ([0-9]*)$"
    for i in input
        if occursin("mask", i)
            mask = [(idx, parse(Int, c)) for (idx, c) in enumerate(i[8:end]) if c ∈ ['0', '1']]
            push!(inputs, mask)
        end
        m = match(mem_re, i)
        if !(m isa Nothing)
            push!(inputs, [parse(Int, m[1]), parse(Int, m[2])])
        end
    end
    inputs
end

genval(x) = digits(x, base=2, pad=36) |> reverse
bitarray2int(x) = sum(2^(i-1)*σ for (i, σ) in enumerate(reverse(x)))
function maskit(x, mask)
    b = genval(x)
    for (idx, val) in mask
        b[idx] = val
    end
    bitarray2int(b)
end

function solve(filename)
    input = readinput(filename)
    mem = Dict{Int64,Int64}()
    current_mask = []
    for i in input
        if isa(i[1], Int)
            mem[i[1]] = maskit(i[2], current_mask)
        else
            current_mask = i
            continue
        end
    end
    sum(values(mem))
end

@testset "solve" begin
    arg = "input/day14.txt"
    @test solve(arg) == 11179633149677
end


@testset "genval" begin
    @test genval(11)[end-4:end] == [0, 1, 0, 1, 1]
end

@testset "readinput" begin
    arg = "input/day14-test.txt"
    res = [
        [(30, 1), (35, 0)],
        [8, 11],
        [7, 101],
        [8, 0]
    ]
    @test readinput(arg) == res
end

end
