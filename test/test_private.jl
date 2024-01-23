@testset "getuser" begin
    @test isa(DydxV3.getuser(), DydxV3.User)
end

@testset "getaccounts" begin
    @test isa(DydxV3.getaccounts(), Vector{DydxV3.Account})
end

@testset "getaccount" begin
    @test_skip isa(DydxV3.getaccount(getcredential("walletAddress","dydx")), DydxV3.Account)
end

@testset "gettransfers" begin 
    @test_throws ArgumentError DydxV3.getpositions(limit=101)
    @test isa(DydxV3.gettransfers(), Vector{DydxV3.Transfer})
end

@testset "getpositions" begin
    @test_throws ArgumentError DydxV3.getpositions(limit=101)
    @test isa(DydxV3.getpositions(), Vector{DydxV3.Position})
end

@testset "getfills" begin
    @test_throws ArgumentError DydxV3.getfills(limit=101)
    @test isa(DydxV3.getfills(), Vector{DydxV3.Fill})
end

@testset "getfillsfororder" begin end

@testset "getactiveorders" begin
    @test_throws ArgumentError DydxV3.getactiveorders("BTC-USD", side=nothing, id="id")
    @test isa(DydxV3.getactiveorders("BTC-USD"), Vector{DydxV3.Order})
end

@testset "gethistoricalpnl" begin
    @test isa(DydxV3.gethistoricalpnl(), Vector{DydxV3.HistoricalPnl})
end

@testset "getorders" begin
    @test_throws ArgumentError DydxV3.getorders(limit=101)
    @test isa(DydxV3.getorders(), Vector{DydxV3.Order})
end