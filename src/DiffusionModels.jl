module DiffusionModels

using Parameters, Distributions

import Base: rand, get

export get, fpt, rand, ddm_fpt, ddm_rand

export AbstractDrift, 
        ConstDrift, VarDrift,
        AbstractSigma, 
        ConstSigma, VarSigma,
        AbstractBounds, AbstractConstBounds, AbstractVarBounds,
        ConstSymBounds, ConstAsymBounds, 
        VarSymBounds, VarAsymBounds,
        AbstractNDT, 
        NonDecisionTime, 
        DiffusionModel

include("drifttypes.jl")
include("sigmatypes.jl")
include("boundtypes.jl")
include("ndttypes.jl")
include("diffusiontypes.jl")
include("dm.jl")

end # module
