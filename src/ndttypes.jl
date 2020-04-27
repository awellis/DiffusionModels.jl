abstract type AbstractNDT end
@with_kw struct NonDecisionTime{T<:Real} <: AbstractNDT
    lower::T
    upper::T
    function NonDecisionTime{T}(lower::T, upper::T) where T<:Real
        @assert 0 < lower < upper
        new{T}(lower, upper)
    end
end