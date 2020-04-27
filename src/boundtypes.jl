abstract type AbstractBounds end
abstract type AbstractConstBounds <: AbstractBounds end
abstract type AbstractVarBounds <: AbstractBounds end

# TODO: use promote
# Point(x::Real, y::Real) = Point(promote(x,y)...);
@with_kw struct ConstSymBounds{T<:Real} <: AbstractConstBounds
    hi::T
    lo::T
    function ConstSymBounds{T}(hi::T, lo::T) where T<:Real
        hi > zero(hi) || error("upper bound needs to be positive")
        lo < zero(lo) || error("lower bound needs to be negative")
        @assert isequal(hi, -lo)
        new(hi, lo)
    end
end

ConstSymBounds(b::Real) = ConstSymBounds(b, -b)
ConstSymBounds() = ConstSymBounds(1, -1)

@with_kw struct ConstAsymBounds{T<:Real} <: AbstractConstBounds
    hi::T
    lo::T
    function ConstAsymBounds{T}(hi::T, lo::T) where T<:Real
        hi > zero(hi) || error("upper bound needs to be positive")
        lo < zero(lo) || error("lower bound needs to be negative")
        new(hi, lo)
    end
end

@with_kw struct VarSymBounds <: AbstractVarBounds
    hi::Array{Float64,1}
    lo::Array{Float64,1}
    function VarSymBounds(hi::Array{Float64,1}, lo::Array{Float64,1})
        all(hi .> 0) || error("upper bound needs to be positive")
        all(lo .< 0) || error("lower bound needs to be negative")
        @assert isequal(hi, -lo)
        new(hi, lo)
    end
end


@with_kw struct VarAsymBounds <: AbstractVarBounds
    hi::Array{Float64,1}
    lo::Array{Float64,1}
    function VarAsymBounds(hi::Array{Float64,1}, lo::Array{Float64,1})
        all(hi .> 0) || error("upper bound needs to be positive")
        all(lo .< 0) || error("lower bound needs to be negative")
        new(hi, lo)
    end
end


function get(b::AbstractConstBounds)
    hi = [b.hi]
    lo = [b.lo]
    return (hi = hi, lo = lo)
end

function get(b::AbstractVarBounds)
    hi = b.hi
    lo = b.lo
    return (hi = hi, lo = lo)
end
