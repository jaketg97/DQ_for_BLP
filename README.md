Files in this repository are...
1) Grumps.jl: A amended version of the Grumps package, which uses designed quadrature for integration. See Grumps.jl/test/jake_tests/jake_tests.jl for tests comparing DQ integration to original estimates. Integration itself is visible under Grumps.jl/src/integrators/designedquadrature/designedquadrature.jl
	- Note that the integration uses hardcoded file paths, so to compile, you'll need to change those. They are all visible under Grumps.jl/src/integrators/designedquadrature/designedquadrature.jl
2) DQ_Simulations: the replication code for @bansalDesignedQuadratureApproximate2022, which includes simulations testing designed quadrature against other integration methods. Results are under DQ_Simulations/3. Simulation Table and Figure/X_X_output.mat. 


Original task was to extend Grumps package to be able to handle either...
1) High number of random coefficients (to allow for brand-specific taste shocks)
2) Nested logit (direct way of getting at above)

I'll include my notes below fleshing out each approach in the Grumps context, but my understanding is we've mostly moved away from that. I ended up extending Grumps to include Designed Quadrature(DQ) as a custom integrator, so I've included that package here in case we return to Grumps (see Grumps folder). My main contribution seems likely to be DQ generally, as a way to integrate with less nodes (and therefore speed up computation). The reference here is @bansalDesignedQuadratureApproximate2022; below I'll summarize the methodology, and it's application to random coefficient logit.

# Designed quadrature; theory

 As a reminder, the challenge is to approximate the following A) well and B) efficiently...
$$
\pi_{jm}^{z_{im}} = \int \frac{\exp(\delta_{jm} + \mu_{ijm}^z + \mu_{ijm}^\nu)}{\sum^{J_m}_{l = 0} \exp(\delta_{lm} + \mu^z_{ilm} + \mu^\nu_{ilm})} dF_m(\nu)
$$
This is multi-dimensional integral, and if we're adding brand specific taste-shocks that's going to be a lot of dimensions. Rewrite it as 
$$
\int_\Gamma f(\mathbf{x}) \omega(\mathbf{x})d\mathbf{x}
$$
Where $f$ is our probability conditional on taste-shocks $\mathbf{x}$, $\omega$ is the PDF of our taste-shocks (which are multi-variate normal). We approximate this as 
$$
\int_\Gamma f(\mathbf{x}) \omega(\mathbf{x})d\mathbf{x} \approx \sum^n_q f(\mathbf{x}_q)w_q
$$
i.e. the sum of nodes and weights. The question is how to construct this sum.

First consider multivariate quadrature. As a reminder, in quadrature we solve for points and weights that enforce equality of the integral and the sum for a polynomial space (i.e. polynomials of degree 4 or lower). Gaussian quadrature rules from the univariate case can be generalized for the following theorem...
$$
\sum \pi_{\alpha}(x_q)w_q = \begin{cases} 1/\pi_0, \space \alpha = 0 \\ 0, \space \alpha \in \Lambda / 0 \end{cases} \rightarrow \int_\Lambda \omega(x) \pi(x) dx = \sum \pi(x_q)\omega_q
$$
I.e. we have a system of equations that defines the quadrature points and weights for which the sum of the polynomials evaluated at those points with appropriate weights is equal to the integral. Note that there's no guarantee of a of a positive weight here, nor is there a guarantee of nodes belonging to the support. Looking at their code, and with this in mind, I actually think @griecoConformantEfficientEstimation2023 are doing univariate quadrature (hermite quadrature in a single dimension) repeatedly (maybe this doesn't matter though?)

Regardless, this is a reason @bansalDesignedQuadratureApproximate2022 recommend Designed Quadrature rather than standard Sparse Quadrature: "We did not consider SGQ in this study, because (a) in our initial test runs, negative weights in SGQ led to complex (imaginary) loglikelihood values in the estimation of MMNL with full variance–covariance matrix; and (b) based on extensive simulations studies, Keshavarzzadeh et al. (2018) confirmed that DQ requires many fewer nodes than SGQ. Heiss and Winschel (2008) can be referred for intuitive and theoretical discussion on SGQ rules."

To understand DQ, consider...
- $\Lambda$ index set (polynomial subspace?), $M=|\Lambda|$, $X \in R^{d \times n}$ with columns $x_j$ and $w \in R^n$ vector of n weights. $V(X) \in R^{M \times n}$ is a Vandermonde-like matrix  with entries 
	$$
	V_{k,j} = \pi_{\alpha(k)}(x_j), k=1..M, j=1,...n
	$$
- Now we can rewrite multivariate quadrature as 
	$$
	V(x)w = e_1/\pi_0
	$$
- We solve this approximately, up to $\epsilon$. So basically we compute nodes and weights according to constrained optimization problem 
$$
\begin{aligned}
\min ||V(X)w - \epsilon_1/\pi_0||_2 \\
st \space x_j \in \Gamma \\
w_j>0 
\end{aligned}
$$
- Where now our nodes are on the relevant supports, and weights are non-zero.

# Designed quadrature; application 

@bansalDesignedQuadratureApproximate2022 apply DQ to mixed-multinomial-logit (MMNL), i.e. recovering the parameters $\alpha$ and $\beta_i$ from a decision maker who maximizes...

$$
u(c_{ijt}) = \alpha^T X_{ijt} + \beta_i^T z_{ijt} + \epsilon_{ijt} 
$$
Mapping this to standard random coefficient logit, we have person $i$, product $j$, market $t$. $\alpha^T$ represents all coefficients, including the "micro" ones (i.e. those on product characteristics interacted with individual demographics). $\beta_i^T$ represents all random coefficients. 

