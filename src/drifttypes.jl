abstract type AbstractDrift end

get(drift::AbstractDrift) = drift.μ

@with_kw struct ConstDrift <: AbstractDrift
    μ::Real
end

ConstDrift() = ConstDrift(1)

get(drift::ConstDrift) = [drift.μ]

@with_kw struct VarDrift <: AbstractDrift
    μ::Array{Float64,1}
end
