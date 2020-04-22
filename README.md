# DiffusionModels

This repository provides a Julia interface to Jan Drugowitsch's 
[C++ Diffusion model library](https://github.com/DrugowitschLab/dm).

No guarantee is provided for the correctness of the implementation.

The code is licensed under the New BSD License.

## Usage

The function `ddm_fpt` returns the first passage time densities for the upper
and lower bounds of a diffusion model with time-varying drift, time-varying
variance and time-varying asymmetric bounds.

`ddm_rand` returns random numbers from a diffusion model, either with or without
a non-decision time.



## Example

In this example, we use a constant drift, constant standard deviation and
constant symmetric bounds.

```julia
drift = [1.2]
sig = [1.0]
bound_lo = [-1.1]
bound_hi = [1.1]
```

### First passage time

```julia
upper, lower = ddm_fpt(drift, sig, bound_lo, bound_hi,
                       Δt = 0.01, tmax = 6.0)
```


### Random samples

With non-decision time
```julia
ndt = (3.0, 6.0)
choice, rt = ddm_rand(drift, sig, bound_lo, bound_hi, ndt, Δt = 0.01, n = 1000, seed = 123)
```

and without non-decision time:

```julia
choice, rt = ddm_rand(drift, sig, bound_lo, bound_hi, Δt = 0.01, n = 1, seed = 123)
```