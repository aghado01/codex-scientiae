[Page 7]

This likelihood is defined conditionally on the subject-specific basis coefficients, but we wish to make inferences also on population parameters. Treating the subject-specific coefficients as random slopes, we specify a Bayesian random effects model where the subject-specific coefficients are centered around the population coefficients, $\beta$. Under model $M$ of dimension $k$, the relationship between the population and subject-specific coefficients is specified through the hierarchical structure:

$$
b_i \mid k \sim N_k(\beta,\, \tau^{-1}\Delta^{-1}), \quad \forall\, i
$$

$$
\beta \mid k \sim N_k(0,\, \tau^{-1}\lambda^{-1}I_k)
$$

To avoid over-parameterization of an already flexible model, we assume independence among the elements of $b_i$. Thus $\Delta = \mathrm{diag}(\delta)$, where $\delta$ is a $k \times 1$ vector. The elements of $\delta$ and the scalars $\lambda$ and $\tau$ are given independent gamma priors:

$$
\pi(\tau, \lambda, \delta) \propto \tau^{a_\tau - 1} e^{-b_\tau \tau}\cdot\lambda^{a_\lambda - 1} e^{-b_\lambda \lambda}\cdot\prod_{l=1}^{k} \delta_l^{a_\delta - 1} e^{-b_\delta \delta_l},
$$

where $a_\tau$, $b_\tau$, $a_\lambda$, $b_\lambda$, $a_\delta$ and $b_\delta$ are pre-specified hyperparameters. Each of the $k - 1$ non-intercept basis functions contains a non-zero intercept and linear effect for at least one covariate. Including multiple covariate effects in a single basis allows the covariates to dependently affect the response (i.e. allows for interactions). The number of non-zero covariate effects in a particular basis is called the interaction level of the basis.

Under one piecewise linear model, an observation $y$ with covariates $x$ has the following mean and variance:

$$
E(y) = \beta_1 + \sum_{l=2}^{k} \beta_l(x'\mu_l)_+
$$

$$
V(y) = \delta_1^{-1} + \sum_{l=2}^{k} \delta_l^{-1}(x'\mu_l)_+^2 + \tau^{-1}
$$
