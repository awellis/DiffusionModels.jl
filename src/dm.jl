
# pwd() doesn't work - it is evaluated in the directory in which the function is called
# const deps_path = joinpath(dirname(pwd()), "deps", "ddm_fpt_lib")

# function showdir() 
#    println(@__DIR__)
#    println(pwd())
# end

const deps_path = joinpath(dirname(@__DIR__), "deps", "ddm_fpt_lib")


function fpt(dm::DiffusionModel; tmax::Real = 15)

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
    
    if typeof(ndt) <: NDTNormal
        ndts = rand(Normal(ndt.μ, ndt.σ), n)
        ndts = exp.(ndts)
    elseif typeof(ndt) <: NDTUniform
        ndts = ndt.lower .+ (ndt.upper - ndt.lower) .* Base.rand(n)
    else typeof(ndt) <: NonDecisionTime
        ndts = rand(ndt.d, n)
        f = ndt.link
        ndts = f.(ndts)
    end

    t += t .+ ndts
    return (rt = t, choice = bound_cond)
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

    t = Array{Float64}(undef, n)
    bound_cond = Array{Int64}(undef, n)
    err = ccall((:ddm_rand, deps_path),Cint,(Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint,
                                                Cdouble, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}),
            mu,length(mu),sig,length(sig),bound_lo,length(bound_lo),bound_hi,length(bound_hi),Δt,n,seed,t,bound_cond)
    
    ndts = ndt[1] .+ (ndt[2] - ndt[1]) .* Base.rand(n)
    t += t .+ ndts
    return (rt = t, choice = bound_cond)
end
