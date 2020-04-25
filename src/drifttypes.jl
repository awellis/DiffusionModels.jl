abstract type AbstractDrift end

getmu(drift::AbstractDrift) = drift.μ

@with_kw struct ConstDrift <: AbstractDrift
    μ::Real
end
getmu(drift::ConstDrift) = [drift.μ]

@with_kw struct VarDrift <: AbstractDrift
    μ::Array{Float64,1}
end
