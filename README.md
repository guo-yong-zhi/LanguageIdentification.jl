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

We tested three language identification packages: `LanguageIdentification.jl`, `Languages.jl`, and `LanguageDetect.jl` on a hold-out test set. The test set was sourced from `tatoeba` and `wikipedia` and comprised of the 50 languages supported by this package.

- tatoeba

|                           | ara        | bel        | ben         | bul        | cat        | ces        | dan        | deu        | ell         | eng        | epo        | fas        | fin        | fra        | hau        | hbs        | heb         | hin        | hun        | ido        | ina        | isl        | ita        | jpn        | kab        | kor         | kur        | lat        | lit        | mar        | mkd        | msa        | nds        | nld        | nor        | pol        | por        | ron        | rus        | slk        | spa        | swa        | swe        | tat        | tgl        | tur        | ukr        | vie         | yid        | zho         |
|---------------------------|------------|------------|-------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|-------------|
| **LanguageIdentification.jl** | **98.96%** | **97.21%** | **100.00%** | **83.52%** | **93.75%** | **93.07%** | **84.68%** | **98.96%** | **100.00%** | **99.08%** | **97.86%** | **99.04%** | **99.04%** | **97.58%** | **98.81%** |     23.06% |      98.76% |     88.85% | **99.04%** | **90.62%** | **95.30%** | **99.55%** | **96.99%** |     99.97% | **99.43%** | **100.00%** | **99.20%** | **96.53%** | **99.29%** | **88.13%** | **92.96%** | **97.88%** | **96.37%** | **97.76%** | **85.40%** | **99.31%** | **97.68%** | **97.49%** | **91.13%** | **93.26%** | **93.60%** | **98.66%** | **95.50%** | **91.16%** | **98.93%** | **98.94%** | **87.51%** | **100.00%** | **99.31%** | **100.00%** |
|              Languages.jl |     85.55% |     80.47% | **100.00%** |     62.46% |          - |     48.90% |     47.06% |     90.48% |      99.89% |     78.21% |     64.61% |     95.00% |     76.87% |     82.21% |     92.85% | **60.28%** |      95.75% |     62.99% |     73.99% |          - |          - |          - |     66.27% | **99.97%** |          - |      98.97% |          - |          - |     61.94% |     72.05% |     51.40% |     71.26% |          - |     78.91% |     66.74% |     72.66% |     77.35% |     70.87% |     52.59% |          - |     61.89% |          - |     52.46% |          - |     63.96% |     52.10% |     62.63% |      84.06% |     98.39% |      99.86% |
|         LanguageDetect.jl |     94.02% |          - | **100.00%** |     64.47% |     60.10% |     70.71% |     53.28% |     81.63% | **100.00%** |     75.02% |          - |     93.98% |     90.05% |     76.79% |          - |     25.27% | **100.00%** | **93.44%** |     86.83% |          - |          - |          - |     68.92% |     99.86% |          - |      99.48% |          - |          - |     81.93% |     87.88% |     74.19% |     85.54% |          - |     65.35% |     55.62% |     92.59% |     70.06% |     84.75% |     78.27% |     55.43% |     60.48% |     83.81% |     70.48% |          - |     90.40% |     90.27% |     72.24% |      99.92% |          - |      98.53% |


- wikipedia

|                           | ara        | bel        | ben         | bul        | cat         | ces        | dan        | deu        | ell         | eng         | epo         | fas         | fin        | fra         | hau        | hbs         | heb         | hin        | hun        | ido        | ina        | isl        | ita         | jpn        | kab        | kor         | kur        | lat        | lit         | mar        | mkd        | msa        | nds        | nld        | nor        | pol         | por        | ron        | rus        | slk        | spa         | swa        | swe        | tat        | tgl        | tur        | ukr         | vie        | yid        | zho        |
|---------------------------|------------|------------|-------------|------------|-------------|------------|------------|------------|-------------|-------------|-------------|-------------|------------|-------------|------------|-------------|-------------|------------|------------|------------|------------|------------|-------------|------------|------------|-------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|
| **LanguageIdentification.jl** | **99.50%** | **99.50%** | **100.00%** | **99.00%** | **100.00%** | **96.50%** | **98.50%** | **96.50%** | **100.00%** | **100.00%** | **100.00%** | **100.00%** | **99.50%** | **100.00%** | **99.50%** |      87.00% | **100.00%** |     91.00% | **99.00%** | **92.50%** | **97.00%** | **98.50%** | **100.00%** |     98.00% | **99.00%** | **100.00%** | **99.00%** | **98.50%** | **100.00%** |     95.50% |     97.50% | **99.50%** | **99.50%** | **97.00%** | **98.00%** | **100.00%** | **99.50%** | **90.00%** | **99.50%** | **97.00%** | **100.00%** | **99.50%** | **98.50%** | **99.00%** | **98.50%** | **98.50%** | **100.00%** | **97.00%** | **98.50%** | **99.50%** |
|              Languages.jl |     99.00% |     98.50% |      99.00% | **99.00%** |           - |     92.50% |     88.50% |     96.00% |      96.50% |      99.50% |      96.00% |      98.50% |     98.00% | **100.00%** |     99.00% | **100.00%** |      99.50% |     91.00% |     93.00% |          - |          - |          - |      98.50% | **99.50%** |          - |      89.50% |          - |          - |      94.50% |     95.00% | **98.00%** | **99.50%** |          - |     94.50% |     95.50% |      90.50% |     94.00% |     81.50% |     97.50% |          - |      98.50% |          - |     88.00% |          - |     97.00% |     92.50% |      93.00% |     74.50% |     98.00% |     96.50% |
|         LanguageDetect.jl | **99.50%** |          - | **100.00%** |     82.00% |      77.50% |     88.00% |     68.50% |     80.00% |      99.50% |      92.00% |           - |      98.50% |     95.50% |      87.50% |          - |       5.00% | **100.00%** | **95.50%** |     91.50% |          - |          - |          - |      90.50% |     94.50% |          - |      95.00% |          - |          - |      97.00% | **97.50%** |     91.00% |     97.00% |          - |     77.50% |     62.00% |      95.00% |     76.50% |     76.00% |     92.50% |     81.50% |      80.00% |     96.50% |     69.50% |          - | **98.50%** |     94.50% |      97.50% |     96.00% |          - |     73.50% |


There are 35 languages that are supported by all three packages, and the average accuracy of the three packages on these languages is:

|                           | tatoeba | wikipedia |
|---------------------------|---------|---------|
| **LanguageIdentification.jl** |  **93.77%** |  **98.09%** |
|              Languages.jl |  73.65% |  94.80% |
|         LanguageDetect.jl |  80.92% |  86.70% |
