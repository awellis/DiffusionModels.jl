using DataFrames, Query, StatsPlots, DiffusionModels



drift = [1.2]
sig = [1.0]
bound_lo = [-1.1]
bound_hi = [1.1]

dens = ddm_fpt(drift, sig, bound_lo, bound_hi, 
             Δt = 0.01, tmax = 10.0)

# rt, choice = rand([0.1], [1.0], [-1.0], [1.0], 
#                   Δt = 0.01, n = 1000, seed = 123)


# with non-decision time
ndt = (3.0, 6.0)
out1 = ddm_rand(drift, sig, bound_lo, bound_hi, ndt, Δt = 0.01, n = 1000, seed = 123)

# without non-decision time
out2 = ddm_rand(drift, sig, bound_lo, bound_hi, Δt = 0.01, n = 1000, seed = 123)


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
