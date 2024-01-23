module Wrappers

using JSON3

using ...Data

struct Accounts
    accounts::Vector{Account}
end

struct Fills
    fills::Vector{Fill}
end

struct HistoricalPnls
    historicalPnl::Vector{HistoricalPnl}
end

struct Orders
    orders::Vector{Order}
end

struct Positions
    positions::Vector{Position}
end

struct Transfers
    transfers::Vector{Transfer}
end

struct UserWrapper
    user::User
end

JSON3.StructTypes.StructType(::Type{Accounts}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Fills}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{HistoricalPnls}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Orders}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Positions}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Transfers}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{UserWrapper}) = JSON3.StructTypes.Struct()
end