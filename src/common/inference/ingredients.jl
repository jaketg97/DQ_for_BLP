








abstract type Ingredients{T<:Flt} end


function Ingredients( sol :: Solution, anythingwhatsoever, d :: GrumpsData, f :: FGH, seo :: StandardErrorOptions )
    @warn "standard errors not yet implemented for this case"
end


struct GrumpsIngredients{T<:Flt} <: Ingredients{T}
    ranges  :: Vec{ UnitRange{Int} }
    Ωθθ     :: Mat{T}
    Ωδθ     :: VMatrix{T}
    Ωδδ     :: VMatrix{T} 
    Ωδδinv  :: VMatrix{T} 
    ΩδδinvΩδθ   :: VMatrix{T}
    Hinvθθ  :: Mat{T}
    K       :: VMatrix{T}
    Δ       :: Matrix{T}
    Ξ       :: VMatrix{T}
    KVK     :: Mat{T}
    KVΞ     :: Mat{T}
    ΞVΞ     :: Mat{T}
    AinvB   :: VMatrix{T}
    AinvC   :: VMatrix{T}
    Xstar   :: Mat{T}
    Ystar   :: Mat{T}
    Zstar   :: Mat{T}
end

function Ingredients( sol :: Solution{T}, ::Val{:defaultseprocedure}, d :: GrumpsData{T}, fgh :: FGH{T}, seo :: StandardErrorOptions  ) where {T<:Flt}
    markets = 1:dimM( d )
    ranges = Ranges( dimδm( d ) )
    Ωθθ = sum( fgh.market[m].outside.Hθθ for m ∈ markets )
    Ωδθ = [ fgh.market[m].outside.Hδθ for m ∈ markets ]
    Ωδδ = [ fgh.market[m].inside.Hδδ for m ∈ markets ]
    Ωδδinv = [ inv( Ωδδ[m] ) for m ∈ markets ]
    ΩδδinvΩδθ = [ Ωδδinv[m] * Ωδθ[m] for m ∈ markets ]


    K = [ d.plmdata.𝒦[ ranges[m], : ] for m ∈ markets ]
    Q = sum( Ωδθ[m]' * Ωδδinv[m] * K[m] for m ∈ markets )
    Δ = inv( I + sum( K[m]' * Ωδδinv[m] * K[m] for m ∈ markets ) )
    Hinvθθ =  inv( Ωθθ - sum( ΩδδinvΩδθ[m]' * Ωδθ[m] for m ∈ markets ) +  Q * Δ * Q' )
    

    cholera = cholesky( Symmetric( Ωθθ ) ) 
    C = [ ( cholera.L \ Ωδθ[m]' )' for m ∈ markets ]
    AinvB = [ Ωδδinv[m] * K[m] for m ∈ markets ]
    AinvC = [ Ωδδinv[m] * C[m] for m ∈ markets ]
    BAB = sum( K[m]' * AinvB[m] for m ∈ markets )
    BAC = sum( K[m]' * AinvC[m] for m ∈ markets )
    CAC = sum( C[m]' * AinvC[m] for m ∈ markets )
    Xstar = - inv( I + BAB + BAC * inv( I - CAC ) * BAC' )
    Ystar = - inv( I - CAC + BAC' * inv( I + BAB ) * BAC )
    Zstar = - inv( I + BAB ) * BAC * Ystar   

    δ = getδcoef( sol ) 
    β = getβcoef( sol ) 
    ξ = δ - d.plmdata.𝒳 * β 
    KVK = VarianceSum( d.plmdata.𝒦, ξ, d.plmdata.𝒦, Val( seo.type ) )
    X̂ = d.plmdata.𝒳̂
    Ξ = pinv( X̂ )
    KVΞ = VarianceSum( d.plmdata.𝒦, ξ, Ξ', Val( seo.type ) )
    ΞVΞ = VarianceSum( Ξ', ξ, Ξ', Val( seo.type ) )

    
    return GrumpsIngredients{T}(
        ranges, Ωθθ, Ωδθ, Ωδδ, Ωδδinv, ΩδδinvΩδθ, Hinvθθ,
        K, Δ, [ Ξ[ :, ranges[m] ] for m ∈ markets ],
        KVK, KVΞ, ΞVΞ,
        AinvB, AinvC, Xstar, Ystar,Zstar )
end



dimM( ii :: Ingredients ) = length( ii.ranges )

function VarianceSum( X :: AA2{T}, ξ :: AA1{T}, Y :: AA2{T}, ::Val{:homo} )  where {T<:Flt}
    @ensure size(X,1) == size( Y, 1 ) == length( ξ )  "size mismatch" 
    σξ2 = sum( ξ[i]^2 for i ∈ eachindex(ξ) ) / length( ξ )
    return σξ2 * X'Y
end

function VarianceSum( X :: AA2{T}, ξ :: AA1{T}, Y :: AA2{T}, ::Val{:hetero} )  where {T<:Flt}
    @ensure size(X,1) == size( Y, 1 ) == length( ξ )  "size mismatch" 
    return [ sum( X[r,i] * ξ[r]^2 * Y[r,j] for r ∈ eachindex( ξ ) ) for i ∈ axes(X,2), j ∈ axes(Y,2) ]
end



