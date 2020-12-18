# https://adventofcode.com/2020/day/3
abstract type Day3 <: AocDay end
day3 = Day3

struct InputDay3
    m::BitArray{2}
end

function readinput(::Type{Day3})
    lines = readlines("input/day3.txt")
    m = [collect(line) .== '#' for line in lines]
    InputDay3(vcat(m'...))
end

function traverse(input::InputDay3, step)
    path = []
    m, n = size(input.m)
    idx = [1, 1]
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

function solve(day::Type{Day3})
    input = readinput(day)
    path = traverse(input, [1, 3])
    sum(path)
end

function solve_part2(day::Type{Day3})
    input = readinput(day)
    steps = [
        [1, 1],
        [1, 3],
        [1, 5],
        [1, 7],
        [2, 1]
    ]
    path = 1
    for step in steps
        path *= sum(traverse(input, step))
    end
    path
end
