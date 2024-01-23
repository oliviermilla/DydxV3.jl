module Wrappers

export AccountContentWrapper, 
    AccountWrapper, 
    Connected, 
    Error, 
    Markets,
    MarketsSubscribedWrapper,
    MarketWrapper,
    Response, 
    Trades, 
    TradeWrapper

using DydxV3.Data
using JSON3

struct AccountContentWrapper
    orders::Vector{Data.Order}
    account::Data.Account
    transfers::Vector{Data.Transfer}
    fundingPayments::Vector{Data.FundingPayment}
end

struct AccountWrapper
    type::String 
    connection_id::String
    message_id::UInt32 
    channel::String
    contents::AccountContentWrapper       
end

struct Connected
    type::String 
    connection_id::String
    message_id::UInt32    
end

struct Error
    type::String
    message::String
    connection_id::String
    message_id::UInt32
end

struct Markets
    markets::Dict{String, Market}
end

struct MarketsSubscribedWrapper
    type::String
    connection_id::String
    message_id::UInt32
    channel::String
    contents::Markets
end

struct MarketWrapper
    type::String
    connection_id::String
    message_id::UInt32
    channel::String
    contents::Dict{String, Market}
end
MarketWrapper(sub::MarketsSubscribedWrapper) = MarketWrapper(sub.type, sub.connection_id, sub.message_id, sub.channel, sub.contents.markets)

struct Response
    type::String # subscribed || connected || channel_data || error
    channel::Union{String, Nothing} # v3_markets || v3_trades
end

struct Trades
    trades::Vector{Trade}
end

struct TradeWrapper
    type::String 
    connection_id::String
    message_id::UInt32
    channel::String
    id::String
    contents::Trades
end

struct MarketsWrapper
    type::String
    connection_id::String
    message_id::UInt32
    channel::String
    id::String
    contents::Vector{Data.Market}
end

JSON3.StructTypes.StructType(::Type{AccountContentWrapper}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{AccountWrapper}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Connected}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Error}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Markets}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{MarketsSubscribedWrapper}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{MarketWrapper}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Response}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Trades}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{TradeWrapper}) = JSON3.StructTypes.Struct()
end