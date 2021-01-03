module day14
using Test
using Debugger

function readinput(filename)
    input = readlines(filename)
    inputs = []
    mask_re = r"^mask = (.{31})$"
    mem_re = r"^mem\[([0-9]*)] = ([0-9]*)$"
    for i in input
        i[1] == "#" && continue
        if occursin("mask", i)
            maskliteral = i[8:end]
            mask = mask_from_literal(maskliteral)
            push!(inputs, mask)
        end
        m = match(mem_re, i)
        if !(m isa Nothing)
            push!(inputs, [parse(Int, m[1]), parse(Int, m[2])])
        end
    end
    inputs
end

mask_from_literal(x) = [(idx, c == 'X' ? -1 : parse(Int, c)) for (idx, c) in enumerate(x)]
all_perms(n) = Iterators.product(ntuple(_ -> [0,1], n)...)
int2mask(x) = digits(x, base=2, pad=36) |> reverse
bitarray2int(x) = sum(2^(i-1)*σ for (i, σ) in enumerate(reverse(x)))
mask2int(x) = [i[2] for i in x] |> bitarray2int

function maskit(x, mask)
    b = int2mask(x)
    for (idx, val) in mask
        b[idx] = val
    end
    bitarray2int(b)
end

function masks_from_mem_addr(mem_addr, current_mask)
    cm = deepcopy(current_mask)
    mem_addr_to_mask = int2mask(mem_addr)
    mem_addr_to_mask = zip(1:length(mem_addr_to_mask), mem_addr_to_mask) |> collect
    floating_bits = [(idx, bit) for (idx, bit) in cm if bit == -1]
    n_bits = length(floating_bits)
    perms = all_perms(n_bits)
    masks = []
    for perm in perms
        p = collect(perm)
        change = [(j[1], p[i]) for (i, j) in enumerate(floating_bits)]
        m = deepcopy(mem_addr_to_mask)
        for (i, v) in change
            m[i] = (i, v)
        end
        push!(masks, m)
    end
    masks
end

@testset "masks_from_mem_addr" begin
    mem_addr = 42
    mask_literal = "000000000000000000000000000000X1001X"
    current_mask = mask_from_literal(mask_literal)

    masks = masks_from_mem_addr(mem_addr, current_mask)
    @show masks
end

function solve(filename)
    input = readinput(filename)
    mem = Dict{Int64,Int64}()
    current_mask = []
    for i in input
        if isa(i[1], Int)
            mem_addr = i[1]
            val = i[2]
#            mem_addr_mask_literal = int2mask(mem_addr)
#            mem_addr_mask = zip(1:length(mem_addr_mask_literal), mem_addr_mask_literal) |> collect
            masks = masks_from_mem_addr(mem_addr, current_mask)
            @show mem_addr, current_mask
            for mask in masks
                @show mask
                new_mem_addr = mask2int(mask) #maskit(mem_addr, mask)
                @show new_mem_addr
#                @show mem_addr, new_mem_addr
            end
            #mem[mem_addr] = maskit(i[2], current_mask)
        else
            current_mask = i
            continue
        end
    end
    sum(values(mem))
end

@testset "solve" begin
    arg = "input/day14-test2.txt"
    solve(arg)
end


@testset "int2mask" begin
   @test int2mask(11)[end-4:end] == [0, 1, 0, 1, 1]
end

@testset "readinput" begin
    arg = "input/day14-test2.txt"
    res = readinput(arg)
#    @test res[1][end] == (36, -1)
#    @test res[2] == [42, 100]
#    @test res[4] == [26, 1]
end

end
