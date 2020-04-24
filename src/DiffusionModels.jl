module DiffusionModels

import Base: rand
export  # methods
        fpt, rand, ddm_fpt,  ddm_rand, rand

export  # types
        NonDecisionTime, DiffusionModel

using Parameters, Distributions

include("diffusiontypes.jl")
include("dm.jl")

end # module
