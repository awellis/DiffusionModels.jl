abstract type AbstractSigma end
# getdt(drift::AbstractDrift) = drift.Δt


@with_kw struct ConstSigma <: AbstractSigma
    # μ::Array{Float64,1}
    σ::Array{Float64,1}
    Δt::Float64
    function ConstSigma(μ::Real, Δt::Real) 
        Δt > zero(Δt) || error("Δt needs to be positive")
        # μ = [μ] 
        σ = [σ]
        new(σ, Δt)
    end
end

struct VarSigma <: AbstractSigma
end
