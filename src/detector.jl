include("ngrams.jl")
const PACKAGE_PATH = pkgdir(LanguageIdentification)
const PROFILE_PATH = joinpath(PACKAGE_PATH, "profiles")
const ALL_LANGUAGES = [f[1:end-4] for f in readdir(PROFILE_PATH)]
const LANGUAGES = String[]
const PROFILES = Vector{Dict{Vector{UInt8},Float32}}()
const UNK = UInt8[]
const NGRAM = Int[]

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
    initialize(; languages=supported_languages(), ngram=1:4, cutoff=0.85, vocabulary=1000:5000)

Initialize the language detector with the given parameters. Different parameters have different balances among accuracy, speed, and memory usage. 

# Arguments
- `languages::Vector{String}`: A list of languages to be used for language detection. If this argument is not provided, all the languages returned by the [`supported_languages`](@ref) function will be used.
- `ngram::Union{Int, AbstractVector}`: Specifies the length of UTF-8 byte n-grams to be utilized for language detection. An integer value can be provided to use a single n-gram size, while a range can be provided to use multiple n-gram sizes. The default value is `1:4`, and the maximum value allowed is `7`.
- `cutoff::Float64`: The cutoff value of the cumulative probability of the n-grams to use for language detection. The default value is `0.85`, and it must be between `0` and `1`.
- `vocabulary::Union{Int, AbstractRange}`: The size range of the vocabulary of each language. The default value is `1000:5000`.
"""
function initialize(; languages=supported_languages(), ngram=1:4, cutoff=0.85, vocabulary=1000:5000, path=PROFILE_PATH)
    vocabulary = vocabulary isa AbstractRange ? vocabulary : vocabulary:vocabulary
    ngram = ngram isa AbstractVector ? ngram : ngram:ngram
    empty!(NGRAM)
    append!(NGRAM, ngram)
    empty!(LANGUAGES)
    append!(LANGUAGES, languages)
    empty!(PROFILES)
    for lang in LANGUAGES
        push!(PROFILES, load_profile(lang, NGRAM, cutoff, vocabulary; path=path))
    end
    unk_decay = 0.01
    for P in PROFILES
        logp = minimum(values(P), init=typemax(Float32)) + log(unk_decay)
        P[UNK] = logp
    end
    nothing
end

function makesure_initialized()
    if length(LANGUAGES) == 0
        @info "Initializing with default parameters."
        initialize()
    end
end

function load_profile(lang, ngram_list::AbstractVector, cutoff, vocabularyrange; path=PROFILE_PATH)
    vocmin, vocmax = first(vocabularyrange), last(vocabularyrange)
    hd, rows = ngram_table(joinpath(path, lang * ".txt"))
    total = sum(hd[ngram_list])
    threshold = cutoff * total
    cums = 0.0
    P = Pair{Vector{UInt8},Float32}[]
    for (k, v) in rows
        if length(k) in ngram_list
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
    vs = sum(values(P))
    map!(v -> log(v / vs), values(P))
    P
end

function loglikelihood(p_dict, logq_dict)
    sc = zero(valtype(p_dict))
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
    langid(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; ngram=NGRAM)

Return the language of the given text based on the provided language profiles.

# Arguments
- `text`: A string or a collection of strings to be analyzed for language identification.
- `languages::Vector{String}`: The list of languages to choose from. Omitting this argument will use all supported languages.
- `profiles::Vector{Dict{Vector{UInt8}, Float32}}`: The language profiles to use for identification. Omitting this argument will use the default profiles.
- `ngram::Union{Int, AbstractVector}`: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in [`initialize`](@ref), and should not exceed that value.
# Returns
- The language of the given text.
"""
function langid(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8},Float32}}; ngram=NGRAM)
    p = count_all_ngrams(text, ngram)
    lls = loglikelihood.(Ref(p), profiles)
    languages[argmax(lls)]
end
function langid(text, languages::Vector{String}; kwargs...)
    makesure_initialized()
    inds = [findfirst(isequal(l), LANGUAGES) for l in languages]
    langid(text, languages, PROFILES[inds]; kwargs...)
end
function langid(text; kwargs...)
    makesure_initialized()
    langid(text, LANGUAGES, PROFILES; kwargs...)
end

"""
    langprob(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; topk=5, ngram=NGRAM)

Returns the probability distribution of the language of the given text based on the provided language profiles.

# Arguments
- `text`: A string or a collection of strings to be analyzed for language identification.
- `languages::Vector{String}`: A list of languages to choose from. If this argument is not provided, all the languages returned by the [`supported_languages`](@ref) function will be used.
- `profiles::Vector{Dict{Vector{UInt8}, Float32}}`: The language profiles to use for identification. If this argument is not provided, the default profiles will be used.
- `topk::Int`: The number of candidates to return. The default value is 5.
- `ngram::Union{Int, AbstractVector}`: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in [`initialize`](@ref), and should not exceed that value.

# Returns
- A list of the `topk` languages and their probabilities.
"""
function langprob(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8},Float32}}; topk=5, ngram=NGRAM)
    p = count_all_ngrams(text, ngram)
    vs = sum(values(p))
    map!(v -> v / vs, values(p))
    lls = loglikelihood.(Ref(p), profiles)
    ls = exp.(lls)
    ls = ls ./ sum(ls)
    si = sortperm(ls, rev=true)[1:min(end, topk)]
    [k => v for (k, v) in zip(languages[si], ls[si])]
end
function langprob(text, languages::Vector{String}; kwargs...)
    makesure_initialized()
    inds = [findfirst(isequal(l), LANGUAGES) for l in languages]
    langprob(text, languages, PROFILES[inds]; kwargs...)
end
function langprob(text; kwargs...)
    makesure_initialized()
    langprob(text, LANGUAGES, PROFILES; kwargs...)
end
