

for fn ∈ [ "error", "early", "types", "est", "utils", "io", "integration", "data", "sol", "space", "threads", "optim", "probs", "array", "imports", "tree", "inference" ]
    include( "$fn/$(fn).jl" )
end

