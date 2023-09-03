include("ngrams.jl")
const PACKAGE_PATH = pkgdir(LanguageIdentification)
const PROFILE_PATH = joinpath(PACKAGE_PATH, "profiles")
const ALL_LANGUAGES = [f[1:end-4] for f in readdir(PROFILE_PATH)]
const LANGUAGES = String[]
const PROFILES = Vector{Dict{Vector{UInt8},Float32}}()
const UNK = UInt8[]
NGRAM::UnitRange{Int64} = 0:0

"""
supported_languages() -> Vector{String}

Return a vector containing all the languages (ISO 639-3 codes) that are supported by this package. 
"""
function supported_languages()
    return ALL_LANGUAGES
end
"""
The function `vocabulary_sizes()` returns the sizes of the vocabulary for each language that was loaded by the [`initialize`](@ref) function.
"""
function vocabulary_sizes()
    [lang => length(PROFILES[i]) for (i, lang) in enumerate(LANGUAGES)]
end

"""
    initialize(; languages=supported_languages(), ngram=4, cutoff=0.85, vocabulary=100000)

Initialize the language detector with the given parameters. Different parameters have different balances among accuracy, speed, and memory usage. 

# Arguments
- `languages::Vector{String}`: A list of languages to be used for language detection. If this argument is not provided, all the languages returned by the [`supported_languages`](@ref) function will be used.
- `ngram::Union{Int, AbstractRange}`: The length of utf-8 byte n-grams to use for language detection. A range can be provided to use multiple n-gram sizes. An integer value will be converted to a range from 1 to the given value. The default value is 4.
- `cutoff::Float64`: The cutoff value of the cumulative probability of the n-grams to use for language detection. The default value is 0.85, and it must be between 0 and 1.
- `vocabulary::Union{Int, AbstractRange}`: The size range of the vocabulary of each language. The default value is 1000:5000.
"""
function initialize(; languages=supported_languages(), ngram=4, cutoff=0.85, vocabulary=1000:5000)
    ngram = ngram isa AbstractRange ? ngram : 1:ngram
    vocabulary = vocabulary isa AbstractRange ? vocabulary : 1:vocabulary
    empty!(LANGUAGES)
    append!(LANGUAGES, languages)
    empty!(PROFILES)
    for lang in LANGUAGES
        push!(PROFILES, load_profile(lang, ngram, cutoff, vocabulary))
    end
    unk_decay = 0.01
    for P in PROFILES
        logp = minimum(values(P), init=typemax(Float32)) + log(unk_decay)
        P[UNK] = logp
    end
    global NGRAM = ngram
    nothing
end

function makesure_initialized()
    if length(LANGUAGES) == 0
        @info "Initializing with default parameters."
        initialize()
    end
end

function load_profile(lang, ngramrange::AbstractRange, cutoff, vocabularyrange)
    vocmin, vocmax = first(vocabularyrange), last(vocabularyrange)
    hd, rows = ngram_table(joinpath(PROFILE_PATH, lang * ".txt"))
    total = sum(hd[ngramrange])
    threshold = cutoff * total
    cums = 0.0
    P = Pair{Vector{UInt8},Float32}[]
    for (k, v) in rows
        if length(k) in ngramrange
            cums += v
            push!(P, k => v)
            if (length(P) >= vocmin) && (cums >= threshold || length(P) >= vocmax)
                break
            end
        end
    end
    # cums >= threshold || @info "$lang: cutoff($cutoff) not reached. current: $(cums / total). vocab size: $(length(P))"
    normalize_profile!(Dict(P))
end

function normalize_profile!(P)
    sums = zeros(7)
    for (k, v) in P
        sums[length(k)] += v
    end
    weights = log1p.(sums)
    weights .*= sum(weights .!= 0) / sum(weights) # mean(weights) == 1
    scale = weights ./ sums
    logscale = log.(scale)
    for (k, v) in P
        P[k] = log(v) + logscale[length(k)]
    end
    P
end

function loglikelihood(p_dict, logq_dict)
    sc = 0.0
    for (code, p) in p_dict
        if !haskey(logq_dict, code)
            code = UNK
        end
        logq = logq_dict[code]
        sc += p * logq
    end
    sc
end

"""
    langid(text::AbstractString, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; ngram=NGRAM)

Return the language of the given text based on the provided language profiles.

# Arguments
- `text::AbstractString`: The text to identify the language of.
- `languages::Vector{String}`: The list of languages to choose from. Omitting this argument will use all supported languages.
- `profiles::Vector{Dict{Vector{UInt8}, Float32}}`: The language profiles to use for identification. Omitting this argument will use the default profiles.
- `ngram::Union{Int, AbstractRange}`: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in [`initialize`](@ref), and should not exceed that value.
# Returns
- The language of the given text.
"""
function langid(text::AbstractString, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8},Float32}}; ngram=NGRAM)
    p = count_all_ngrams(text, ngram)
    lls = loglikelihood.(Ref(p), profiles)
    languages[argmax(lls)]
end
function langid(text::AbstractString, languages::Vector{String}; kwargs...)
    makesure_initialized()
    inds = [findfirst(isequal(l), LANGUAGES) for l in languages]
    langid(text, languages, PROFILES[inds]; kwargs...)
end
function langid(text::AbstractString; kwargs...)
    makesure_initialized()
    langid(text, LANGUAGES, PROFILES; kwargs...)
end

"""
    langprob(text::AbstractString, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; topk=5, ngram=NGRAM)

Returns the probability distribution of the language of the given text based on the provided language profiles.

# Arguments
- `text::AbstractString`: The text to identify the language of.
- `languages::Vector{String}`: A list of languages to choose from. If this argument is not provided, all the languages returned by the [`supported_languages`](@ref) function will be used.
- `profiles::Vector{Dict{Vector{UInt8}, Float32}}`: The language profiles to use for identification. If this argument is not provided, the default profiles will be used.
- `topk::Int`: The number of candidates to return. The default value is 5.
- `ngram::Union{Int, AbstractRange}`: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in [`initialize`](@ref), and should not exceed that value.

# Returns
- A list of the `topk` languages and their probabilities.
"""
function langprob(text::AbstractString, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8},Float32}}; topk=5, ngram=NGRAM)
    p = count_all_ngrams(text, ngram)
    vs = sum(values(p))
    map!(v -> v / vs, values(p))
    lls = loglikelihood.(Ref(p), profiles)
    ls = exp.(lls)
    ls = ls ./ sum(ls)
    si = sortperm(ls, rev=true)[1:min(end, topk)]
    [k => v for (k, v) in zip(languages[si], ls[si])]
end
function langprob(text::AbstractString, languages::Vector{String}; kwargs...)
    makesure_initialized()
    inds = [findfirst(isequal(l), LANGUAGES) for l in languages]
    langprob(text, languages, PROFILES[inds]; kwargs...)
end
function langprob(text::AbstractString; kwargs...)
    makesure_initialized()
    langprob(text, LANGUAGES, PROFILES; kwargs...)
end
