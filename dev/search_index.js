var documenterSearchIndex = {"docs":
[{"location":"#LanguageIdentification.jl-Documentation","page":"Index","title":"LanguageIdentification.jl Documentation","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"","category":"page"},{"location":"","page":"Index","title":"Index","text":"CurrentModule = LanguageIdentification\nDocTestSetup = quote\n    using LanguageIdentification\nend","category":"page"},{"location":"#Adding-LanguageIdentification.jl","page":"Index","title":"Adding LanguageIdentification.jl","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"using Pkg\nPkg.add(\"LanguageIdentification\")","category":"page"},{"location":"#Documentation","page":"Index","title":"Documentation","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Modules = [LanguageIdentification]","category":"page"},{"location":"#LanguageIdentification.initialize-Tuple{}","page":"Index","title":"LanguageIdentification.initialize","text":"initialize(; languages=supported_languages(), ngram=4, cutoff=0.85, vocabulary=100000)\n\nInitialize the language detector with the given parameters. Different parameters have different balances among accuracy, speed, and memory usage. \n\nArguments\n\nlanguages::Vector{String}: A list of languages to be used for language detection. If this argument is not provided, all the languages returned by the supported_languages function will be used.\nngram::Union{Int, AbstractVector}: Specifies the length of UTF-8 byte n-grams to be utilized for language detection. An integer value can be provided to use a single n-gram size, while a range can be provided to use multiple n-gram sizes. The default value is 1:4, and the maximum value allowed is 7.\ncutoff::Float64: The cutoff value of the cumulative probability of the n-grams to use for language detection. The default value is 0.85, and it must be between 0 and 1.\nvocabulary::Union{Int, AbstractRange}: The size range of the vocabulary of each language. The default value is 1000:5000.\n\n\n\n\n\n","category":"method"},{"location":"#LanguageIdentification.langid-Tuple{Any, Vector{String}, Vector{Dict{Vector{UInt8}, Float32}}}","page":"Index","title":"LanguageIdentification.langid","text":"langid(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; ngram=NGRAM)\n\nReturn the language of the given text based on the provided language profiles.\n\nArguments\n\ntext: A string or a collection of strings to be analyzed for language identification.\nlanguages::Vector{String}: The list of languages to choose from. Omitting this argument will use all supported languages.\nprofiles::Vector{Dict{Vector{UInt8}, Float32}}: The language profiles to use for identification. Omitting this argument will use the default profiles.\nngram::Union{Int, AbstractVector}: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in initialize, and should not exceed that value.\n\nReturns\n\nThe language of the given text.\n\n\n\n\n\n","category":"method"},{"location":"#LanguageIdentification.langprob-Tuple{Any, Vector{String}, Vector{Dict{Vector{UInt8}, Float32}}}","page":"Index","title":"LanguageIdentification.langprob","text":"langprob(text, languages::Vector{String}, profiles::Vector{Dict{Vector{UInt8}, Float32}}; topk=5, ngram=NGRAM)\n\nReturns the probability distribution of the language of the given text based on the provided language profiles.\n\nArguments\n\ntext: A string or a collection of strings to be analyzed for language identification.\nlanguages::Vector{String}: A list of languages to choose from. If this argument is not provided, all the languages returned by the supported_languages function will be used.\nprofiles::Vector{Dict{Vector{UInt8}, Float32}}: The language profiles to use for identification. If this argument is not provided, the default profiles will be used.\ntopk::Int: The number of candidates to return. The default value is 5.\nngram::Union{Int, AbstractVector}: The length of utf-8 byte n-grams to use for language detection. The default value is the value set in initialize, and should not exceed that value.\n\nReturns\n\nA list of the topk languages and their probabilities.\n\n\n\n\n\n","category":"method"},{"location":"#LanguageIdentification.supported_languages-Tuple{}","page":"Index","title":"LanguageIdentification.supported_languages","text":"supported_languages() -> Vector{String}\n\nReturn a vector containing all the languages (ISO 639-3 codes) that are supported by this package. \n\n\n\n\n\n","category":"method"},{"location":"#LanguageIdentification.vocabulary_sizes-Tuple{}","page":"Index","title":"LanguageIdentification.vocabulary_sizes","text":"The function vocabulary_sizes() returns the sizes of the vocabulary for each language that was loaded by the initialize function.\n\n\n\n\n\n","category":"method"},{"location":"#Index","page":"Index","title":"Index","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"","category":"page"}]
}