# https://adventofcode.com/2020/day/4
abstract type Day4 <: AocDay end
day3 = Day3

struct InputDay4
    m::BitArray{2}
end

function readinput(::Type{Day4})
    lines = readlines("input/day4.txt")
    m = [collect(line) .== '#' for line in lines]
    InputDay3(vcat(m'...))
end

function traverse(input::InputDay4)
    path = []
    m, n = size(input.m)
    idx = [1, 1]
    step = [1, 3]
    while idx[1] <= m
        r, c = idx
        if c > n
            c = c - n
            idx[2] = c
        end
        push!(path, input.m[r, c])
        idx = idx + step
    end
    path
end

function solve(day::Type{Day4})
    input = readinput(day)
    path = traverse(input)
    sum(path)
end
