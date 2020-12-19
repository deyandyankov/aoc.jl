abstract type Day6 <: AocDay end
day6 = Day6

function readinput(day::Type{Day6})
    input = read("input/day6.txt", String)
    groupanswers = [[i for i in split(x, "\n") if i != ""] for x in split(input, "\n\n")]
    groupanswers
end

function countAs(input)
    length(unique(join(input)))
end

function count_part2(input)
    members = length(input)
    chars = join(input)
    cmap = Dict([(i, count(x -> x == i, chars)) for i in chars])
    ret = [cmap[x] == members for x in keys(cmap)]
    sum(ret)
end

function solve(day::Type{Day6})
    input = readinput(day)
    sum(countAs.(input))
end

function solve_part2(day::Type{day6})
    input = readinput(day)
    sum(count_part2.(input))
end
