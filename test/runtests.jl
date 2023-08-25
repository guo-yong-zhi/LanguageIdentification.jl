using LanguageIdentification
using Test
@testset "LanguageIdentification.jl" begin
    @show LanguageIdentification.supported_languages()
    LanguageIdentification.initialize()
    @show LanguageIdentification.supported_languages()
    @show langid("This is a test.")
end
