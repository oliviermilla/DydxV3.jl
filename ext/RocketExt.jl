module RocketExt

import DydxV3

using Rocket

Rocket.scalarness(::Type{DydxV3.Trade}) = Rocket.Scalar()

end