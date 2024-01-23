using Test
using DydxV3

@test DydxV3.Private.Api.generatequerypath("api","a" => "b", "c" => nothing) == "api?a=b"