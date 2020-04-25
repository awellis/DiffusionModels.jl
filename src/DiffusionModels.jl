module DiffusionModels

import Base: rand, get
export  # methods
        get, fpt, rand, ddm_fpt, ddm_rand, rand

export  # types
        AbstractDrift, ConstDrift, VarDrift,
        AbstractSigma, ConstSigma, VarSigma,
        AbstractNDT, NonDecisionTime, DiffusionModel

using Parameters, Distributions

include("drifttypes.jl")
include("sigmatypes.jl")
include("ndttypes.jl")
include("diffusiontypes.jl")
include("dm.jl")

end # module
