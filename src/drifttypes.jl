abstract type AbstractDrift end
getdt(drift::AbstractDrift) = drift.Δt

# abstract type Pointy{T} end


# TODO: separate types for drift and reliability

"""
struct SummedArray{T<:Number,S<:Number}
    data::Vector{T}
    sum::S
    function SummedArray(a::Vector{T}) where T
        S = widen(T)
        new{T,S}(a, sum(S, a))
    end
end
"""

struct ConstDrift <: AbstractDrift
    μ::Array{Float64,1}
    σ::Array{Float64,1} # FIXME: needs its own type
    Δt::Float64
    function ConstDrift(μ::Real, σ::Real, Δt::Real) 
        Δt > zero(Δt) || error("Δt needs to be positive")
        μ = [μ] 
        σ = [σ]
        new(μ, σ, Δt)
    end
end

getmu(d::ConstDrift, n::Int) = d.μ
getmu(d::ConstDrift) = d.μ
getm(d::ConstDrift, n::Int) = (n-1) * d.Δt * d.μ
getmaxn(d::ConstDrift) = typemax(Int)



# TODO: vardrift and const sigma   
struct VDrift <: AbstractDrift
    μ::Array{Float64,1}
    σ::Array{Float64,1}
    Δt::Float64
    function VDrift(μ::Real, σ::Real, Δt::Real)
        Δt > zero(Δt) || error("Δt needs to be positive")
        new(μ, σ, Δt)
    end
end


struct VarDriftOld <: AbstractDrift
    mu::Vector{Float64}
    m::Vector{Float64}
    Δt::Float64

    function VarDrift(mu::AbstractVector{T}, Δt::Real) where T <: Real
        Δt > zero(Δt) || error("Δt needs to be positive")
        length(mu) > 0 || error("mu needs to be of non-zero length")
        return new(mu, [0.0; cumsum(mu[1:(end-1)]) * float(Δt)], float(Δt))
    end
    function VarDrift(mu::AbstractVector{T}, Δt::Real, maxt::Real) where T <: Real
        Δt > zero(Δt) || error("Δt needs to be positive")
        maxt >= Δt || error("maxt needs to be at least as large as Δt")
        n = length(0:Δt:maxt)
        nmu = length(mu)
        return nmu < n ?
            VarDrift([mu; fill(mu[end], n - nmu)], Δt) : 
            VarDrift(mu[1:n], Δt)
    end
end

# getmu(d::VarDrift, n::Int) = d.mu[n]
# getm(d::VarDrift, n::Int) = d.m[n]
# getmaxn(d::VarDrift) = length(d.mu)
