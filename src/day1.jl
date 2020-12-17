# https://adventofcode.com/2020/day/1
abstract type Day1 <: AocDay end
day1 = Day1

function readinput(::Type{Day1})
    input = parse.(Int, readlines("input/day1.txt"))
    input
end

function entries_sum_to(input, s)
    unique_input = unique(input)
    for entries in Iterators.product(unique_input, unique_input)
        if entries[1] + entries[2] == s
            return entries
        end
    end
end

function entries_sum_to_part2(input, s)
    unique_input = unique(input)
    for entries in Iterators.product(unique_input, unique_input, unique_input)
        if entries[1] + entries[2] + entries[3] == s
            return entries
        end
    end
end

function solve(day::Type{Day1})
    input = readinput(day)
    
    entries = entries_sum_to(input, 2020)
    result = entries[1] * entries[2]
    result
end

function part2(day::Type{Day1})
    input = readinput(day)
    
    entries = entries_sum_to_part2(input, 2020)
    result = entries[1] * entries[2] * entries[3]
    result
end