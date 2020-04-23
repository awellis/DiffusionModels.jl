
@with_kw struct DiffusionModel
    drift::Array{Float64,1}
    sigma::Array{Float64,1}
    bounds::Array{Float64, 1} 
    ndt::Tuple{Real, Real}
    Δt::Real = 0.01
    function DiffusionModel(drift::Array{Float64,1}, 
                            sigma::Array{Float64,1},
                            bounds::Array{Float64,1}, 
                            ndt::Tuple{Real, Real},
                            Δt::Real)
            new(drift, sigma, bounds, ndt, Δt)
    end
end

