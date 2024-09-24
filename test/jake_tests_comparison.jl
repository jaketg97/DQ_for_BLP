# need readlm library
using DelimitedFiles
using Statistics
# set directory
cd("/Users/jacobgosselin/Documents(local)/GitHub/Grumps.jl/test")

# Open choice_probs_og and choice_probs_10_50 and choice_probs_10_100
choice_probs_og = readdlm("jake_tests_output/choice_probs_og.csv", ',', Float64, '\n')
choice_probs_10_50 = readdlm("jake_tests_output/choice_probs_10_50.csv", ',', Float64, '\n')
choice_probs_10_100 = readdlm("jake_tests_output/choice_probs_10_100.csv", ',', Float64, '\n')

# compare choice_probs_og to choice_probs_10_50; calculate percent difference
diff_og_10_50 = abs.(choice_probs_og - choice_probs_10_50)
percent_diff_og_10_50 = diff_og_10_50 ./ choice_probs_og
percent_diff_og_10_50[diff_og_10_50 .== 0] .= 0 # if diff is 0, set perc diff to 0

# do the same but with choice_probs_10_100
diff_og_10_100 = abs.(choice_probs_og - choice_probs_10_100)
percent_diff_og_10_100 = diff_og_10_100 ./ choice_probs_og
percent_diff_og_10_100[diff_og_10_100 .== 0] .= 0 # if diff is 0, set perc diff to 0

# Define column titles
column_titles = ["diff_og_10_50", "percent_diff_og_10_50", "diff_og_10_100", "percent_diff_og_10_100"]

# Write column titles to the CSV file
open("jake_tests_output/test_results.csv", "w") do file
    writedlm(file, column_titles, ',')
    writedlm(file, [diff_og_10_50 percent_diff_og_10_50 diff_og_10_100 percent_diff_og_10_100], ',')
end

# print mean of percent differences
println("Mean percent difference between choice_probs_og and choice_probs_10_50: ", mean(percent_diff_og_10_50))
println("Mean percent difference between choice_probs_og and choice_probs_10_100: ", mean(percent_diff_og_10_100))

# print mean of absolute differences
println("Mean absolute difference between choice_probs_og and choice_probs_10_50: ", mean(diff_og_10_50))
println("Mean absolute difference between choice_probs_og and choice_probs_10_100: ", mean(diff_og_10_100))

# println("Quantiles choice_probs_og"; quantile(choice_probs_og))
# println("Quantiles choice_probs_10_50"; quantile(choice_probs_10_50))