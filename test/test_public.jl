@testset "Public API" begin
    @test DydxV3.getmarket("BTC-USD") isa DydxV3.Market
    @test DydxV3.getmarkets() isa Dict{String,DydxV3.Market}
    @test DydxV3.getorderbook("BTC-USD") isa DydxV3.OrderBook
end