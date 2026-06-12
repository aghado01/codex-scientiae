[Page 621]

12.14 ($\star$) The number of independent parameters in the covariance matrix for the probabilistic PCA model with an $M$-dimensional latent space and a $D$-dimensional data space is given by (12.51). Verify that in the case of $M = D - 1$, the number of independent parameters is the same as in a general covariance Gaussian, whereas for $M = 0$ it is the same as for a Gaussian with an isotropic covariance.

12.15 ($\star\star$) Derive the M-step equations (12.56) and (12.57) for the probabilistic PCA model by maximization of the expected complete-data log likelihood function given by (12.53).

12.16 ($\star\star\star$) In Figure 12.11, we showed an application of probabilistic PCA to a data set in which some of the data values were missing at random. Derive the EM algorithm for maximizing the likelihood function for the probabilistic PCA model in this situation. Note that the $\{\mathbf{z}_n\}$, as well as the missing data values that are components of the vectors $\{\mathbf{x}_n\}$, are now latent variables. Show that in the special case in which all of the data values are observed, this reduces to the EM algorithm for probabilistic PCA derived in Section 12.2.2.

12.17 ($\star\star$) Let $\mathbf{W}$ be a $D \times M$ matrix whose columns deﬁne a linear subspace of dimensionality $M$ embedded within a data space of dimensionality $D$, and let $\boldsymbol{\mu}$ be a $D$-dimensional vector. Given a data set $\{\mathbf{x}_n\}$ where $n = 1, \dots, N$, we can approximate the data points using a linear mapping from a set of $M$-dimensional vectors $\{\mathbf{z}_n\}$, so that $\mathbf{x}_n$ is approximated by $\mathbf{W} \mathbf{z}_n + \boldsymbol{\mu}$. The associated sum-of-squares reconstruction cost is given by

$$
J = \sum_{n=1}^N \|\mathbf{x}_n - \boldsymbol{\mu} - \mathbf{W}\mathbf{z}_n\|^2. \tag{12.95}
$$

First show that minimizing $J$ with respect to $\boldsymbol{\mu}$ leads to an analogous expression with $\mathbf{x}_n$ and $\mathbf{z}_n$ replaced by zero-mean variables $\mathbf{x}_n - \bar{\mathbf{x}}$ and $\mathbf{z}_n - \bar{\mathbf{z}}$, respectively, where $\bar{\mathbf{x}}$ and $\bar{\mathbf{z}}$ denote sample means. Then show that minimizing $J$ with respect to $\mathbf{z}_n$, where $\mathbf{W}$ is kept ﬁxed, gives rise to the PCA E step (12.58), and that minimizing $J$ with respect to $\mathbf{W}$, where $\{\mathbf{z}_n\}$ is kept ﬁxed, gives rise to the PCA M step (12.59).

12.18 ($\star$) Derive an expression for the number of independent parameters in the factor analysis model described in Section 12.2.4.

12.19 ($\star\star$) Show that the factor analysis model described in Section 12.2.4 is invariant under rotations of the latent space coordinates.

12.20 ($\star\star$) By considering second derivatives, show that the only stationary point of the log likelihood function for the factor analysis model discussed in Section 12.2.4 with respect to the parameter $\boldsymbol{\mu}$ is given by the sample mean deﬁned by (12.1). Furthermore, show that this stationary point is a maximum.

12.21 ($\star\star$) Derive the formulae (12.66) and (12.67) for the E step of the EM algorithm for factor analysis. Note that from the result of Exercise 12.20, the parameter $\boldsymbol{\mu}$ can be replaced by the sample mean $\bar{\mathbf{x}}$.
