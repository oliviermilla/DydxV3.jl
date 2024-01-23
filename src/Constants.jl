module Constants

export
    DATE_FORMAT,
    HTTP_PRODUCTION_URL,
    HTTP_STAGING_URL,
    TRADE_SIDES,
    WEBSOCKET_PRODUCTION_URL,
    WEBSOCKET_STAGING_URL,
    WEBSOCKET_CHANNELS, ACCOUNT, ORDERBOOK, TRADES, MARKETS,
    ENVIRONNMENT_TYPE, PRODUCTION, STAGING

using Dates

const DATE_FORMAT = dateformat"YYYY-mm-ddTHH:MM:SS.sZ"

@enum ENVIRONNMENT_TYPE PRODUCTION STAGING

const HTTP_PRODUCTION_URL = "https://api.dydx.exchange/v3/"
const HTTP_STAGING_URL = "https://api.stage.dydx.exchange"

const WEBSOCKET_PRODUCTION_URL = "wss://api.dydx.exchange/v3/ws"
const WEBSOCKET_STAGING_URL = "wss://api.stage.dydx.exchange/v3/ws"

@enum WEBSOCKET_CHANNELS ACCOUNT ORDERBOOK TRADES MARKETS

const TRADE_SIDES = ["BUY", "SELL"]

end