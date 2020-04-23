module DiffusionModels

import Base: rand
export  # methods
        fpt, rand, ddm_fpt,  ddm_rand, rand
        # get methods
        # getdt, getmu, getm
export  # types
        DiffusionModel


using Parameters, Distributions

include("dm.jl")
# include("drifttypes.jl")
# include("sigmatypes.jl" )
# include("boundtypes.jl")
# include("ndttypes.jl")
# include("diffusiontypes.jl")

end # module
