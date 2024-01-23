module Private

export getaccounts
export getactiveorders
export getfills, getfillsfororder
export getpositions
export gettransfers
export getuser
export gethistoricalpnl
export getorders, cancelorders, putorder

using Dates
using JSON3

using ..Constants
using ..Data

include(joinpath("Private", "Api.jl"))
include(joinpath("Private", "Wrappers.jl"))
using .Api
using .Wrappers

function getaccount(ethWalletAddress::String)
    # TODO
    # r =Api.get("accounts", "ethereumAddress" => ethWalletAddress)    
    # println(String(r.body))
    # accounts = JSON3.read(r.body, Accounts, parsequoted=true)
    # return accounts.account
end

function getaccounts()
    r = Api.get("accounts")
    #println(String(r.body))
    accounts = JSON3.read(r.body, Wrappers.Accounts, parsequoted=true, dateformat=DATE_FORMAT)
    return accounts.accounts
end

function getactiveorders(market::String; side::Union{String,Nothing}=nothing, id::Union{String,Nothing}=nothing)
    if (!isnothing(id) && isnothing(side))
        throw(ArgumentError("side is required when the order id is specified."))
    end
    r = Api.get("active-orders", "market" => market, "side" => side, "id" => id)
    #println(String(r.body))
    orders = JSON3.read(r.body, Wrappers.Orders, parsequoted=true)
    return orders.orders
end

function getfills(market::Union{String,Nothing}=nothing; limit::Integer=UInt8(100), createdBeforeOrAt::Union{DateTime,Nothing}=nothing)
    if (limit > 100)
        throw(ArgumentError("limit cannot be greater than 100."))
    end
    r = Api.get("fills", "market" => market, "limit" => limit, "createdBeforeOrAt" => createdBeforeOrAt)
    #println(String(r.body))
    fills = JSON3.read(r.body, Wrappers.Fills, parsequoted=true, dateformat=DATE_FORMAT)
    return fills.fills
end

function getfillsfororder(orderId::String; limit::Integer=UInt8(100), createdBeforeOrAt::Union{DateTime,Nothing}=nothing)
    # TODO
end

function getpositions(market::Union{String,Nothing}=nothing; status::Union{String,Nothing}=nothing, limit::Integer=UInt8(100), createdBeforeOrAt::Union{DateTime,Nothing}=nothing)
    if (limit > 100)
        throw(ArgumentError("limit cannot be greater than 100."))
    end
    r = Api.get("positions", "market" => market, "status" => status, "limit" => limit, "createdBeforeOrAt" => createdBeforeOrAt)
    #println(String(r.body))
    positions = JSON3.read(r.body, Wrappers.Positions, parsequoted=true, dateformat=DATE_FORMAT)
    return positions.positions
end

function gettransfers(; transferType::Union{Nothing, String}=nothing, limit::Integer=UInt8(100), createdBeforeOrAt::Union{DateTime,Nothing} = nothing)
    if (limit > 100)
        throw(ArgumentError("limit cannot be greater than 100."))
    end
    r = Api.get("transfers", "transferType"=> transferType, "limit" => limit, "createdBeforeOrAt" => createdBeforeOrAt)
    #println(String(r.body))
    transfers = JSON3.read(r.body, Wrappers.Transfers, parsequoted=true, dateformat=DATE_FORMAT)
    return transfers.transfers
end

function getuser()
    r = Api.get("users")
    #println(String(r.body))
    userWrapper = JSON3.read(r.body, Wrappers.UserWrapper, parsequoted=true, dateformat=DATE_FORMAT)
    return userWrapper.user
end

function gethistoricalpnl(; createdBeforeOrAt::Union{DateTime,Nothing}=nothing, createdOnOrAfter::Union{DateTime,Nothing}=nothing)
    if (!isnothing(createdBeforeOrAt) && !isnothing(createdOnOrAfter))
        # duration = abs(createdBeforeOrAt - createdOnOrAfter)
        # one_month = 
        # TODO raise if duration is greater than a month
    end
    r = Api.get("historical-pnl", "createdBeforeOrAt" => createdBeforeOrAt, "createdOnOrAfter" => createdOnOrAfter)
    #println(String(r.body))
    pnl = JSON3.read(r.body, Wrappers.HistoricalPnls, parsequoted=true, dateformat=DATE_FORMAT)
    return pnl.historicalPnl
end

function getorders(market::Union{Nothing,AbstractString}=nothing; status::Union{Nothing,AbstractString}=nothing,
    side::Union{Nothing,AbstractString}=nothing, type::Union{Nothing,AbstractString}=nothing, limit::Integer=UInt8(100),
    createdBeforeOrAt::Union{Nothing,DateTime}=nothing, returnLatestOrders::Bool=false)
    if (limit > 100)
        throw(ArgumentError("limit cannot be greater than 100."))
    end
    r = Api.get("orders", "market" => market, "status" => status,
        "side" => side, "type" => type, "limit" => limit,
        "createdBeforeOrAt" => createdBeforeOrAt, "returnLatestOrders" => returnLatestOrders)
    #println(String(r.body))
    orders = JSON3.read(r.body, Wrappers.Orders, parsequoted=true, dateformat=DATE_FORMAT)
    return orders.orders
end

function cancelorders(market::String; side::Union{String,Nothing}=nothing, id::Union{String,Nothing}=nothing)
    if(!isnothing(id) && isnothing(side))
        throw(ArgumentError("The order side is required when order id is provided."))
    end
    r = Api.delete("active-osers", "side" => side, "id" => id)
    orders = JSON3.read(r.body, Wrappers.Orders, parsequoted=true, dateformat=DATE_FORMAT)
    return orders.orders
end

function putorder(market::String; side::String, type::String, postOnly::Bool, 
    size::Float64, price::Float64, limitFee::Float16, expiration::DateTime,timeInForce::String="GTT", 
    cancelId::String,triggerPrice::Float64,trailingPercent::Float64,reduceOnly::Union{Nothing,Bool}=nothing,
    clientId::String, signature::String)
    if(!(timeInForce in ["GTT, FOK, IOC"]))
        throw(ArgumentError("Unsupported timeInForce $(timeInForce)."))    
    end
    if(reduceOnly && !(timeInForce in ["FOK", "IOC"]))
        throw(ArgumentError("ReduceOnly is only supported for FOK and IOC orders."))
    end
    # TODO logic for clientId && signature generation if(isnothing(clientId))
end
end
