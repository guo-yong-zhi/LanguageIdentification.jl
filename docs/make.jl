using Documenter
using WordCloud

Documenter.makedocs(
    clean = true,
    doctest = true,
    repo = "",
    highlightsig = true,
    sitename = "LanguageIdentification.jl",
    expandfirst = [],
    pages = [
        "Index" => "index.md",
    ],
)

deploydocs(;
    repo  =  "github.com/guo-yong-zhi/LanguageIdentification.jl.git",
)
