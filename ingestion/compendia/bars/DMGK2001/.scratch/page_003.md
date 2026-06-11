[Page 3]

Since the parameter space in the model (1) is a disjoint union of spline spaces, sampling from the posterior benefits from the reversible jump Markov chain Monte Carlo technique introduced by Green (1995) and shown by him to be effective for estimating step functions with variable number and locations of the break points. Denison et al. (1998) generalised this approach to higher-order free-knot splines, producing a potentially powerful nonlinear regression method. However, Denison et al. (1998) avoided specifying a prior on $\beta$, preferring instead to plug in its least-squares estimator at each stage. This quasi-Bayesian solution affects how the method penalises dimensionality and often leads to severe overfitting.

We use a reversible-jump Metropolis–Hastings Markov chain Monte Carlo simulation on the $(k, \xi)$ pairs, with $\beta$ and $\sigma$ marginalised out. Since we use a fully Bayesian formulation, inferences on $\beta$ and $\sigma$ can be included with additional post hoc simulations as desired. We can use the results to estimate $f$ with a mean of the posterior sample from $f(x)$ which is a function of $\beta$. The mode can also be useful in some cases; while the mean is analytically and computationally tractable, the mode avoids averaging over disparate structures when there are many qualitatively different functions in regions of high posterior density. By using a spline basis, introducing the unit-information prior and approximating with the BIC, we are able to employ essentially the same Markov chain Monte Carlo implementation with the general model (1) as with the Normal model (2).

In § 2, we provide further details about our choice of priors and our approximation to the likelihood ratios. In § 3, we discuss further details of our posterior simulation. In § 4, we show the results of simulations for three elementary test functions. In §§ 5 and 6, we apply the method to two real datasets. The former uses the Normal model (2) to analyse functional magnetic resonance imaging data; the latter uses a Poisson model based on (1) to estimate the time-intensity function of neuronal firing in a monkey's brain. Finally, in § 7, we discuss several possible refinements and extensions of our method.

## 2. Choice of Priors

We begin by treating model (2). It is convenient, though not essential as we show below, to use a prior for which (4) may be obtained analytically. We decompose the prior as follows:

$$
\pi(\beta, k, \xi, \sigma) = \pi_\beta(\beta \mid \xi, k, \sigma)\,\pi_\xi(\xi \mid k)\,\pi_k(k)\,\pi_\sigma(\sigma), \tag{5}
$$

where $\pi_\sigma(\sigma) = 1/\sigma$ and the unit-information prior on $\beta$ is chosen so that the amount of information in the prior, represented by the covariance matrix, is equal to the amount of information in one observation, as represented by the Fisher information matrix. A prior very similar to (5) was used by Smith & Kohn (1996) in a different but related context of spline knot selection, where instead of $n$ in (5) they used a constant between 10 and 1000 which they judged to work well for the data they examined.

$$
\beta \mid k, \xi, \sigma \sim N_{k+2}\{0,\, \sigma^2 n (B_{k,\xi}^T B_{k,\xi})^{-1}\} \tag{5}
$$

The remaining priors on $\xi$ and $k$ could be chosen to express knowledge about these parameters or, equivalently, to force some desired behaviour in the posterior. In our simulations and applications below, we have adopted a prior on $\xi$ given $k$ induced by a $\mathrm{Dir}(1, 1, \ldots, 1)$ prior on the $k$-simplex by scaling $[a, b]$ to $[0, 1]$. For $k$ we also adopted a Poisson prior or Uniform prior on $\{1, \ldots, K_0\}$. In many applications, the results are unlikely to be very sensitive to the precise specification of the prior on $k$.

For linear regression models $Y = X\beta + \varepsilon$, with the more general design matrix $X$ replacing $B_{k,\xi}$, priors of the form (5) have been used by many authors (Pauler, 1998). Kass & Wasserman (1995) have called these 'unit-information' priors because the amount of infor-
