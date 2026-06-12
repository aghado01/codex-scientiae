[Page 14]

We ran the RJMCMC algorithm for 50,000 iterations, discarding the ﬁrst 10,000 as burn-in. In the ﬁrst chain, the hyperparameters a τ, b τ, a λ, b λ, a δ and b δ were all set to 0.05, yielding vague priors for the variance components. When proposals were accepted, new elements of β were initialized to 0. Sensitivity to hyperparameters and initial values was assessed through an additional chain where a τ,a λ,a δ = 1, b τ,b λ,b δ = 0.5, and the new elements of β were initialized to 1. The two chains yielded virtually identical results. This suggests that the method is not overly sensitive to speciﬁcation of initial values and hyperparameters.

We calculated subject-speciﬁc estimates for each data point as well as population predictions over the covariate space. Figure 2 illustrates the model’s ability to discern features of the data. Figure 2a shows a scatterplot of the population mean values estimated under the algorithm against the true mean values for each covariate combination. This indicates that the model was able to distinguish the underlying population mean structure from the random eﬀects. The empirical estimates of the random eﬀects were calculated by subtracting the model-predicted population mean from the subjectspeciﬁc posterior mean for each data point. As shown in Figure 2b, the empirical estimates of the random eﬀects were generally accurate estimates of the true values of the random eﬀects, { x 2 1 b i }.At each iteration, the estimated variance under the current model for each set of covariate values was calculated:

$$
V _ { e } ( y | x _ { 1 }, x _ { 2 } ) = \delta _ { 0 } ^ { - 1 } + \sum _ { l = 1 } ^ { k - 1 } \delta _ { l } ^ { - 1 } ( x ^ { \prime } \mu _ { l } ) _ { + } ^ { 2 } + \tau ^ { - 1 }
$$

where δ and τ are the estimates of the variance components under the current k dimensional model. The empirical variance estimate can be compared to the true
