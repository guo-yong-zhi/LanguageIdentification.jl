# LanguageIdentification.jl
[![docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://guo-yong-zhi.github.io/LanguageIdentification.jl/dev) [![CI](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml) [![CI-nightly](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml) [![codecov](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl/graph/badge.svg?token=lwDSoRUTmH)](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl)

`LanguageIdentification.jl` is a Julia package for identifying the language of a given text. It currently supports `50` languages (see below). This package is lightweight and has no dependencies.
# Installation
```julia
import Pkg; Pkg.add("LanguageIdentification")
```
# Usage
Before using the language identification functionality, you need to initialize the package. This process involves setting some parameters that balance accuracy, speed, and memory usage. If you don't manually initialize the package, it will use default parameters. For more information, please refer to the documentation.
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
["zho" => 0.75607236497363
 "jpn" => 0.036749305182980266
 "tat" => 0.015681619153487716]
```
# Benchmark

We tested four language identification packages: `LanguageIdentification.jl`, [`Languages.jl`](https://github.com/JuliaText/Languages.jl), [`LanguageDetect.jl`](https://github.com/SeanLee97/LanguageDetect.jl), and [`LanguageFinder`](https://github.com/nusretipek/LanguageFinder/tree/main/src) on a hold-out test set. The test set was sourced from [`tatoeba`](https://tatoeba.org) and [`wikipedia`](https://www.wikipedia.org/) and comprised of the 50 languages supported by this package. The complete test report can be found [here](https://github.com/guo-yong-zhi/langid_expirement/blob/main/benchmarks/compare/compare.md).

- tatoeba

|                           | ara        | bel        | ben         | bul        | cat        | ces        | dan        | deu        | ell         | eng        | epo        | fas        | fin        | fra        | hau        | hbs        | heb         | hin        | hun        | ido        | ina        | isl        | ita        | jpn        | kab        | kor         | kur        | lat        | lit        | mar        | mkd        | msa        | nds        | nld        | nor        | pol        | por        | ron        | rus        | slk        | spa        | swa        | swe        | tat        | tgl        | tur        | ukr        | vie         | yid        | zho         |
|---------------------------|------------|------------|-------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|-------------|------------|-------------|
| LanguageIdentification.jl | **98.96%** | **97.21%** | **100.00%** | **83.52%** | **93.75%** | **93.07%** | **84.68%** | **98.96%** | **100.00%** | **99.08%** | **97.86%** | **99.04%** | **99.04%** | **97.58%** | **98.81%** |     23.06% |      98.76% |     88.85% | **99.04%** | **90.62%** | **95.30%** | **99.55%** | **96.99%** |     99.97% | **99.43%** | **100.00%** | **99.20%** | **96.53%** | **99.29%** | **88.13%** | **92.96%** | **97.88%** | **96.37%** | **97.76%** | **85.40%** | **99.31%** | **97.68%** | **97.49%** |     91.13% | **93.26%** | **93.60%** | **98.66%** | **95.50%** | **91.16%** | **98.93%** | **98.94%** | **87.51%** | **100.00%** | **99.31%** | **100.00%** |
|              Languages.jl |     85.55% |     80.47% | **100.00%** |     62.46% |          - |     48.90% |     47.06% |     90.48% |      99.89% |     78.21% |     64.61% |     95.00% |     76.87% |     82.21% |     92.85% | **60.28%** |      95.75% |     62.99% |     73.99% |          - |          - |          - |     66.27% | **99.97%** |          - |      98.97% |          - |          - |     61.94% |     72.05% |     51.40% |     71.26% |          - |     78.91% |     66.74% |     72.66% |     77.35% |     70.87% |     52.59% |          - |     61.89% |          - |     52.46% |          - |     63.96% |     52.10% |     62.63% |      84.06% |     98.39% |      99.86% |
|         LanguageDetect.jl |     93.68% |          - | **100.00%** |     64.15% |     59.86% |     70.87% |     53.14% |     81.88% | **100.00%** |     74.76% |          - |     93.68% |     90.37% |     77.41% |          - |     27.53% | **100.00%** |     91.60% |     86.61% |          - |          - |          - |     69.16% |     99.85% |          - |      99.48% |          - |          - |     81.41% |     86.60% |     74.70% |     84.67% |          - |     65.07% |     54.23% |     92.97% |     69.89% |     84.12% |     78.32% |     57.26% |     60.35% |     83.89% |     70.51% |          - |     90.70% |     90.33% |     71.89% |      99.75% |          - |      98.53% |
|         LanguageFinder.jl |     93.11% |          - |           - |          - |          - |     69.58% |     70.80% |     91.68% | **100.00%** |     82.53% |          - |     98.60% |     89.31% |     87.57% |          - |          - |      99.99% | **99.87%** |     73.90% |          - |          - |          - |     82.66% |          - |          - |      96.38% |          - |          - |          - |          - |          - |          - |          - |     88.80% |     29.90% |     85.74% |     68.62% |          - | **93.35%** |          - |     76.32% |          - |     40.42% |          - |          - |     71.22% |     76.81% |           - |          - |      45.72% |

- wikipedia

|                           | ara        | bel        | ben         | bul        | cat         | ces        | dan        | deu        | ell         | eng         | epo         | fas         | fin        | fra         | hau        | hbs         | heb         | hin         | hun        | ido        | ina        | isl        | ita         | jpn        | kab        | kor         | kur        | lat        | lit         | mar        | mkd        | msa        | nds        | nld        | nor        | pol         | por        | ron        | rus         | slk        | spa         | swa        | swe        | tat        | tgl        | tur        | ukr         | vie        | yid        | zho        |
|---------------------------|------------|------------|-------------|------------|-------------|------------|------------|------------|-------------|-------------|-------------|-------------|------------|-------------|------------|-------------|-------------|-------------|------------|------------|------------|------------|-------------|------------|------------|-------------|------------|------------|-------------|------------|------------|------------|------------|------------|------------|-------------|------------|------------|-------------|------------|-------------|------------|------------|------------|------------|------------|-------------|------------|------------|------------|
| LanguageIdentification.jl | **99.50%** | **99.50%** | **100.00%** | **99.00%** | **100.00%** | **96.50%** | **98.50%** | **96.50%** | **100.00%** | **100.00%** | **100.00%** | **100.00%** | **99.50%** | **100.00%** | **99.50%** |      87.00% | **100.00%** |      91.00% | **99.00%** | **92.50%** | **97.00%** | **98.50%** | **100.00%** |     98.00% | **99.00%** | **100.00%** | **99.00%** | **98.50%** | **100.00%** |     95.50% |     97.50% | **99.50%** | **99.50%** |     97.00% | **98.00%** | **100.00%** | **99.50%** | **90.00%** |      99.50% | **97.00%** | **100.00%** | **99.50%** | **98.50%** | **99.00%** | **98.50%** | **98.50%** | **100.00%** | **97.00%** | **98.50%** | **99.50%** |
|              Languages.jl |     99.00% |     98.50% |      99.00% | **99.00%** |           - |     92.50% |     88.50% |     96.00% |      96.50% |      99.50% |      96.00% |      98.50% |     98.00% | **100.00%** |     99.00% | **100.00%** |      99.50% |      91.00% |     93.00% |          - |          - |          - |      98.50% | **99.50%** |          - |      89.50% |          - |          - |      94.50% |     95.00% | **98.00%** | **99.50%** |          - |     94.50% |     95.50% |      90.50% |     94.00% |     81.50% |      97.50% |          - |      98.50% |          - |     88.00% |          - |     97.00% |     92.50% |      93.00% |     74.50% |     98.00% |     96.50% |
|         LanguageDetect.jl | **99.50%** |          - | **100.00%** |     80.00% |      79.00% |     80.50% |     61.00% |     81.00% | **100.00%** |      90.00% |           - |      99.00% |     94.50% |      90.00% |          - |       3.50% | **100.00%** |      94.00% |     93.50% |          - |          - |          - |      87.50% |     94.50% |          - |      95.00% |          - |          - |      96.50% | **97.00%** |     90.00% |     96.50% |          - |     74.00% |     55.50% |      94.00% |     78.50% |     74.00% |      91.00% |     77.00% |      77.50% |     95.50% |     69.00% |          - |     94.50% |     93.00% |      97.50% |     96.00% |          - |     74.00% |
|         LanguageFinder.jl | **99.50%** |          - |           - |          - |           - |     96.00% | **98.50%** |     95.50% |      99.50% |      99.50% |           - |      99.00% | **99.50%** | **100.00%** |          - |           - | **100.00%** | **100.00%** |     96.00% |          - |          - |          - |      98.50% |          - |          - |      94.50% |          - |          - |           - |          - |          - |          - |          - | **98.50%** |     35.50% |      98.00% |     88.00% |          - | **100.00%** |          - | **100.00%** |          - |     97.00% |          - |          - |     96.00% |      99.50% |          - |          - |     85.50% |

We calculated the average accuracy of each package on the intersection of supported languages, and the results are as follows:
- tatoeba

|                               | 50 languages | 39 languages | 35 languages | 24 languages |
|-------------------------------|--------------|--------------|--------------|--------------|
| **LanguageIdentification.jl** |   **94.58%** |   **94.24%** |   **93.77%** |   **95.87%** |
|                  Languages.jl |            - |       74.72% |       73.65% |       74.14% |
|             LanguageDetect.jl |            - |            - |       80.81% |       80.61% |
|             LanguageFinder.jl |            - |            - |            - |       79.70% |

- wikipedia

|                               | 50 languages | 39 languages | 35 languages | 24 languages |
|-------------------------------|--------------|--------------|--------------|--------------|
| **LanguageIdentification.jl** |   **98.20%** |   **98.22%** |   **98.09%** |   **98.79%** |
|                  Languages.jl |            - |       95.12% |       94.80% |       95.02% |
|             LanguageDetect.jl |            - |            - |       85.49% |       86.23% |
|             LanguageFinder.jl |            - |            - |            - |       94.75% |