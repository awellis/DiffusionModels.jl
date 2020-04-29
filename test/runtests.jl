using DiffusionModels



μ = ConstDrift(1.2)
σ = ConstSigma(1)
bounds = ConstSymBounds(2,-2)
ndt = NonDecisionTime(lower = 2, upper = 3)
dm = DiffusionModel(μ, σ, bounds, ndt, Δt = 0.01)

upper, lower = fpt(dm, tmax = 10.0)
choice, rt = rand(dm, 100)








# or using the basic type constructor:

drift = [1.2]
sig = [1.0]
bound_lo = [-1.1]
bound_hi = [1.1]
ndt = (2.0, 3.0)

upper, lower = ddm_fpt(drift, sig, bound_lo, bound_hi, 
                        Δt = 0.01, tmax = 10.0)


# with non-decision time
ndt = (3.0, 6.0)
choice, rt = ddm_rand(drift, sig, bound_lo, bound_hi, ndt, Δt = 0.01, n = 1000, seed = 123)

# without non-decision time
choice, rt = ddm_rand(drift, sig, bound_lo, bound_hi, Δt = 0.01, n = 1000, seed = 123)

