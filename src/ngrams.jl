include("compress.jl")

function normalize_text(text; blacklist=String[])
    text = replace(text, r"https?://[-_.?&~;+=/#0-9A-Za-z]{1,2076}" => " ")
    text = replace(text, r"[-_.0-9A-Za-z]{1,64}@[-_0-9A-Za-z]{1,255}[-_.0-9A-Za-z]{1,255}" => " ")
    text = replace(text, r"[^\p{L}]" => " ")
    text = " $text "
    text = lowercase(text)
    for w in blacklist
        text = replace(text, w => " ")
    end
    text = replace(text, r"\s\s+" => " ")
end
function count_ngrams(text::AbstractString, n, counter=Dict{Vector{UInt8},Float32}())
    text = transcode(UInt8, string(text))
    for i in 1:length(text)-n+1
        p = text[i:i+n-1]
        counter[p] = get(counter, p, 0.0) + 1.0
    end
    counter
end
function count_all_ngrams(text::AbstractString, rg::AbstractRange=1:5, counter=Dict{Vector{UInt8},Float32}(); kwargs...)
    text = normalize_text(text; kwargs...)
    text = transcode(UInt8, string(text))
    for k in rg
        for i in 1:length(text)-k+1
            p = text[i:i+k-1]
            counter[p] = get(counter, p, 0.0) + 1.0
        end
    end
    counter
end
function count_all_ngrams(text::AbstractString, n::Int, counter=Dict{Vector{UInt8},Float32}(); kwargs...)
    count_all_ngrams(text, 1:n, counter; kwargs...)
end


function count_dataset_ngrams(dataset, n; kwargs...)
    counters = [Dict{Vector{UInt8},Float32}() for i in 1:n]
    for (text, lang) in dataset
        text = normalize_text(text; kwargs...)
        for i in 1:n
            count_ngrams(text, i, counters[i])
        end
    end
    counters
end

function count_dataset_all_ngrams(dataset, n; kwargs...)
    counter = Dict{Vector{UInt8},Float32}()
    for (text, lang) in dataset
        count_all_ngrams(text, n, counter; kwargs...)
    end
    counter
end

function dump_ngram_table(head::Vector{Float32}, D, filename; compress_level=63)
    Z1, Z2 = RLCS(compress_level), RLCS(compress_level)
    open(filename, "w") do f
        write(f, "total:")
        write(f, join(head, ","))
        write(f, "\n")
        last_v = 0.0
        for (k, v) in D
            @assert k isa Vector{UInt8}
            k = join(string.(k, base=16), "")
            kz = rlcs_zip(Z1, k)
            write(f, kz)
            if last_v != v
                last_v = v
                write(f, ",")
                vstr = string(v)
                vstrz = rlcs_zip(Z2, vstr)
                write(f, vstrz)
            end
            write(f, "\n")
        end
    end
end

function ngram_table(filename)
    el = eachline(filename)
    l1 = first(el)
    hd = parse.(Float32, split(split(l1, ":")[end], ",", keepempty=false))
    function producer(c::Channel)
        Z1, Z2 = RLCS(), RLCS()
        last_v = 0.0
        for line in el
            kz_v = split(line, ",")
            if length(kz_v) == 1
                kz, v = kz_v[1], last_v
            else
                kz, vstrz = kz_v
                vstr = rlcs_unzip(Z2, vstrz)
                v = parse(Float32, vstr)
                last_v = v
            end
            k = rlcs_unzip(Z1, kz)
            @assert iseven(length(k))
            k = parse.(UInt8, Iterators.partition(string(k), 2), base=16)
            put!(c, k => v)
        end
    end
    hd, Channel(producer)
end

function load_ngram_table(filename)
    hd, tb = ngram_table(filename)
    hd, collect(tb)
end
