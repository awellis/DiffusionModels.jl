module DiffusionModels

using Parameters, Distributions

import Base: rand, get

export get, fpt, rand, ddm_fpt, ddm_rand
export AbstractDrift, ConstDrift, VarDrift
export AbstractSigma, ConstSigma, VarSigma
export AbstractBounds
export AbstractConstBounds, ConstSymBounds, ConstAsymBounds
export AbstractVarBounds, VarSymBounds, VarAsymBounds
export DecayingBound, DecayingBounds
export AbstractNDT, NonDecisionTime
export DiffusionModel

include("drifttypes.jl")
include("sigmatypes.jl")
include("boundtypes.jl")
include("ndttypes.jl")
include("diffusiontypes.jl")
include("dm.jl")

end # module
