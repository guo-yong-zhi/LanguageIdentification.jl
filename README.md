# LanguageIdentification.jl
[![docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://guo-yong-zhi.github.io/LanguageIdentification.jl/dev) [![CI](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml) [![CI-nightly](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml) [![codecov](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl/graph/badge.svg?token=lwDSoRUTmH)](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl)

`LanguageIdentification.jl` is a Julia package for identifying the language of a given text. It currently supports `50` languages (see below). This package is lightweight and has no dependencies.
# Installation
```julia
import Pkg; Pkg.add("LanguageIdentification")
```
# Usage
After loading the package, initialization is required. Different parameters have different balances among accuracy, speed, and memory usage. See the documentation for details. 
```julia
using LanguageIdentification
LanguageIdentification.initialize()
```
Currently, `LanguageIdentification.jl` supports the identification of 50 languages. You can check them with the following command. The language is represented by the [ISO 639-3](https://en.wikipedia.org/wiki/ISO_639_macrolanguage) code.
```julia
LanguageIdentification.supported_languages()
```
```julia
 ["ara", "bel", "ben", "bul", "cat", "ces", "dan", "deu", "ell", "eng", "epo", "fas", 
 "fin", "fra", "hau", "hbs", "heb", "hin", "hun", "ido", "ina", "isl", "ita", "jpn", 
 "kab", "kor", "kur", "lat", "lit", "mar", "mkd", "msa", "nds", "nld", "nor", "pol", 
 "por", "ron", "rus", "slk", "spa", "swa", "swe", "tat", "tgl", "tur", "ukr", "vie", 
 "yid", "zho"]
```
This package provides a simple interface to identify the language of a given text. The package exports two functions:
- `langid`: returns the language code of the tested text.
- `langprob`: returns the probabilities of the tested text for each language.
```julia
langid("This is a test.")
```
```julia
"eng"
```
```julia
langprob("这是一个测试。", topk=3)
```
```julia
["zho" => 0.157798836477618,
"mar" => 0.11718444394383595,
"ben" => 0.10440699125820749,]
```
# Benchmark
todo