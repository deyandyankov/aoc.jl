abstract type Day5 <: AocDay end
day5 = Day5

function readinput(day::Type{Day5})
    input = readlines("input/day5.txt")

end

function getrowbybp(bp)
    rowinfo = bp[1:7]
    range_start = 0
    range_end = 127
    mid = convert(Int, round(length(range_start:range_end) / 2))
    for r in rowinfo
        if r == 'F'
            range_end -= mid
        end
        if r == 'B'
            range_start += mid
        end
        mid = convert(Int, round(length(range_start:range_end) / 2))
    end
    range_start
end

function getcolbybp(bp)
    colinfo = bp[8:10]
    range_start = 0
    range_end = 7
    mid = convert(Int, round(length(range_start:range_end) / 2))
    for c in colinfo
        if c == 'L'
            range_end -= mid
        end
        if c == 'R'
            range_start += mid
        end
        mid = convert(Int, round(length(range_start:range_end) / 2))
    end
    range_start
end

function getseat(bp)
    row = getrowbybp(bp)
    col = getcolbybp(bp)
    seat = row * 8 + col
    Dict(:row => row, :col => col, :seat => seat)
end

function solve(day::Type{Day5})
    input = readinput(day)
    rcs = getseat.(input)
    maximum(map(x->x[:seat], rcs))
end

function solve_part2(day::Type{day5})
    input = readinput(day)
    rcs = getseat.(input)
    plane_seats = sort([r[:seat] for r in rcs])
    min_plane_seat, max_plane_seat = minimum(plane_seats), maximum(plane_seats)
    full_range = collect(min_plane_seat:max_plane_seat)

    for seat in full_range
        if !(seat in plane_seats)
            return seat
        end
    end
end
