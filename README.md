# LanguageIdentification.jl
[![docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://guo-yong-zhi.github.io/LanguageIdentification.jl/dev) [![CI](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci.yml) [![CI-nightly](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml/badge.svg)](https://github.com/guo-yong-zhi/LanguageIdentification.jl/actions/workflows/ci-nightly.yml) [![codecov](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl/graph/badge.svg?token=lwDSoRUTmH)](https://codecov.io/gh/guo-yong-zhi/LanguageIdentification.jl)

`LanguageIdentification.jl` is a Julia package for identifying the language of a given text. It currently supports `50` languages (see below). This package is lightweight and has no dependencies.
# Installation
```julia
import Pkg; Pkg.add("LanguageIdentification")
```
# Usage
```julia
using LanguageIdentification
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
This package provides simple interfaces:
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

We tested four language identification packages: `LanguageIdentification.jl` (this package), [`Languages.jl`](https://github.com/JuliaText/Languages.jl), [`LanguageDetect.jl`](https://github.com/SeanLee97/LanguageDetect.jl), and [`LanguageFinder`](https://github.com/nusretipek/LanguageFinder/tree/main/src) on a hold-out test set. The test set was sourced from [`tatoeba`](https://tatoeba.org) and [`wikipedia`](https://www.wikipedia.org/) and comprised of the 50 languages supported by this package. The complete test results can be found [here](https://github.com/guo-yong-zhi/langid_expirement/blob/main/benchmarks/compare/compare.md).

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

We calculated the average accuracy for the languages supported by multiple packages, and the results are as follows:
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

# Parameter Tuning
You can manually initialize the package using the `LanguageIdentification.initialize` function. By adjusting the parameters, you can achieve different balances between accuracy, speed, and memory usage. The default setting is `ngram=1:4`, `cutoff=0.85`, and `vocabulary=1000:5000`. However, this setting may not be optimal for your specific use case.  
For example, the table below shows that using a single-ngram setting of `ngram=4`, `cutoff=1.0`, and `vocabulary=5000` can achieve better accuracy on our tatoeba test set while also being much faster than the multi-ngrams setting. We choose the multi-ngrams as the default due to its stability. You can refer to our detailed benchmark results [here](https://github.com/guo-yong-zhi/langid_expirement/tree/main/benchmarks/matrix) as a reference for parameter tuning.

|             | 100-vocab | 200-vocab | 500-vocab | 1000-vocab | 2000-vocab | 5000-vocab | 10000-vocab | 20000-vocab | 50000-vocab | 100000-vocab |
|-------------|-----------|-----------|-----------|------------|------------|------------|-------------|-------------|-------------|--------------|
| 1:1 - grams |    76.95% |    76.95% |         - |          - |          - |          - |           - |           - |           - |            - |
| 1:2 - grams |    82.32% |    86.98% |    88.97% |     89.03% |     89.03% |     89.03% |           - |           - |           - |            - |
| 1:3 - grams |    81.21% |    87.02% |    91.04% |     92.60% |     93.21% |     93.48% |      93.51% |      93.51% |      93.51% |            - |
| 1:4 - grams |    80.10% |    86.03% |    91.35% |     93.08% |     94.28% |     95.10% |      95.49% |      95.62% |      95.64% |       95.64% |
| 1:5 - grams |    79.97% |    85.36% |    90.69% |     92.97% |     94.48% |     95.51% |      96.15% |      96.62% |      96.85% |       96.85% |
| 1:6 - grams |    79.63% |    84.85% |    90.52% |     92.78% |     94.37% |     95.60% |      96.12% |      96.75% |      97.28% |       97.38% |
| 1:7 - grams |    78.99% |    84.35% |    90.51% |     92.67% |     94.23% |     95.55% |      96.04% |      96.68% |      97.37% |       97.55% |

|                | 100-vocab | 200-vocab | 500-vocab | 1000-vocab | 2000-vocab | 5000-vocab | 10000-vocab | 20000-vocab | 50000-vocab |
|----------------|-----------|-----------|-----------|------------|------------|------------|-------------|-------------|-------------|
| single 1-grams |    76.95% |    76.95% |         - |          - |          - |          - |           - |           - |           - |
| single 2-grams |    83.95% |    88.07% |    90.19% |     90.28% |     90.28% |     90.28% |           - |           - |           - |
| single 3-grams |    82.47% |    87.99% |    91.85% |     93.51% |     94.36% |     94.75% |      94.75% |      94.75% |      94.75% |
| single 4-grams |    80.39% |    86.27% |    91.25% |     93.47% |     95.12% |     96.41% |      96.72% |      96.78% |      96.78% |
| single 5-grams |    72.48% |    81.49% |    88.42% |     91.74% |     93.80% |     94.72% |      95.08% |      95.48% |      95.56% |
| single 6-grams |    54.87% |    72.68% |    82.47% |     87.50% |     90.48% |     86.43% |      84.87% |      85.20% |      85.81% |
| single 7-grams |    49.14% |    61.29% |    71.76% |     81.42% |     81.70% |     68.59% |      64.30% |      63.69% |      63.98% |
