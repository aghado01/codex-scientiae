[Page 2]

Our method applies to independent data $(X_1, Y_1), \ldots, (X_n, Y_n)$ that satisfy the following model:

$$
Y_i \mid X_1, \dots, X_n \sim p\{y \mid f(X_i), \sigma\} \quad (i = 1, \dots, n), \tag{1}
$$

where $f$ is a real-valued function on $[a, b]$, and $\sigma$ is an optional and potentially vector-valued nuisance parameter. We think of the $X_i$'s here as observed explanatory variables. The goal is to estimate the unknown function $f$ from these data under the assumption that $f$ lies in some fixed, and usually infinite-dimensional, class of functions.

We focus on the special case when $p(y \mid \eta, \sigma)$ is an exponential family distribution with dispersion parameter $\sigma$. In particular, when $p(\cdot)$ is a $N(\eta, \sigma^2)$ distribution, we obtain the nonparametric regression model

$$
Y_i = f(x_i) + \varepsilon_i \quad (i = 1, \dots, n), \tag{2}
$$

where the $\varepsilon_i$ are independent draws from $N(0, \sigma^2)$ and $\sigma > 0$ is unknown.

Our method implicitly assumes that $f$ is well approximated between $a$ and $b$ by a cubic spline with some number of knots. In practice, we will assume that $f$ is such a spline. This class of cubic splines is quite large and approximates any locally smooth function arbitrarily well.

We will denote knot configurations by pairs $(k, \xi)$, where the number of knots $k$ is a nonnegative integer and the knot locations are given by the $k$-vector $\xi = (\xi_1, \ldots, \xi_k)$, for $a < x_{(1)} < \xi_1 \leqslant \cdots \leqslant \xi_k < x_{(n)} < b$. Let $b_j(x)$, for $j = 1, \ldots, k+2$, denote the $j$th function in a cubic B-spline basis with natural boundary constraints, i.e. linear outside $[a, b]$, and let $B_{k,\xi}$ be the matrix whose $i,j$ component is $b_j(x_i)$. The subscript $k, \xi$ expresses the dependence of the matrix $B_{k,\xi}$ on the number and locations of knots. Under our assumptions, we can write $f$ as a linear combination

$$
f(x) = \sum_{j=1}^{k+2} \beta_j b_j(x) \tag{3}
$$

for some vector $\beta = (\beta_1, \ldots, \beta_{k+2})$. We have the linear relation $B_{k,\xi}\beta = f(X) \equiv (f(X_1), \ldots, f(X_n))$ at the observed design points.

To complete the Bayesian formulation of the model, we must specify a prior on the unknown quantities $\beta$, $\sigma$, $k$ and $\xi$. In this paper, we use uniform or Poisson priors on $k$ and a uniform prior on $\xi$ induced by the uniform prior over the standard $k$-simplex by rescaling $\xi$ to $[a, b]$. Given $k$ and $\xi$, we use a particular conjugate Normal prior on $\beta$ that Kass & Wasserman (1995) called the unit-information prior and, independently, the improper prior $\pi_\sigma(\sigma) = 1/\sigma$. With these choices, the posterior under the Normal model (2) can be computed analytically. For example, $\beta$ and $\sigma$ can be integrated out of the posterior in order to obtain a Markov chain for sampling from the marginal posterior on $(k, \xi)$:

$$
p(y \mid k, \xi) = \int p(y \mid \beta, k, \xi, \sigma)\,\pi(\beta, \sigma \mid k, \xi)\,d\beta\,d\sigma \tag{4}
$$

In the general model (1), we rely on an approximation for ratios of marginal likelihoods (4) in terms of the Bayesian information criterion, BIC. Kass & Wasserman (1995) and
