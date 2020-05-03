abstract type AbstractNDT end
@with_kw struct NonDecisionTime{T<:Real} <: AbstractNDT
    lower::T
    upper::T
    function NonDecisionTime{T}(lower::T, upper::T) where T<:Real
        @assert 0 <= lower < upper
        new(lower, upper)
    end
end

# NonDecisionTime() = NonDecisionTime(1, 2)


@with_kw struct NDTUniform{T<:Real} <: AbstractNDT
    lower::T
    upper::T
    function NDTUniform{T}(lower::T, upper::T) where T<:Real
        @assert 0 <= lower < upper
        new(lower, upper)
    end
end

@with_kw struct NDTNormal <: AbstractNDT
    μ::Real
    σ::Real
    function NDTNormal(μ::Real, σ::Real)
        @assert σ > 0
        new(μ, σ)
    end
end

# @with_kw struct NDTWeibull <: AbstractNDT
#     α::Real # shape
#     θ::Real # scale
#     function NDTNormal(α::Real, θ::Real)
#         @assert α > 0 && θ > 0
#         new(α, θ)
#     end
# end