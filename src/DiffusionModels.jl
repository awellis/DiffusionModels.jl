module DiffusionModels

import Base: rand
export  # methods
        fpt, rand, getdt, getmu, getm, 
        # types
        ConstDrift, VarDrift,
        ConstSigma, VarSigma,
        ConstBound, VarBound,
        ConstSymBounds, VarSymBounds,
        ConstAsymBound, VarAsymBound,
        NDT

using Parameters, Distributions

include("dm.jl")
include("drifttypes.jl")
include("sigmatypes.jl" )
include("boundtypes.jl")
include("ndttypes.jl")

end # module
