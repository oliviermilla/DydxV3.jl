module Wrappers
using JSON3

using ...Data

struct Markets
    markets::Dict{String,Market}
end

JSON3.StructTypes.StructType(::Type{Markets}) = JSON3.StructTypes.Struct()

end