[Page 14]

where the covariates $x_{1ij}$ and $x_{2ij}$ for the $j$th observation from subject $i$ are randomly generated integers between $-4$ and $4$, and $b_i$ is a $N(0,1)$ random term for subject $i$. Note that the random effect varies non-linearly with $x_1$. We want the method to be able to detect this variation.

We ran the RJMCMC algorithm for 50,000 iterations, discarding the first 10,000 as burn-in. In the first chain, the hyperparameters $a_\tau$, $b_\tau$, $a_\lambda$, $b_\lambda$, $a_\delta$ and $b_\delta$ were all set to 0.05, yielding vague priors for the variance components. When proposals were accepted, new elements of $\beta$ were initialized to 0. Sensitivity to hyperparameters and initial values was assessed through an additional chain where $a_\tau, a_\lambda, a_\delta = 1$, $b_\tau, b_\lambda, b_\delta = 0.5$, and the new elements of $\beta$ were initialized to 1. The two chains yielded virtually identical results. This suggests that the method is not overly sensitive to specification of initial values and hyperparameters.

We calculated subject-specific estimates for each data point as well as population predictions over the covariate space. Figure 2 illustrates the model's ability to discern features of the data. Figure 2a shows a scatterplot of the population mean values estimated under the algorithm against the true mean values for each covariate combination. This indicates that the model was able to distinguish the underlying population mean structure from the random effects. The empirical estimates of the random effects were calculated by subtracting the model-predicted population mean from the subject-specific posterior mean for each data point. As shown in Figure 2b, the empirical estimates of the random effects were generally accurate estimates of the true values of the random effects, $\{x_{1i}^2 b_i\}$. At each iteration, the estimated variance under the current model for each set of covariate values was calculated:

$$
V_e(y \mid x_1, x_2) = \delta_0^{-1} + \sum_{l=1}^{k-1} \delta_l^{-1}(x'\mu_l)_+^2 + \tau^{-1}
$$
