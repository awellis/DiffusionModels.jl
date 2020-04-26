abstract type AbstractBounds end
abstract  type AbstractConstBounds <: AbstractBounds end
abstract  type AbstractVarBounds <: AbstractBounds end

struct ConstSymBounds{T<:Real} <: AbstractConstBounds
    hi::T
    lo::T
    function ConstSymBounds(hi::T, lo::T) where T<:Real
        hi > zero(hi) || error("upper bound needs to be positive")
        lo < zero(lo) || error("lower bound needs to be negative")
        @assert isequal(hi, -lo)
        new{T}(hi, lo)
    end
end

struct ConstAsymBounds{T<:Real} <: AbstractConstBounds
    hi::T
    lo::T
    function ConstAsymBounds(hi::T, lo::T) where T<:Real
        hi > zero(hi) || error("upper bound needs to be positive")
        lo < zero(lo) || error("lower bound needs to be negative")
        new{T}(hi, lo)
    end
end

struct VarSymBounds <: AbstractVarBounds
    hi::Array{Float64,1}
    lo::Array{Float64,1}
    function VarSymBounds(hi::Array{Float64,1}, lo::Array{Float64,1})
        hi .> zero(hi) || error("upper bound needs to be positive")
        lo .< zero(lo) || error("lower bound needs to be negative")
        @assert isequal(hi, -lo)
        new(hi, lo)
    end
end


struct VarAsymBounds <: AbstractVarBounds
    hi::Array{Float64,1}
    lo::Array{Float64,1}
    function VarAsymBounds(hi::Array{Float64,1}, lo::Array{Float64,1})
        hi .> zero(hi) || error("upper bound needs to be positive")
        lo .< zero(lo) || error("lower bound needs to be negative")
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
