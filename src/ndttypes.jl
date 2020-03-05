abstract type AbstractNDT end
getdt(drift::AbstractNDT) = drift.Δt

struct NDT
end