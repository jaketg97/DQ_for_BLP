struct DefaultMicroIntegrator{T<:Flt} <: MicroIntegrator{T}   
    n   :: Int
end

function DefaultMicroIntegrator( n :: Int, T = F64; options = nothing )
    @ensure n > 0  "n must be positive"
    DefaultMicroIntegrator{T}( n )
end

function NodesWeightsGlobal( ms :: DefaultMicroIntegrator{T}, d :: Int,  rng :: AbstractRNG ) where {T<:Flt}

  return GrumpsNodesWeights{T}(n, w)
end

function NodesWeightsOneMarket( ms :: DefaultMicroIntegrator{T}, d :: Int, rng :: AbstractRNG, nwgmic :: GrumpsNodesWeights{T}, S :: Int ) where {T<:Flt}
   return nwgmic
end