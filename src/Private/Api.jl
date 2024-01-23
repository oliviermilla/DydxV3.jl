module Api

export timestamp, signature
export get, put, delete, post

using DydxV3.Constants
import DydxV3.Preferences

using Base64
using Dates
using HTTP
using SHA
using URIs

function generatequerypath(requestPath::String, data::Vararg{Pair})
    query = Dict{String, String}()
    for(k, v) in data
        isnothing(v) && continue
        query[string(k)] = string(v)
    end    
    return string(URI(URI(requestPath), query=query))
end

function get(requestPath::String, data::Vararg{Pair})    
    return request("GET", generatequerypath(requestPath, data...))
end

function put(requestPath::String, data::Vararg{Pair})
    return request("PUT",requestPath, data...)
end

function post(requestPath::String, data::Vararg{Pair})
    return request("POST",requestPath, data...)
end

function delete(requestPath::String, data::Vararg{Pair})
    return request("DELETE", generatequerypath(requestPath, data...))
end

@inline timestamp(utc::DateTime=now(Dates.UTC)) = Dates.format(utc, DATE_FORMAT) # Python: datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f',)[:-3] + 'Z' OK    

function signature(timestamp::String, method::String, requestPath::String, data::Vararg{Pair})
    signatureKey = Vector{UInt8}(Preferences.apiSecret)
    decodedSignatureKey = base64UrlsafeDecode(String(signatureKey))

    signatureMsg = "$(timestamp)$(method)$(requestPath)"
    if (length(data) > 0)
        signatureMsg = "$(signatureMsg)$(JSON3.write(data))"
    end

    # Python: base64.urlsafe_b64encode(hashed.digest()).decode()
    dydxSignature = hmac_sha256(decodedSignatureKey, signatureMsg)
    return base64UrlSafeEncode(String(dydxSignature))
end

# https://github.com/dydxprotocol/dydx-v3-python/blob/master/dydx3/modules/private.py
function request(method::String, requestPath::String, data::Vararg{Pair})    
    stamp = timestamp()
    sig = signature(stamp, method, "/v3/$(requestPath)", data...)    

    return HTTP.request(method,
        URIs.resolvereference(HTTP_PRODUCTION_URL, requestPath),
        [
            "DYDX-SIGNATURE" => sig,
            "DYDX-API-KEY" => Preferences.apiKey,
            "DYDX-TIMESTAMP" => stamp,
            "DYDX-PASSPHRASE" => Preferences.apiPassPhrase
        ])
end

# https://discourse.julialang.org/t/support-for-urlsafe-alphabets-in-base64/4065

function base64UrlsafeDecode(string::String)
    s = replace(string, "-" => "+", "_" => "/")
    return base64decode(s)
end

function base64UrlSafeEncode(string::String)
    s = base64encode(string)
    return replace(s, "+" => "-", "/" => "_")
end

end