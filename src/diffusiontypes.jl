
@with_kw struct DiffusionModel
    drift::Array{Float64,1}
    sigma::Array{Float64,1}
    bound_hi::Array{Float64, 1} 
    bound_lo::Array{Float64, 1} 
    ndt::Tuple{Float64, Float64}
    Δt::Float64 = 0.01
    function DiffusionModel(drift::Array{Float64,1}, 
                            sigma::Array{Float64,1},
                            bound_hi::Array{Float64,1},
                            bound_lo::Array{Float64}, 
                            ndt::Tuple{Float64, Float64},
                            Δt::Float64)
            new(drift, sigma, bound_hi, bound_lo, ndt, Δt)
    end
end
