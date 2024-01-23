module UsesPreferences

using Preferences

const walletAddress = @load_preference("walletAddress")

const starkPrivateKey = @load_preference("starkPrivateKey")
const starkPublicKey = @load_preference("starkPublicKey")
const starkPublicKeyYCoordinate = @load_preference("starkPublicKeyYCoordinate")

const apiKey = @load_preference("apiKey")
const apiPassPhrase = @load_preference("apiPassPhrase")
const apiSecret = @load_preference("apiSecret")

end