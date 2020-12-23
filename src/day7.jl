abstract type Day7 <: AocDay end
day7 = Day7

using LightGraphs
using MetaGraphs
using GraphPlot
using StatsBase
using SimpleWeightedGraphs

function readinput(day::Type{Day7})
    rules = readlines("input/day7.txt")
    parsed_rules = parse_rule.(rules)
    parsed_rules
end

function parse_rule(rule)
    # extract container
    re = r"^(?<container>.*) bags contain"
    m = match(re, rule)

    # extract contents
    container = m["container"]
    contents = replace(rule, container * " bags contain " => "")
    contents = contents[1:end-1] # strip dot at the end
    contents = split(contents, ", ")
    contents = [replace(c, r" bags?" => "") for c in contents]
    labels = [string(container)]
    if contents != ["no other"]
        for bagtype in contents
            m = match(r"^(?<num>\d+) (?<bt>.*)$", bagtype)
            for i in 1:parse(Int, m["num"])
                push!(labels, string(m["bt"]))
            end
        end
    end

    labels
end

get_nodelabels_from_idv(idv) = [string(i) * " " * idv[2][i] for i in sort(collect(keys(idv[2])))]

function get_graph(r)
    vertices = first.(r);
    idv = [
        Dict(j => i for (i, j) in enumerate(vertices)),
        Dict(i => j for (i, j) in enumerate(vertices))
    ]
    bag_contents = Dict(i[1] => countmap(i[2:end]) for i in r)
    edges = Dict(i[1] => countmap(i[2:end]) for i in r)
    g = SimpleWeightedDiGraph(length(vertices))
    for (k, v) in bag_contents
        src_id = idv[1][k]
        for (kk, vv) in v
            dst_id = idv[1][kk]
            weight = vv
            for w in 1:weight
                add_edge!(g, src_id, dst_id, w)
            end
        end
    end
    (idv, g)
end

function solve(day::Type{Day7})
    r = readinput(day)
    idv, g = get_graph(r)
    nodelabels = get_nodelabels_from_idv(idv)
    starting_vertex = idv[1]["shiny gold"]
    ps = []
    function traverse_until_outer(g, vertex, path)
        parents = inneighbors(g, vertex)
        for p in parents
            push!(ps, p)
        end
        length(parents) == 0 && return path
        [traverse_until_outer(g, parent, [path; parent]) for parent in parents]
    end
    traverse_until_outer(g, starting_vertex, [])
    ps |> unique |> length
end

function solve_part2(day::Type{Day7})
    r = readinput(day)
    idv, g = get_graph(r)
    nodelabels = get_nodelabels_from_idv(idv)

    starting_vertex = idv[1]["shiny gold"]
    cs = []
    function traverse_in(g, vertex, path)
        @show path
        children = outneighbors(g, vertex)
        for c in children
            w = g.weights[c, vertex]
            #@show [c, w]
            push!(cs, [length(path), c, w])
        end
        length(children) == 0 && return path
        [traverse_in(g, child, [path; child]) for child in children]
    end
    traverse_in(g, starting_vertex, [starting_vertex])
    s = 0
    for (idx, (level, v, w)) in enumerate(cs)
        #@show idx, level, v, w
        s += w^level
    end
    return r, idv, g, s

end
