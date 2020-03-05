abstract type AbstractSigma end
getdt(drift::AbstractDrift) = drift.Δt



struct ConstSigma 
end

struct VarSigma
end
