module DiffusionModels

import Base: rand
export  # methods
        ddm_fpt, ddm_rand
        # get methods
        # getdt, getmu, getm
        # types
        # ConstDrift, VarDrift,
        # ConstSigma, VarSigma,
        # ConstBound, VarBound,
        # ConstSymBounds, VarSymBounds,
        # ConstAsymBound, VarAsymBound,
        # NDT

using Parameters, Distributions

include("dm.jl")
# include("drifttypes.jl")
# include("sigmatypes.jl" )
# include("boundtypes.jl")
# include("ndttypes.jl")

end # module
