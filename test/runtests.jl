using LanguageIdentification
import LanguageIdentification as LI
using Test
@testset "LanguageIdentification.jl" begin
    # @show LI.supported_languages()
    # LI.makesure_initialized()
    @test length(LI.supported_languages()) == 50
    @test langid("This is a test.") == "eng"
    @test langid("这是一个测试。") == "zho"
    @test langid("これはテストです。") == "jpn"
    @test langid("이것은 테스트입니다.") == "kor"
    @test langid("Это тест.") == "rus"
    @test langid("هذا اختبار.") == "ara"
    @test langid("यह एक परीक्षण है।") == "hin"
    @test langid("এটি একটি পরীক্ষা।") == "ben"
    @test langid("این یک آزمایش است.") == "fas"
    @test langid("این یک آزمایش است.", ["jpn", "eng"]) in ["jpn", "eng"]
    langid("این یک آزمایش است.", ngram=[2, 4])
    langid("", ngram=3)
    langid(" ", ngram=3:4)
    langid(" ", ngram=5:7)
    @test langid(Set(["This", "is", "a", "test", "."])) == "eng"
    @test langid(["这是", "一个", "测试", "。"]) == "zho"
    @test sum(last.(langprob("This is a test.", topk=length(LI.supported_languages())))) ≈ 1.0
    @test langprob("这是一个测试。", topk=1) |> only |> first == "zho"
    @test langprob(["这是", "一个", "测试", "。"], topk=1) |> only |> first == "zho"
    @test langprob("これはテストです。", ["zho", "ara"], topk=30) |> length == 2
    LI.initialize(vocabulary=200)
    @test all(last.(LI.vocabulary_sizes()) .== 201)
    LI.initialize(cutoff=0.5)
    LI.initialize(cutoff=0.75, vocabulary=200:1000)
    LI.initialize(languages=["rus", "ara", "hin"])
    @test length(LI.PROFILES) == 3
end
