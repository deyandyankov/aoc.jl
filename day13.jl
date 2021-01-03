input = readlines("input/day13.txt")[2]
schedule = parse.(Int, replace(split(input, ","), "x" => "-1"))
bus_n = filter(!=(-1), schedule)
bus_dt = (1:length(schedule))[schedule .!= -1] .- 1
function find_seq_bus_arrivals(bus_n, bus_dt)
    inc = bus_n[1]
    n = 0
    for (i, offset) in zip(bus_n[2:end], bus_dt[2:end])
        while (n + offset) % i != 0
            n += inc
        end
        inc = lcm(inc, i)
    end
    return n
end

println(find_seq_bus_arrivals(bus_n, bus_dt))
