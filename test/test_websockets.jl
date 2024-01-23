# @testset "open" begin
#     client = DydxV3.WebSockets.Client(DydxV3.Constants.PRODUCTION)
#     DydxV3.WebSockets.open(client) do cli, obj
#         @test isa(obj, DydxV3.WebSockets.Connected)
#         close(cli)
#     end
# end

# @testset "account" begin
#     client = DydxV3.WebSockets.Client(DydxV3.Constants.PRODUCTION)
#     accounts = DydxV3.getaccounts()
#     function testaccount(cli, obj) 
#         @test isa(obj, DydxV3.WebSockets.AccountWrapper)
#         close(cli)
#     end
#     DydxV3.WebSockets.subscribeToAccount(client, testaccount, accounts[1].accountNumber)    
#     DydxV3.WebSockets.open(client)
# end

@testset "trades" begin
    client = DydxV3.WebSockets.Client(DydxV3.Constants.PRODUCTION)

    i = 1
    DydxV3.WebSockets.subscribeToTrades("BTC-USD", client) do cli, obj
        println(obj)
        @test isa(obj, DydxV3.WebSockets.TradeWrapper)
        i == 2 && close(cli) # Test subscribed and channel_data before closing
        i += 1
    end

    DydxV3.WebSockets.open(client)
end

@testset "markets" begin
    client = DydxV3.WebSockets.Client(DydxV3.Constants.PRODUCTION)

    i = 1
    DydxV3.WebSockets.subscribeToMarkets(client) do cli, obj
        # println(obj)
        @test isa(obj, DydxV3.WebSockets.MarketWrapper)
        i == 2 && close(cli) # Test subscribed and channel_data before closing
        i += 1
    end

    DydxV3.WebSockets.open(client)
end
