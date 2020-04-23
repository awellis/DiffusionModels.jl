
# pwd() doesn't work - it is evaluated in the directory in which the function is called
# const deps_path = joinpath(dirname(pwd()), "deps", "ddm_fpt_lib")

# function showdir() 
#    println(@__DIR__)
#    println(pwd())
# end

const deps_path = joinpath(dirname(@__DIR__), "deps", "ddm_fpt_lib")


@with_kw struct DiffusionModel
    drift::Array{Float64,1}
    sigma::Array{Float64,1}
    bound_hi::Array{Float64, 1} 
    bound_lo::Array{Float64, 1} 
    ndt::Tuple{Float64, Float64}
    Δt::Float64 = 0.01
    function DiffusionModel(drift::Array{Float64,1}, 
                            sigma::Array{Float64,1},
                            bound_hi::Array{Float64,1},
                            bound_lo::Array{Float64}, 
                            ndt::Tuple{Float64, Float64},
                            Δt::Float64)
            new(drift, sigma, bound_hi, bound_lo, ndt, Δt)
    end
end

# usage
# dm = DiffusionModel([1.], [1.], [1.], [-1.], (2.0,3.0), 0.1)
# fpt(dm, tmax = 10.0)
# rand(dm, n = 100)

function fpt(dm::DiffusionModel; 
    tmax::Real = 15)

    mu = dm.drift
    sig = dm.sigma
    bound_hi = dm.bound_hi
    bound_lo = dm.bound_lo
    Δt = Float64(dm.Δt)

    nsteps = Int(tmax / Δt)
    g1 = Array{Float64}(undef, nsteps)
    g2 = Array{Float64}(undef, nsteps)

    err = ccall((:ddm_fpt, deps_path),
            Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, 
            Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, 
            Cint, Cdouble, Cdouble, Ptr{Cdouble}, 
            Ptr{Cdouble}),
            mu, length(mu),
            sig, length(sig),
            bound_lo, length(bound_lo),
            bound_hi, length(bound_hi),
            Δt, tmax, g1, g2)

    return (upper = g1, lower = g2)

end


function ddm_fpt(mu::Array{Float64,1},
                sig::Array{Float64,1},
                bound_lo::Array{Float64,1},
                bound_hi::Array{Float64,1};
                Δt::Float64 = 0.01,
                tmax::Float64 = 15)

    # @assert bound_lo < 0.0
    # @assert bound_hi > 0.0
    # @assert Δt > 0.0
    # @assert tmax > 0.0

    nsteps = Int(tmax / Δt)
    g1 = Array{Float64}(undef, nsteps)
    g2 = Array{Float64}(undef, nsteps)

    err = ccall((:ddm_fpt, deps_path),
            Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, 
            Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, 
            Cint, Cdouble, Cdouble, Ptr{Cdouble}, 
            Ptr{Cdouble}),
            mu, length(mu),
            sig, length(sig),
            bound_lo, length(bound_lo),
            bound_hi, length(bound_hi),
            Δt, tmax, g1, g2)

    return (upper = g1, lower = g2)
end


# import Base.rand

#TODO: types for drift, etc
function ddm_rand(mu::Array{Float64,1},
                sig::Array{Float64,1},
                bound_lo::Array{Float64,1},
                bound_hi::Array{Float64,1};
                Δt::Float64 = 0.01,
                n::Int64 = 1000,
                seed::Int64 = 123)

#     @assert bound_lo <= 0.0
#     @assert bound_hi >= 0.0
#     @assert Δt > 0.0
#     @assert tmax > 0.0

    t = Array{Float64}(undef, n)
    bound_cond = Array{Int64}(undef, n)

    err = ccall((:ddm_rand, deps_path),Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint,
                                                Cdouble, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}),
            mu,length(mu),sig,length(sig),bound_lo,length(bound_lo),bound_hi,length(bound_hi),Δt,n,seed,t,bound_cond)

    return (rt = t, choice = bound_cond)
end


function ddm_rand(mu::Array{Float64,1},
                sig::Array{Float64,1},
                bound_lo::Array{Float64,1},
                bound_hi::Array{Float64,1},
                ndt::Tuple{Float64, Float64};
                Δt::Float64 = 0.01,
                n::Int64 = 1000,
                seed::Int64 = 123)

#     @assert bound_lo <= 0.0
#     @assert bound_hi >= 0.0
#     @assert Δt > 0.0
#     @assert tmax > 0.0
    # TODO: convert mu to Array
    # TODO: convert sigma to Array

    t = Array{Float64}(undef, n)
    bound_cond = Array{Int64}(undef, n)
    err = ccall((:ddm_rand, deps_path),Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint,
                                                Cdouble, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}),
            mu,length(mu),sig,length(sig),bound_lo,length(bound_lo),bound_hi,length(bound_hi),Δt,n,seed,t,bound_cond)
    
    ndts = ndt[1] .+ (ndt[2] - ndt[1]) .* Base.rand(n)
    t += t .+ ndts
    return (rt = t, choice = bound_cond)
end


function Base.rand(dm::DiffusionModel, n::Int64 = 1000;
                    seed::Int64 = 123)

    mu = dm.drift
    sig = dm.sigma
    bound_hi = dm.bound_hi
    bound_lo = dm.bound_lo
    ndt = dm.ndt
    Δt = Float64(dm.Δt)

    t = Array{Float64}(undef, n)
    bound_cond = Array{Int64}(undef, n)
    err = ccall((:ddm_rand, deps_path),Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint,
                                                Cdouble, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}),
            mu,length(mu),sig,length(sig),bound_lo,length(bound_lo),bound_hi,length(bound_hi),Δt,n,seed,t,bound_cond)
    
    ndts = ndt[1] .+ (ndt[2] - ndt[1]) .* Base.rand(n)
    t += t .+ ndts
    return (rt = t, choice = bound_cond)
end