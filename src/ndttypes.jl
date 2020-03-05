abstract type AbstractNDT end

@with_kw struct NonDecisionTime{T<:Real} <: AbstractNDT
    # ndt::Tuple{Float64, Float64};
    lower::T
    upper::T
    function NonDecisionTime{T}(lower::T, upper::T) where T<:Real
        @assert 0 < lower < upper
        new{T}(lower, upper)
    end
end

NonDecisionTime(lower::Int64, upper::Int64) = NonDecisionTime(convert(Float64, lower),
                                                              convert(Float64, upper))
NonDecisionTime(lower::Real, upper::Real) = NonDecisionTime(promote(lower, upper)...)