abstract type AbstractSigma end

get(sigma::AbstractSigma) = sigma.σ

@with_kw struct ConstSigma <: AbstractSigma
    σ::Real
end

# ConstSigma() = ConstSigma(1)

get(sigma::ConstSigma) = [sigma.σ]

@with_kw struct VarSigma <: AbstractSigma
    σ::Array{Float64,1}
end


