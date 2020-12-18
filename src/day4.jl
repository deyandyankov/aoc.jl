# https://adventofcode.com/2020/day/4
abstract type Day4 <: AocDay end
day4 = Day4


function parsepassport(entry)
    kv = [split(e, ":") for e in split(entry, " ")]
    pd = Dict(zip([i[1] for i in kv], [i[2] for i in kv]))
    pd
end

function valid_passport(pd)
    expected_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    for k in expected_keys
        if !(k in keys(pd))
            return false
        end
    end
    return true
end

function valid_byr(x)
    x = parse(Int, x)
    x >= 1920 && x <= 2002
end

function valid_iyr(x)
    x = parse(Int, x)
    x >= 2010 && x <= 2020
end

function valid_eyr(x)
    x = parse(Int, x)
    x >= 2020 && x <= 2030
end

function valid_hgt(x)
    m = match(r"^(?<number>\d+)(?<metric>(cm|in))$", x)
    n = parse(Int, m["number"])
    if m["metric"] == "cm"
        return n >= 150 && n <= 193
    end
    if m["metric"] == "in"
        return n >= 59 && n <= 76
    end
    return false
end

valid_hcl(x) = typeof(match(r"^#[a-f0-9]{6}$", x)) == RegexMatch
valid_ecl(x) = x in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
valid_pid(x) = typeof(match(r"^[0-9]{9}$", x)) == RegexMatch


function valid_passport_part2(pd)
    try
        valid_passport(pd) || return false
        valid_byr(pd["byr"]) || return false
        valid_iyr(pd["iyr"]) || return false
        valid_eyr(pd["eyr"]) || return false
        valid_hgt(pd["hgt"]) || return false
        valid_hcl(pd["hcl"]) || return false
        valid_ecl(pd["ecl"]) || return false
        valid_pid(pd["pid"]) || return false
    catch e
        return false
    end
    return true
end

function readinput(::Type{Day4})
    contents = read("input/day4.txt", String)
    entries = split(contents, "\r\n\r\n")
    entries = [replace(entry, "\r\n" => " ") for entry in entries]

    passports = map(parsepassport, entries)
    passports
end


function solve(day::Type{Day4})
    input = readinput(day)
    valid_passports = input[map(valid_passport, input)]
    length(valid_passports)
end

function solve_part2(day::Type{Day4})
    input = readinput(day)
    valid_passports = input[map(valid_passport_part2, input)]
    length(valid_passports)
end
