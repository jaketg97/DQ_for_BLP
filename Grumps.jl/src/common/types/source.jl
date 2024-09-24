

"""
    Sources{T}

abstract mother type
"""
abstract type Sources{T} end
abstract type SourceFileType end


struct SourceFileCSV <: SourceFileType
    filename    :: String
    delimiter   :: String
end





# const SourceTypes = Union{ DataFrame, Nothing, SourceFileCSV }
# abstract type SourceTypes end
const SourceTypes = Union{ DataFrame, Nothing, SourceFileType }


"""
    GrumpsSources{T1, T2, T3, T4}

Data type that contains information on filenames, dataframes, etc; see the Sources method for detailed information.
"""
struct GrumpsSources{T1,T2,T3,T4} <: Sources{T1} #  where {T1<:SourceTypes, T2<: SourceTypes, T3<:SourceTypes, T4<:SourceTypes}
    consumers   :: T1
    products    :: T2
    marketsizes :: T3
    draws       :: T4
end

"""
    Sources( ;
        consumers   :: Any = nothing, 
        products    :: Any = nothing, 
        marketsizes :: Any = nothing, 
        draws       :: Any = nothing,
    )

Creates a GrumpsSources object with source type entries where the entries are provided in the optional parameters.

Grumps (potentially) uses four data sources: a data source for consumer-level data, one for product-level data, one for market size information, and one for demographic draws.  See [Spreadsheet formats](@ref) for data layouts. Only the
product-level data are required, but are by themselves insufficient.  For instance, for BLP95 one needs information on products, market sizes, and demographics; for the Grumps CLER estimator one needs
all four types of data; for a multinomial logit both consumer and product information are needed.  Not all data are needed for all markets.  For instance, it is ok for some estimators for there to
be consumer-level data in some markets but not others.

By default, the entries can be nothing, a string, a DataFrame, or a SourceFileType.  If an entry is nothing, it means that no such data is to be used.  If an entry is a string then it is converted to a SourceFileCSV entry with comma delimiter where the string name is the file name.  To use other source file types, create a SourceFileType first.  A DataFrame can be passed, also.  In all cases other than nothing, data will eventually be (converted to) a DataFrame and parsed from that.

The *consumers* variable specifies where consumer-level data can be found, the *products* variable is for the product-level data, *marketsizes* is for market sizes, and *draws* is for demographic draws.

Use the [`Variables()`](@ref) method to specify the way the data sources are formatted and the specification to estimate.
"""
function Sources( ; 
    consumers   :: Any = nothing, 
    products    :: Any = nothing, 
    marketsizes :: Any = nothing, 
    draws       :: Any = nothing,
 )

    # a = Vector{Any}( [ consumers, products, marketsizes, draws, user ] )
    # for i ∈ eachindex( a )
    #     if isa( a[i], String )                         # assume a comma delimited CSV file if only a string is specified
    #         a[i] = SourceFileCSV( a[i], "," )
    #     end
    #     @ensure typeof(a[i])<:T2  "$(a[i]) is not of type $T2" 
    # end
    
    return Sources( consumers, products, marketsizes, draws )
    # GrumpsSources{T2}( consumers, products, marketsizes, draws, user ) 
end





function Sources( consumers, products,  marketsizes, draws )
    return GrumpsSources{typeof(consumers),typeof(products),typeof(marketsizes),typeof(draws)}( consumers, products, marketsizes, draws ) 
    # return Sources( ; consumers = consumers, products = products, marketsizes = marketsizes, draws = draws )
end


Sources( consumers :: AbstractString, products, marketsizes, draws ) = Sources( SourceFileCSV( consumers, "," ), products, marketsizes, draws )
Sources( consumers :: SourceTypes, products :: AbstractString, marketsizes, draws ) = Sources( consumers, SourceFileCSV( products, "," ), marketsizes, draws )
Sources( consumers :: SourceTypes, products :: SourceTypes, marketsizes :: AbstractString, draws ) = Sources( consumers, products, SourceFileCSV( marketsizes, "," ), draws )
Sources( consumers :: SourceTypes, products :: SourceTypes, marketsizes :: SourceTypes, draws :: AbstractString ) = Sources( consumers, products,  marketsizes, SourceFileCSV( draws, "," ) )




function show( io :: IO, s :: SourceFileCSV ) 
    print( "$(s.filename)  text file delimited by a " )
    printstyled( s.delimiter; bold = true )
    return nothing
end


function show( io :: IO, s :: Sources ) 
    for f ∈ fieldnames( typeof( s ) )
        val = getfield( s, f )
        valp = ""
        if typeof( val ) <: DataFrame
            valp = "DataFrame"
        end
        if val == nothing
            valp = "unspecified"
        end
        # if typeof( val ) <: Real
        #     valp = "$val"
        # end
        printstyled( @sprintf( "%30s: ",f ); bold = true );  println( valp )
    end
    return nothing
end


