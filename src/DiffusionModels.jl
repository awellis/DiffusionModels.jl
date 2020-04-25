module DiffusionModels

import Base: rand
export  # methods
        getmu, fpt, rand, ddm_fpt, ddm_rand, rand

export  # types
        AbstractDrift, ConstDrift, VarDrift,
        NonDecisionTime, DiffusionModel

using Parameters, Distributions

include("drifttypes.jl")
include("diffusiontypes.jl")
include("dm.jl")

end # module
