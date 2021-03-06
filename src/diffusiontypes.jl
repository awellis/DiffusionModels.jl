
@with_kw struct DiffusionModel
    drift::Array{Float64,1}
    sigma::Array{Float64,1}
    bound_hi::Array{Float64, 1} 
    bound_lo::Array{Float64, 1} 
    ndt::NTuple{2, Float64}
    Δt::Float64 = 0.01
    function DiffusionModel(drift::Array{Float64,1}, 
                            sigma::Array{Float64,1},
                            bound_hi::Array{Float64,1},
                            bound_lo::Array{Float64}, 
                            ndt::NTuple{2, Float64},
                            Δt::Float64)
            new(drift, sigma, bound_hi, bound_lo, ndt, Δt)
    end
end

function DiffusionModel(drift::Real, sigma::Real, 
                bound_hi::Real, bound_lo::Real,
                ndt::NonDecisionTime; 
                Δt::Real = 0.01)
    @assert bound_hi > 0
    @assert bound_lo < 0
    
    drift = convert(Array{Float64, 1}, [drift])
    sigma = convert(Array{Float64, 1}, [sigma])
    bound_hi = convert(Array{Float64, 1}, [bound_hi])
    bound_lo = convert(Array{Float64, 1}, [bound_lo])
    ndt = convert(NTuple{2, Float64}, (ndt.lower, ndt.upper))
    Δt = convert(Float64, Δt)

    out = DiffusionModel(drift, sigma,
            bound_hi, bound_lo, ndt, Δt)
    return out
end


function DiffusionModel(drift::AbstractDrift, sigma::AbstractSigma, 
                bounds::AbstractBounds, ndt::NonDecisionTime; 
                Δt::Real = 0.01)
    hi, lo = get(bounds)
    drift = convert(Array{Float64, 1}, get(drift))
    sigma = convert(Array{Float64, 1}, get(sigma))
    bound_hi = convert(Array{Float64, 1}, hi)
    bound_lo = convert(Array{Float64, 1}, lo)
    ndt = convert(NTuple{2, Float64}, (ndt.lower, ndt.upper))
    Δt = convert(Float64, Δt)

    out = DiffusionModel(drift, sigma,
            bound_hi, bound_lo, ndt, Δt)
    return out
end