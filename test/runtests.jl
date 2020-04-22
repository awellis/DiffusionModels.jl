using DataFrames, Query, StatsPlots

# include("dm.jl")
using DiffusionModels


# mu = 1.2
# bound = 1.1
# t = 0.5
# dt = 0.005
# tmax = 3.0
# maxn = length(0:dt:tmax)


    ``
# mu = np.array([1.0])
# mu2 = np.array([1.0])
# sig2 = np.array([1.0])
# bound = np.array([1.0])
# bound_lo = np.array([-1.5])
# bound_deriv = np.zeros(1)
# dt = 0.01
# dt_rand = 0.001
# tmax = 4.0
# n = 1000



drift = [1.2]
sig = [1.0]
bound_lo = [-1.1]
bound_hi = [1.1]

dens = fpt(drift, sig, bound_lo, bound_hi, 
             Δt = 0.01, tmax = 10.0)

# rt, choice = rand([0.1], [1.0], [-1.0], [1.0], 
#                   Δt = 0.01, n = 1000, seed = 123)


# with non-decision time
out = rand(drift, sig, bound_lo, bound_hi, 
            (3.0, 6.0),
           Δt = 0.01, n = 1000, seed = 123)

# without non-decision time
# out2 = rand([0.1], [1.0], [-1.0], [1.0], 
#            Δt = 0.01, n = 1000, seed = 123)
df = DataFrame(out)


 df |> 
    @filter(_.choice == 1)



## StatsPlots plots
plot([dens.upper, -dens.lower])

df |>
    @df histogram(:rt, group = :choice)

df |>
    @filter(_.choice == 1) |>
    # @map({_.b, d = _.c-10}) |>
    @df histogram(:rt)

df |>
      @df violin(:choice, :rt, group = :choice)   
df |>
    @df dotplot!(:choice, :rt, marker = (:black, stroke(0)), alpha = 0.4)




## VegaLite plots 
using VegaLite

df |>
    @vlplot(:bar, x = {:rt, bin = true}, y = "count()", 
            color = "choice:n")