@bansalDesignedQuadratureApproximate2022 simulate data where the random coefficients are fully independent (diagonal vCov matrix) and full covariance. Our situation is likely somewhere in-between (some random coefficients are co-varied with others). They vary the number of parameters (and in turn, the dimension of integration) and compare DQ to quasi-Monte Carlo methods. Note that comparing DQ to single-dimension quadrature, which is used for micro-integration in Grumps, is simple: @griecoConformantEfficientEstimation2023 find that 11 nodes per dimension is needed for good estimation (that's what they default their command to), so for 5 dimensions they require $11^5$ nodes, and so on. 

Their main results are visible in Tables 1-3 and Figure 1 of the paper. The headline results for our purposes are listed below. Note that I rank computation time in terms of number of nodes; since the quadrature rules can be pre-compiled, this is the relevant metric for the repeated computations that need to be done in demand estimation. 

1) For independent random parameters, DQ clearly outperforms qMC methods with less computation. Ratio of nodes needed for same level of loglikelihood varies from 1:10 (100:1000 in Table 2) to 1:3 (100:300 in Table 3). 
2) For full covariance, DQ still outperforms, but less so. Ratio of nodes needed for same level of loglikelihood varies from 2:3 (200:300 in Table 2) to 1:1 (Table 3).

Overall, this is promising, but not overwhelmingly so, especially when allowing random coefficients to have full covariance. I've included their replication code in this folder, under DQ_Rep. I worked on my own simulations, but there's are far more rigorous than mine. 

# Review of original problem (old)

- Task: extend Conformant Likelihood with Exogeneity Restrictions (CLER) estimator of @griecoConformantEfficientEstimation2023 to nested logit setting of @bhattacharyaMergerEffectsAntitrust2023 
- Setting: Consider market 20, Ground and Whole Bean Coffee. We want to model demand with a nested-logit that incorporates brands, e.g. Starbucks is a group, products Starbucks Dark Roast and Starbucks Light Roast fall under that group. 
- 2 approaches to this 
	 1) Adding random coefficients for each brand; would require fast computation of high dimensional integral (so DQ, as described above)
	 2) Direct nested logit in Grumps

## Direct Nested Logit in Grumps (old)

- Review...
	- Objective is (after concentrating out $\beta$, as is standard)
	$$
	(\hat{\theta}, \hat{\delta}) = \arg\min_{\theta, \delta} = \left(- \log \hat{L}(\theta, \delta) + \hat{\Pi}(\hat{\beta}(\delta), \delta)\right)
	$$
	- 2 arguments are... 
	$$
	\begin{aligned}
	\delta = \{\delta_{jm}\}_{JM} \\
	\theta = \{\theta^Z, \theta^\nu\}
	\end{aligned}
	$$
	- Note that $\delta$ is the high-dimension object: computing meaning utility for each product in each market (which varies at the product-market level due to $\xi_{jm}$). $\theta$ parametrizes deviations due to observed demographics and random taste shocks, and is the same across products and across markets.
	- Separate problem into inner-loop, where we optimize $\delta(\theta)$, and the outer-loop, where we optimize $\theta$. Similar to NFP algorithm, **but here we optimize the same overall objective fnct in both inner and outer loops**. So inner and outer loop are just $\arg \min_{\delta(\theta)}, \arg \min_{\theta}$  
- Pseudo-code...
	1. Inner-loop: Fix $\tilde{\theta} = \{\theta, \sigma\}$, i.e. same as before but with nest parameter
		1. Need to alter `common/optim/macllf.jl:MacroObjectiveδ!` and `common/optim/micllf.jl:MicroObjectiveδ!` to calculate objective as a function of $\tilde{\theta}$, rather than $\theta$ (include $\sigma$). I believe this just means altering `src/common/probs/choiceprobs.jl` such that the probability reflects the nest and nest parameter (a little hard to see how all this is passed in Julia, but conceptually makes sense) 
		2. Also need to alter both to ensure the gradient and hessian are correct given different choice; like Vivek said, I think this just involves above, since that will alter inputs to `common/optim/macllf.jl:MacHessianδ!` and `common/optim/micllf.jl:updateHessian!`, the two fncts that compute that micro and macro portions of the Hessian wrt $\delta$. 
		3. **Key point**: I agree with Vivek that the structure of the Hessian wrt $\delta$ should be the same. This is helpful since all the build-around functions referencing that Hessian, and the manner in which it's inversion is made feasible for the main CLER estimator, shouldn't need to be touched. (also: we can just do the Cheap version?)
	2. Outer-loop: solving for $\theta$ with $\delta(\theta)$ calculated from inner-loop
		1. Objective should be taken care of by altering as in (1) of inner-loop. That is, by updating choice probabilities, the objective function should reflect the correct value given $\theta, \delta(\theta)$ which now includes nest parameter $\sigma$ (again, benefit of having the same objective fnct in the inner and outer loop)
		2. Hessian needs to be altered, i.e. `common/optim/micllf.jl:GradientHessianMicroθ!` and `common/optim/macllf.jl:UpdateGradientHessian!`. Chain rule should be same as before, to Vivek's point this isn't market by market (since $\theta$ isn't market level), and we're not relying on block structure to invert Hessian for Newton's method, so ideally this is just getting analytic formula right and replacing. 

