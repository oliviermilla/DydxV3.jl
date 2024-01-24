module TimeSeriesExt

using DydxV3

using TimeSeries

function TimeSeries.TimeArray(pnl::Vector{DydxV3.HistoricalPnl})
    timestamp = Vector{DateTime}()
    equity = Vector{Float64}()
    totalPnl = Vector{Float64}()
    netTransfers = Vector{Float64}()
    accountId = Vector{String}()

    for idx in eachindex(pnl)
        push!(timestamp, pnl[idx].createdAt)
        push!(equity, pnl[idx].equity)
        push!(totalPnl, pnl[idx].totalPnl)
        push!(netTransfers, pnl[idx].netTransfers)
        push!(accountId, pnl[idx].accountId)
    end

    return TimeArray((
        timestamp=timestamp,
        equity=equity,
        totalPnl=totalPnl,
        netTransfers=netTransfers,
        accountId=accountId
    ))
end

end