module WebSockets

export Client
export open
export subscribeToAccount, subscribeToMarkets, subscribeToTrades

using DydxV3
using DydxV3.Data
using DydxV3.Constants
using DydxV3.Private.Api

include(joinpath("WebSockets", "Wrappers.jl"))
using .Wrappers

export AccountWrapper
export Connected

import DydxV3.Preferences as Preferences
import HTTP
using JSON3

@inline string_to_json(string::AbstractString) = JSON3.write(JSON3.read(string))

#const PONG_MESSAGE = string_to_json("""{"type":"ping"}""")
function subscribeToAccountMessage(accountNumber::UInt16)
    apiKey = Preferences.apiKey
    stamp = timestamp()
    sign = signature(stamp, "GET", "/ws/accounts")
    passphrase = Preferences.passphrase

    return string_to_json("""{"type":"subscribe", "channel":"v3_accounts", "accountNumber":"$(accountNumber)", "apiKey":"$(apiKey)", "signature":"$(sign)", "timestamp":"$(stamp)", "passphrase":"$(passphrase)"}""")
end

subscribeToTradesMessage(market::String) = string_to_json("""{"type":"subscribe", "channel":"v3_trades", "id":"$(market)"}""")
unsubscribeFromTradesMessage(market::String) = string_to_json("""{"type":"unsubscribe", "channel":"v3_trades", "id":"$(market)"}""")

subscribeToMarketsMessage() = string_to_json("""{"type":"subscribe", "channel":"v3_markets"}""")
unsubscribeToMarketsMessage() = string_to_json("""{"type":"unsubscribe", "channel":"v3_markets"}""")

function connectionUrl(type::ENVIRONNMENT_TYPE)
    type == PRODUCTION && return WEBSOCKET_PRODUCTION_URL
    type == STAGING && return WEBSOCKET_STAGING_URL
    throw(DomainError(type))
end

mutable struct Client
    send::Vector{String}

    onAccount::Dict{UInt16,Function}

    onMarkets::Union{Function,Nothing}

    onTrade::Dict{String,Function}
    onOrderBook::Dict{String,Function}

    type::ENVIRONNMENT_TYPE
    ws::Union{HTTP.WebSockets.WebSocket,Nothing}

    toClose::Bool

    Client(type::ENVIRONNMENT_TYPE) = new(Vector{String}(), Dict{UInt16,Function}(), nothing, Dict{String,Function}(), Dict{String,Function}(), type, nothing, false)
end

function open(onConnect::Union{Nothing,Function}, client::Client)
    HTTP.WebSockets.open(connectionUrl(client.type)) do ws
        client.ws = ws
        for msg in ws
            client.toClose && break
            resp = JSON3.read(msg, Wrappers.Response)
            if resp.type == "channel_data"
                if resp.channel == "v3_trades"
                    resp = JSON3.read(msg, Wrappers.TradeWrapper, parsequoted=true, dateformat=DATE_FORMAT)
                    callback = client.onTrade[resp.id]
                    isnothing(callback) || callback(client, resp)
                elseif resp.channel == "v3_markets"
                    isnothing(client.onMarkets) || client.onMarkets(client, JSON3.read(msg, Wrappers.MarketWrapper, parsequoted=true, dateformat=DATE_FORMAT))
                elseif resp.channel == "v3_accounts"
                    throw(DomainError(resp)) # TODO
                else
                    throw(DomainError(resp))
                end
            elseif resp.type == "subscribed"
                if resp.channel == "v3_trades"
                    resp = JSON3.read(msg, Wrappers.TradeWrapper, parsequoted=true, dateformat=DATE_FORMAT)
                    callback = client.onTrade[resp.id]
                    isnothing(callback) || callback(client, resp)
                elseif resp.channel == "v3_markets"
                    resp = JSON3.read(msg, Wrappers.MarketsSubscribedWrapper, parsequoted=true, dateformat=DATE_FORMAT)
                    resp = MarketWrapper(resp)
                    isnothing(client.onMarkets) || client.onMarkets(client, resp)
                elseif resp.channel == "v3_accounts"
                    isnothing(client.onAccount) && continue
                    resp = JSON3.read(msg, Wrappers.AccountWrapper, parsequoted=true, dateformat=DATE_FORMAT)
                    callback = client.onAccount[resp.contents.account.accountNumber]
                    isnothing(callback) || callback(client, resp)
                else
                    throw(DomainError(resp))
                end
            elseif resp.type == "connected"
                isnothing(onConnect) || onConnect(client, JSON3.read(msg, Connected, parsequoted=true))
            elseif resp.type == "error"
                throw(JSON3.read(msg, Wrappers.Error, parsequoted=true, dateformat=DATE_FORMAT))
            else
                throw(DomainError(resp))
            end
            while !isempty(client.send)
                s = popfirst!(client.send)
                HTTP.WebSockets.Sockets.send(ws, s)
            end
        end
    end
end

open(client::Client) = open(nothing, client)

function Base.close(client::Client)
    isnothing(client.ws) && return
    client.toClose = true
end

function subscribeToAccount(func::Function, accountNumber::UInt16, client::Client)
    client.onAccount[accountNumber] = func
    push!(client.send, subscribeToAccountMessage(accountNumber))
end

subscribeToAccount(func::Function, account::Account, client::Client) = subscribeToAccount(client, func, account.accountNumber)

function subscribeToMarkets(func::Function, client::Client)
    client.onMarkets = func
    push!(client.send, subscribeToMarketsMessage())
end

function subscribeToTrades(func::Function, id::String, client::Client)
    client.onTrade[id] = func
    push!(client.send, subscribeToTradesMessage(id))
end

end
