# constant and time-varying bounds and bound pairs

# TODO:
# - add bounds constructors with maxt, to extend/shorten given bounds

# single bounds
abstract type AbstractBound end
getΔt(b::AbstractBound) = b.Δt

struct ConstBound <: AbstractBound
    b::Float64
    Δt::Float64

    function ConstBound(b::Real, Δt::Real)
        b > zero(b) || error("bound needs to be positive")
        Δt > zero(Δt) || error("Δt needs to be positive")
        return new(float(b), float(Δt))
    end
end
getbound(b::ConstBound, n::Int) = b.b
getbound(b::ConstBound) = b.b
getboundgrad(b::ConstBound, n::Int) = 0.0
getmaxn(b::ConstBound) = typemax(Int)

struct VarBound <: AbstractBound
    b::Vector{Float64}
    bg::Vector{Float64}
    Δt::Float64

    function VarBound(b::AbstractVector{T1}, bg::AbstractVector{T2},
                        Δt::Real) where {T1 <: Real, T2 <: Real}  Δt > zero(Δt) || error("Δt needs to be positive")
        length(b) > 0 || error("bounds need to be of non-zero length")
        length(b) == length(bg) || error("b and bg need to be of same length")
        b[1] > 0.0 || error("b[1] needs to be positive")
        return new(b, bg, float(Δt))
    end
    VarBound(b::AbstractVector{T}, Δt::Real) where T <: Real = VarBound(b, fdgrad(b, Δt), Δt)
end
getbound(b::VarBound, n::Int) = b.b[n]
getboundgrad(b::VarBound, n::Int) = b.bg[n]
getmaxn(b::VarBound) = length(b.b)

struct LinearBound <: AbstractBound
    b0::Float64
    bslope::Float64
    Δtbslope::Float64
    Δt::Float64
    maxn::Int

    function LinearBound(b0::Real, bslope::Real, Δt::Real, maxt::Real=Inf)
        Δt > zero(Δt) || error("Δt needs to be positive")
        b0 > zero(Δt) || error("b0 needs to be positive")
        maxt > zero(maxt) || error("maxt needs to be positive")
        maxn = maxt / Δt
        # subtracting Δt * bslope ensures that getbound(b, 1) = b0
        return new(b0 - Δt * bslope, bslope, Δt * bslope, Δt,
            isfinite(maxn) ? ceil(Int, maxn) : typemax(Int))
    end
end
getbound(b::LinearBound, n::Int) = b.b0 + n * b.Δtbslope
getboundgrad(b::LinearBound, n::Int) = b.bslope
getmaxn(b::LinearBound) = b.maxn




abstract type AbstractBounds 
end                                                                                                                                                                                                                                                                                                                    end

struct SymBounds{T <: AbstractBound} <: AbstractBounds
    b::T

    SymBounds{T}(b::T) where T = new(b)
end
getΔt(b::SymBounds) = getΔt(b.b)
getubound(b::SymBounds, n::Int) = getbound(b.b, n)
getlbound(b::SymBounds, n::Int) = -getbound(b.b, n)
getuboundgrad(b::SymBounds, n::Int) = getboundgrad(b.b, n)
getlboundgrad(b::SymBounds, n::Int) = -getboundgrad(b.b, n)
getmaxn(b::SymBounds) = getmaxn(b.b)

const VarSymBounds = SymBounds{VarBound}

const ConstSymBounds = SymBounds{ConstBound}
ConstSymBounds(b::Real, Δt::Real) = ConstSymBounds(ConstBound(b, Δt))
getbound(b::ConstSymBounds) = b.b.b

const LinearSymBounds = SymBounds{LinearBound}
LinearSymBounds(b0::Real, bslope::Real, Δt::Real) = LinearSymBounds(LinearBound(b0, bslope, Δt))

struct AsymBounds{T1 <: AbstractBound, T2 <: AbstractBound} <: AbstractBounds
    upper::T1
    lower::T2

    function AsymBounds{T1,T2}(upper::T1, lower::T2) where {T1,T2}
        getΔt(upper) == getΔt(lower) || error("Bounds need to have equal Δt")
        return new(upper, lower)
    end
end
getΔt(b::AsymBounds) = getΔt(b.upper)
getubound(b::AsymBounds, n::Int) = getbound(b.upper, n)
getlbound(b::AsymBounds, n::Int) = -getbound(b.lower, n)
getuboundgrad(b::AsymBounds, n::Int) = getboundgrad(b.upper, n)
getlboundgrad(b::AsymBounds, n::Int) = -getboundgrad(b.lower, n)
getmaxn(b::AsymBounds) = min(getmaxn(b.upper), getmaxn(b.lower))

const VarAsymBounds = AsymBounds{VarBound, VarBound}

const ConstAsymBounds = AsymBounds{ConstBound, ConstBound}
ConstAsymBounds(upper::Real, lower::Real, Δt::Real) =
    ConstAsymBounds(ConstBound(upper, Δt), ConstBound(-lower, Δt))
getubound(b::ConstAsymBounds) = getbound(b.upper)
getlbound(b::ConstAsymBounds) = -getbound(b.lower)

const ConstBounds = Union{ConstSymBounds, ConstAsymBounds}
