module Data

export
    Account,
    Fill,
    FundingPayment,
    HistoricalPnl,
    Market,
    Order,
    OrderBook,
    OrderBookLevel,
    Position,
    Trade,
    Transfer,
    User,
    UserData,
    UserPreferences,
    UserTradeOption,
    UserWarnings

using Dates
using JSON3

struct Position
    market::String
    status::String
    side::String
    size::Float64
    maxSize::Float64
    entryPrice::Float64
    exitPrice::Float64
    unrealizedPnl::Float64
    realizedPnl::Float64
    createdAt::DateTime
    closedAt::Union{Nothing,DateTime}
    sumOpen::Float64
    sumClose::Float64
    netFunding::Float64
end

struct Account
    starkKey::String
    positionId::UInt32
    equity::Float64
    freeCollateral::Float64
    pendingDeposits::Float64
    pendingWithdrawals::Float64
    openPositions::Dict{String,Position}
    accountNumber::UInt16
    id::String
    quoteBalance::Float64
    createdAt::DateTime
end

struct Fill
    id::String
    side::String
    liquidity::String
    type::String
    market::String
    orderId::String
    price::Float64
    size::Float64
    fee::Float32
    createdAt::DateTime
end

struct FundingPayment
    market::String
    payment::Float64
    rate::Float64
    positionSize::Float64
    price::Float64
    effectiveAt::DateTime
end

struct HistoricalPnl
    equity::Float64
    totalPnl::Float64
    createdAt::DateTime
    netTransfers::Float64
    accountId::String
end

struct Market
    market::Union{Nothing, String}
    status::Union{Nothing, String}
    baseAsset::Union{Nothing, String}
    quoteAsset::Union{Nothing, String}
    stepSize::Union{Nothing, Float16}
    tickSize::Union{Nothing, Float16}
    indexPrice::Union{Nothing, Float32}
    oraclePrice::Union{Nothing, Float32}
    priceChange24H::Union{Nothing, Float32}
    nextFundingRate::Union{Nothing, Float32}
    nextFundingAt::Union{Nothing, DateTime}
    minOrderSize::Union{Nothing, Float16}
    type::Union{Nothing, String}
    initialMarginFraction::Union{Nothing, Float16}
    maintenanceMarginFraction::Union{Nothing, Float16}
    baselinePositionSize::Union{Nothing, UInt32}
    incrementalPositionSize::Union{Nothing, UInt32}
    incrementalInitialMarginFraction::Union{Nothing, Float16}
    transferMarginFraction::Union{Nothing, Float32}
    maxPositionSize::Union{Nothing, UInt64}
    volume24H::Union{Nothing, Float32}
    trades24H::Union{Nothing, UInt32}
    openInterest::Union{Nothing, Float32}
    assetResolution::Union{Nothing, UInt64}
    syntheticAssetId::Union{Nothing, String}
end

struct Order
    accountId::String
    market::String
    side::String
    id::String
    remainingSize::Float64
    price::Float64
end

struct OrderBookLevel
    size::Float32
    price::Float32
end

struct OrderBook
    bids::Vector{OrderBookLevel}
    asks::Vector{OrderBookLevel}
end

struct Trade
    side::String
    size::Float64
    price::Float64
    createdAt::DateTime
    liquidation::Bool
end

struct Transfer
    # id::String
    # type::String
    # debitAsset::String
    # creditAsset::String
    # debitAmount::Float64
    # creditAmount::Float64
    # transactionHash::String
    # status::String
    # createdAt::DateTime
    # confirmedAt::DateTime
    # clientId::Union{String,Nothing}
    # fromAddress::Union{String,Nothing}
    # toAddress::Union{String,Nothing}
    # accountId::String
    # transferAccountId::Union{String,Nothing}
end

struct UserTradeOption
    postOnlyChecked::Bool
    goodTilTimeInput::UInt8
    reduceOnlyChecked::Bool
    goodTilTimeTimescale::String
    selectedTimeInForceOption::String
end

struct UserWarnings
    enableWarning::Bool
    disableWarning::Bool
end

struct UserPreferences
    userTradeOptions::Dict{String,Union{UserTradeOption,String}}
    popUpNotifications::Bool
    orderbookAnimations::Bool
    latestConcludedEpoch::UInt16
    oneTimeNotifications::Vector{String}
    leaguesCurrentStartDate::String
    hasSeenReduceOnlyWarning::UserWarnings
end

struct UserData
    walletType::String
    preferences::UserPreferences
    starredMarkets::Vector{String}
end

struct User
    publicId::String
    ethereumAddress::String
    isRegistered::Bool
    email::Union{String,Nothing}
    username::Union{String,Nothing}
    userData::UserData
    makerFeeRate::Float64
    takerFeeRate::Float64
    referralDiscountRate::Union{String,Nothing}
    makerVolume30D::Float64
    takerVolume30D::Float64
    fees30D::Float32
    referredByAffiliateLink::Union{String,Nothing}
    isSharingUsername::Union{Nothing,Bool}
    isSharingAddress::Union{Nothing,Bool}
    dydxTokenBalance::Float32
    stakedDydxTokenBalance::Float32
    activeStakedDydxTokenBalance::Float32
    isEmailVerified::Bool
    country::Union{String,Nothing}
    languageCode::String
    hedgiesHeld::Vector{String}
    livenessVerified::Union{Nothing,Bool}
    livenessVerifiedAt::Union{Nothing,String}
    syntheticId::String
end

JSON3.StructTypes.StructType(::Type{Account}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Fill}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{FundingPayment}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{HistoricalPnl}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Market}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Order}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{OrderBook}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{OrderBookLevel}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Position}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Trade}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{Transfer}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{User}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{UserData}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{UserPreferences}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{UserTradeOption}) = JSON3.StructTypes.Struct()
JSON3.StructTypes.StructType(::Type{UserWarnings}) = JSON3.StructTypes.Struct()
end