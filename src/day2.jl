# https://adventofcode.com/2020/day/2
abstract type Day2 <: AocDay end
day2 = Day2

struct InputDay2
    min::Int64
    max::Int64
    sym::Char
    pwd::String
end

function readinput(::Type{Day2})
    input = readlines("input/day2.txt")
    r = r"^([0-9]*)-([0-9]*) (.*): (.*)$"
    captures = Array{InputDay2,1}(undef, length(input))
    for (idx, line) in enumerate(input)
        m = match(r, line)
        c = m.captures
        min = parse(Int, m.captures[1])
        max = parse(Int, m.captures[2])
        sym = only(m.captures[3])
        pwd = m.captures[4]
        t = InputDay2(min, max, sym, pwd)
        captures[idx] = t
    end
    captures
end

function valid(input::InputDay2)
    occurances = sum((c == input.sym for c in input.pwd))
    (occurances >= input.min) && (occurances <= input.max)
end

function valid_part2(input::InputDay2)
    pos1, pos2, c = input.min, input.max, input.sym
    xor(input.pwd[pos1] == c, input.pwd[pos2] == c)
end


function solve(day::Type{Day2})
    input = readinput(day)
    sum(valid.(input))
end


function part2(day::Type{Day2})
    input = readinput(day)
    sum(valid_part2.(input))
end