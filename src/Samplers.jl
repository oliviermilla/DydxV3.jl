module Samplers

import DydxV3

using Dates
using Random

function Random.rand(rng::AbstractRNG, ::Type{DydxV3.Trade})
    return DydxV3.Trade(
        rand(rng, DydxV3.Constants.TRADE_SIDES),
        rand(rng, 100.1:0.1:500.1),
        rand(rng, 100.0:200.0),
        rand(rng, DateTime(2000, 1, 1):Second(1):DateTime(2010, 12, 31)),
        rand(rng, Bool)
    )
end

function Random.rand(rng::AbstractRNG, previous::DydxV3.Trade, period::Dates.Period)
    return DydxV3.Trade(
        rand(rng, DydxV3.Constants.TRADE_SIDES),
        previous.size * rand(rng, -0.99:0.01:5.00),
        previous.price + rand(rng, -1.0:0.01:1.0),
        previous.createdAt + period,
        rand(rng, Bool)
    )
end

function Random.rand(rng::AbstractRNG, ::Type{DydxV3.Trade}, period::Dates.Period, n::Int)
    res = Vector{DydxV3.Trade}()
    push!(res, rand(rng, DydxV3.Trade))
    n == 1 && return res
    for i in 2:n
        push!(res, rand(rng, res[end], period))
    end    
    return res
end

Random.rand(d::Type{DydxV3.Trade}, period::Dates.Period, n::Int) = rand(Random.default_rng(), d, period, n)

end