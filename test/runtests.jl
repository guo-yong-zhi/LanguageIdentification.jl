using LanguageIdentification
import LanguageIdentification as LI
using Test
@testset "LanguageIdentification.jl" begin
    @show LI.supported_languages()
    LI.initialize()
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
    @test sum(last.(langprob("This is a test.", topk=50))) ≈ 1.0
    @test langprob("这是一个测试。", topk=1) |> only |> first == "zho"
    @test langprob("これはテストです。", ["zho", "ara"], topk=30) |> length == 2

end
