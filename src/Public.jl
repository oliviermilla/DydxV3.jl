module Public

export 
    getmarket,
    getmarkets,
    getorderbook

using HTTP, JSON3, URIs
using ..Constants
using ..Data

include(joinpath("Public","Wrappers.jl"))
using .Wrappers

function getmarkets()
    r = get("markets")
    markets = JSON3.read(r.body, Wrappers.Markets, parsequoted=true, dateformat=DATE_FORMAT)
    return markets.markets
end

function getmarket(market::String)
    r = get(string(URI(URI("markets"); query=Dict("market" => market))))    
    markets = JSON3.read(r.body, Wrappers.Markets, parsequoted=true, dateformat=DATE_FORMAT)
    return markets.markets[market]
end

function getorderbook(market::String)
    r = get("orderbook/$(market)")
    return JSON3.read(r.body, Wrappers.OrderBook, parsequoted=true, dateformat=DATE_FORMAT)
end

function get(urlTail::String)
    url = URIs.resolvereference(HTTP_PRODUCTION_URL, urlTail)
    return HTTP.get(url)
end

end