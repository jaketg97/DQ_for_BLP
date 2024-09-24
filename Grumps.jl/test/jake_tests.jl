using Pkg
using MAT
using Test
using LinearAlgebra
using Aqua
using LinearAlgebra
using Aqua
using Random
using DelimitedFiles
cd("/Users/jacobgosselin/Documents(local)/GitHub/DQ_FOR_BLP")

# load local version
Pkg.activate("/Users/jacobgosselin/Documents(local)/GitHub/DQ_FOR_BLP/Grumps.jl")

# Add MAT to the Grumps environment
Pkg.add("MAT")

using Grumps

# Define program to get data...
function getinputs(meth)
    s = Sources(                                                            
      consumers = "Grumps.jl/test/testdata/example_consumers.csv",
      products = "Grumps.jl/test/testdata/example_products.csv",
      marketsizes = "Grumps.jl/test/testdata/example_marketsizes.csv",
      draws = "Grumps.jl/test/testdata/example_draws.csv"  
    )
    v = Variables( 
        interactions =  [                                                   
            :income :constant; 
            :income :ibu; 
            :age :ibu
            ],
        randomcoefficients =  [:ibu; :abv],     
        regressors =  [ :constant; :ibu; :abv ],      
        instruments = [ :constant; :ibu; :abv; :IVgh_ibu; :IVgh_abv ], 
        microinstruments = [                                                
            :income :constant; 
            :income :ibu; 
            :age :ibu
            ],
        outsidegood = "product 11"                                          
    )
    
    e = Estimator( meth )                                                     

    d = Data( e, s, v; replicable = true ) 
    θsolcler = [1.2216062536074848, 0.36986526572323664, 0.8114008644814672, 0.8256059861239026, 0.37097308759068]
    βsolcler = [-6.966845052128352, 1.5344657270050077, 0.8757295537450648]
    δsolcler = [-3.870081314253066, -2.4566057401831873, -3.4129062232567198, -2.9829004514844044, -4.7462527791252604, -2.4149132101211124, -4.648251363630721, -2.272528515327236, -6.031793879112578, -3.110336708863073, -2.229138653209954, -3.798014225447354, -5.977005463713155, -3.880155584181251, -2.993377084476199, -6.703006828968689, -5.489626263694149, -3.5383337293050947, -4.363995208797874, -5.030815936397498, -4.116685540874672, -3.9004574054074266, -3.6008300793271104, -4.4109377633112565, -3.709078718472006, -4.953257307270224, -5.464437260337604, -3.936048469058826, -2.9763773264344247, -3.7340863760941705, -5.714872598158563, -2.0143742624945213, -1.6304179496700995, -4.077547071357243, -4.071399530996291, -6.356870850223321, -4.863890430275788, -1.732132233978317, -1.7480084179109678, -3.7704151001295956, -3.7223819977192165, -5.564969907329056, -2.510235945183445, -4.804425700858126, -4.155937969539481, -3.5603905835409986, -5.151572711061247, -5.124169020010257, -0.5397234709065728, -3.2372804492036]
       
    return θsolcler, βsolcler, δsolcler, d
end


function getsol(meth)
    s = Sources(                                                            
      consumers = "Grumps.jl/test/testdata/example_consumers.csv",
      products = "Grumps.jl/test/testdata/example_products.csv",
      marketsizes = "Grumps.jl/test/testdata/example_marketsizes.csv",
      draws = "Grumps.jl/test/testdata/example_draws.csv"  
    )
    v = Variables( 
        interactions =  [                                                   
            :income :constant; 
            :income :ibu; 
            :age :ibu
            ],
        randomcoefficients =  [:ibu; :abv],     
        regressors =  [ :constant; :ibu; :abv ],      
        instruments = [ :constant; :ibu; :abv; :IVgh_ibu; :IVgh_abv ], 
        microinstruments = [                                                
            :income :constant; 
            :income :ibu; 
            :age :ibu
            ],
        outsidegood = "product 11"                                          
    )
    
    e = Estimator( meth )                                                     

    d = Data( e, s, v; replicable = true ) 
    sol = grumps!( e, d )           
    return sol
end

test_probs = 0
test_sol = 1

if test_probs == 1 
    # Get necessary objects and calculate choice probabilities
    meth = "cler" # use the CLER method
    θsolcler, βsolcler, δsolcler, d = getinputs(meth)
    e = Estimator( meth )                                                     
    o = OptimizationOptions()
    memblock    = Grumps.MemBlock( d,  OptimizationOptions())
    s           = Grumps.Space( e, d, o, memblock )
    microspace_test = s.marketspace[1].microspace
    microdata_test = d.marketdata[1].microdata
    Grumps.FillZXθ!(θsolcler, e, microdata_test, o, microspace_test )
    Grumps.ChoiceProbabilities!(microspace_test, microdata_test, o, δsolcler[1:10])
    choice_probs = microspace_test.πi

    Grumps.__init__()
    # write the choice probabilities to a file
    writedlm("Grumps.jl/test/jake_tests_output/choice_probs_10_50.csv", choice_probs, ',')
end

if test_sol == 1
    Grumps.__init__()
    result = getsol("cler")
    print(result)
end
