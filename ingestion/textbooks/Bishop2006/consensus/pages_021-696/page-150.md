[Page 150]

- 2.11 ( ) www By expressing the expectation of $\ln \mu_j$ under the Dirichlet distribution (2.38) as a derivative with respect to $\alpha_j$, show that

$$
\mathbb{E}[\ln \mu_j] = \psi(\alpha_j) - \psi(\alpha_0) \tag{2.276}
$$

where $\alpha_0$ is given by (2.39) and

$$
\psi(a) \equiv \frac{d}{da} \ln \Gamma(a) \tag{2.277}
$$

is the digamma function.

- 2.12 ( ) The uniform distribution for a continuous variable $x$ is deﬁned by

$$
U(x|a,b) = \frac{1}{b - a}, \quad a \le x \le b. \tag{2.278}
$$

Verify that this distribution is normalized, and ﬁnd expressions for its mean and variance.

- 2.13 ( ) Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians $p(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ and $q(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\mathbf{m},\mathbf{L})$.

- 2.14 ( ) www This exercise demonstrates that the multivariate distribution with maximum entropy, for a given covariance, is a Gaussian. The entropy of a distribution $p(\mathbf{x})$ is given by

$$
H[\mathbf{x}] = - \int p(\mathbf{x})\ln p(\mathbf{x}) \, d\mathbf{x}. \tag{2.279}
$$

We wish to maximize $H[\mathbf{x}]$ over all distributions $p(\mathbf{x})$ subject to the constraints that $p(\mathbf{x})$ be normalized and that it have a speciﬁc mean and covariance, so that

$$
\int p(\mathbf{x}) \, d\mathbf{x} = 1 \tag{2.280}
$$

$$
\int p(\mathbf{x})\mathbf{x} \, d\mathbf{x} = \boldsymbol{\mu} \tag{2.281}
$$

$$
\int p(\mathbf{x})(\mathbf{x} - \boldsymbol{\mu})(\mathbf{x} - \boldsymbol{\mu})^{\text{T}} \, d\mathbf{x} = \boldsymbol{\Sigma}. \tag{2.282}
$$

By performing a variational maximization of (2.279) and using Lagrange multipliers to enforce the constraints (2.280), (2.281), and (2.282), show that the maximum likelihood distribution is given by the Gaussian (2.43).

- 2.15 ( ) Show that the entropy of the multivariate Gaussian $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ is given by

$$
H[\mathbf{x}] = \frac{1}{2} \ln |\boldsymbol{\Sigma}| + \frac{D}{2} (1 + \ln(2\pi)) \tag{2.283}
$$

where $D$ is the dimensionality of $\mathbf{x}$.
