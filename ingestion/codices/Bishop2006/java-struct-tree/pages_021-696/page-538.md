[Page 538]

minimization of KL(p�q) with respect to µ and Σ leads to the result that µ is given by the expectation of x under p(x) and that Σ is given by the covariance.

10.5 (��) www Consider a model in which the set of all hidden stochastic variables, denoted collectively by Z, comprises some latent variables z together with some model parameters θ. Suppose we use a variational distribution that factorizes between latent variables and parameters so that q(z,θ) = qz(z)qθ(θ), in which the distribution qθ(θ) is approximated by a point estimate of the form qθ(θ) = δ(θ − θ0) where θ0 is a vector of free parameters. Show that variational optimization of this factorized distribution is equivalent to an EM algorithm, in which the E step optimizes qz(z), and the M step maximizes the expected complete-data log posterior distribution of θ with respect to θ0.

10.6 (��) The alpha family of divergences is deﬁned by (10.19). Show that the KullbackLeibler divergence KL(p�q) corresponds to α → 1. This can be done by writing p� = exp(�lnp) = 1 + �lnp + O(�2) and then taking � → 0. Similarly show that KL(q�p) corresponds to α → −1.

10.7 (��) Consider the problem of inferring the mean and precision of a univariate Gaussian using a factorized variational approximation, as considered in Section 10.1.3. Show that the factor qµ(µ) is a Gaussian of the form N(µ|µN,λ−N1) with mean and precision given by (10.26) and (10.27), respectively. Similarly show that the factor qτ(τ) is a gamma distribution of the form Gam(τ|aN,bN) with parameters given by (10.29) and (10.30).

10.8 (�) Consider the variational posterior distribution for the precision of a univariate Gaussian whose parameters are given by (10.29) and (10.30). By using the standard results for the mean and variance of the gamma distribution given by (B.27) and (B.28), show that if we let N → ∞, this variational posterior distribution has a mean given by the inverse of the maximum likelihood estimator for the variance of the data, and a variance that goes to zero.

10.9 (��) By making use of the standard result E[τ] = aN/bN for the mean of a gamma distribution, together with (10.26), (10.27), (10.29), and (10.30), derive the result (10.33) for the reciprocal of the expected precision in the factorized variational treatment of a univariate Gaussian.

10.10 (�) www Derive the decomposition given by (10.34) that is used to ﬁnd approxi-

mate posterior distributions over models using variational inference.

10.11 (��) www By using a Lagrange multiplier to enforce the normalization constraint on the distribution q(m), show that the maximum of the lower bound (10.35) is given by (10.36).

10.12 (��) Starting from the joint distribution (10.41), and applying the general result (10.9), show that the optimal variational distribution q�(Z) over the latent variables for the Bayesian mixture of Gaussians is given by (10.48) by verifying the steps given in the text.
