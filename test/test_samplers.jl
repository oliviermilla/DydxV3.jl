
using Dates

@testset "rand(DydxV3.Trade)" begin
    trades = rand(DydxV3.Trade, Minute(2), 3)

    @test trades[2].createdAt == trades[1].createdAt + Dates.Minute(2)
    @test trades[3].createdAt == trades[2].createdAt + Dates.Minute(2)
end