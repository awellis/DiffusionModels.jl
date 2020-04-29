# DiffusionModels

This repository provides a Julia interface to Jan Drugowitsch's 
[C++ Diffusion model library](https://github.com/DrugowitschLab/dm).

No guarantee is provided for the correctness of the implementation.

The code is licensed under the New BSD License.

## Usage

The function `fpt` returns the first passage time densities up to `tmax` for the upper
and lower bounds of a diffusion model with time-varying drift, time-varying
variance and time-varying asymmetric bounds.

`rand` returns random numbers from a diffusion model, either with or without
a non-decision time.



## Example

In this example, we use a constant drift, constant standard deviation and
constant symmetric bounds (`ndt` currently has no effect on first-passage time).

```julia
μ = ConstDrift(1.2)
σ = ConstSigma(1)
bounds = ConstSymBounds(2,-2)
ndt = NonDecisionTime(lower = 2, upper = 3)
dm = DiffusionModel(μ, σ, bounds, ndt, Δt = 0.01)
```

### First passage time densities

```julia
upper, lower = fpt(dm, tmax = 10.0)
```


### Random samples


```julia
choice, rt = rand(dm, 100)
```
