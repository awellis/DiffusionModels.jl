abstract type AbstractDiffusion end


@with_kw struct Diffusion4
    drift::AbstractDrift
    # TODO:
    # sigma::AbstractSigma
    # bounds::AbstractBounds 
    # ndt::AbstractNDT
    Δt::Float64 = 0.01
    # function Diffusion1(drift::AbstractDrift, sigma::AbstractSigma,
                    #    bounds::AbstractBounds, Δt::Float64)

            # new(drift::AbstractDrift,
            # sigma::AbstractSigma,
            # bounds::AbstractBounds,
            # Δt::Float64)
    # end
end



drift = ConstDrift(1, 0.01)
d = Diffusion4(drift = drift)