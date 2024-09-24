# SETUP FOR GRUMPS INTEGRATION
struct DefaultMicroIntegrator{T<:Flt} <: MicroIntegrator{T}   
    n   :: Int
end

function DefaultMicroIntegrator( n :: Int, T = F64; options = nothing )
    @ensure n > 0  "n must be positive"
    DefaultMicroIntegrator{T}( n )
end

function NodesWeightsGlobal( ms :: DefaultMicroIntegrator{T}, d :: Int,  rng :: AbstractRNG ) where {T<:Flt}
    n, w = DQ_readrules(d, 10, 50)                                                 # compute Gauss Hermite nodes and weights in a single dimension
    return GrumpsNodesWeights{T}(n, w)
 end

function NodesWeightsOneMarket( ms :: DefaultMicroIntegrator{T}, d :: Int, rng :: AbstractRNG, nwgmic :: GrumpsNodesWeights{T}, S :: Int ) where {T<:Flt}
    return nwgmic
 end

# DESIGNED QUADRATURE COMMAND(S)
 
function DQ_genrules(d, p, n_s)
    # Run the MATLAB command from Julia
    run(`'/Applications/MATLAB_R2024a.app/bin/maca64/MATLAB' -nodisplay -nosplash -nodesktop -r "addpath(genpath('/Users/jacobgosselin/Documents(local)/GitHub/Grumps.jl/src/integrators/designedquadrature/matlab_code')); [XW,deltamain]=generator($d,$p,$n_s); save('/Users/jacobgosselin/Documents(local)/GitHub/Grumps.jl/src/integrators/designedquadrature/matlab_code/$(d)_$(p)_$(n_s).mat', 'XW'); exit;"`)
    # Load the output from MATLAB
    mat = matread("$(@__DIR__)/matlab_code/$(d)_$(p)_$(n_s).mat")
    return mat 
end

# define DQ_integrate, which takes a function f, a dimension d, a polynomial degree p, and a number of samples n_s, and runs DQ_rules, then for each node and weight sum f(node) * weight
function DQ_readrules(d, p, n_s)
    # matread "matlab_code/d_p_n_s.mat", using the inputs of d,p,n_s
    # if it's missing, generate mat
    file_path = "/Users/jacobgosselin/Documents(local)/GitHub/Grumps.jl/src/integrators/designedquadrature/matlab_code/$(d)_$(p)_$(n_s).mat"
    # Check if the file exists
    if !isfile(file_path)
        # If the file does not exist, generate it using DQ_rules
        DQ_genrules(d, p, n_s)
    end
    mat = matread("/Users/jacobgosselin/Documents(local)/GitHub/Grumps.jl/src/integrators/designedquadrature/matlab_code/$(d)_$(p)_$(n_s).mat")
    XW = mat["XW"] # nodes are first d columns, weights are last column
    nodes = XW[:,1:d]
    weights = XW[:,d+1]
    return nodes, weights
end