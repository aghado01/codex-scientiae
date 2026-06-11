[Page 5]

A popular method for analyzing multivariate response data with spline bases is seemingly unrelated regression (SUR), in which each subject is allowed a unique set of basis functions, but the basis coefficients are common to all subjects (Percy, 1992). We instead use one set of unknown basis functions, allowing the basis coefficients to vary from subject to subject. To estimate the population regression function, we treat the subject-specific basis coefficients as random, centered around the population mean basis coefficients. The resulting model is extremely flexible, and can be used to capture a wide variety of covariate effects and heterogeneity structures.

In section 2, we describe the model, prior structure and a reversible jump Markov chain Monte Carlo (RJMCMC) (Green, 1995) algorithm for posterior computation. In section 3, we illustrate the performance of the approach for a simulation example. Section 4 applies the method to progesterone data from the NC-EPS, and section 5 discusses the results.

## 2. Methods

### 2.1 Prior Specification

Typically, the number and locations of knots in a piecewise linear spline are unknown. By allowing for uncertainty in the knot locations and averaging across the resulting posterior, one can obtain smoothed regression functions. We follow previous authors (Green, 1995; Holmes and Mallick, 2001) in using the RJMCMC algorithm to move among candidate models of varying dimension. Our final predictions are constructed from averages over all sampled models. We assume a priori that all models are equally probable, so our prior on the model space is uniform.

Each piecewise linear model, $M$, is defined by its basis functions $(\mu_1, \ldots, \mu_k)$, where $\mu_l$ is $p \times 1$. Consider $y_{ij}$, the $j$th PdG measurement for subject $i$. Under model $M$, the true relationship between $y_{ij}$ and its covariates $x_{ij}' = (1, x_{ij2}, \ldots, x_{ijp})$ can be approximated as follows.
