using MAT

function DQ_rules(d, p, n_s)
    # Run the MATLAB command from Julia
    run(`'/Applications/MATLAB_R2024a.app/bin/maca64/MATLAB' -nodisplay -nosplash -nodesktop -r "addpath(genpath('src/matlab_code')); [XW,deltamain]=generator($d,$p,$n_s); save('src/matlab_code/$(d)_$(p)_$(n_s).mat', 'XW'); exit;"`)
    # Load the output from MATLAB
    mat = matread("src/matlab_code/$(d)_$(p)_$(n_s).mat")
    return mat 
end

# define DQ_integrate, which takes a function f, a dimension d, a polynomial degree p, and a number of samples n_s, and runs DQ_rules, then for each node and weight sum f(node) * weight
function DQ_integrate(f, d, p, n_s)
    
    # matread "matlab_code/d_p_n_s.mat", using the inputs of d,p,n_s
    # if it's missing, generate mat
    mat = matread("src/matlab_code/$(d)_$(p)_$(n_s).mat")
    if isnothing(mat)
        mat = DQ_rules(d, p, n_s)
    end
    
    XW = mat["XW"] # nodes are first d columns, weights are last column
    nodes = XW[:,1:d]
    weights = XW[:,d+1]
    return sum(f(nodes[i, axes(nodes, 2)]) * weights[i] for i in 1:size(nodes, 1))
end

f(x::Vector{Float64}) = sum(xi^2 for xi in x)

# DQ_rules(5, 5, 300)
mat = matread("src/matlab_code/5_5_300.mat")
DQ_integrate(f, 5, 5, 300)