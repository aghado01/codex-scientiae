[Page 524]

With this factorization we can appeal to the general result (10.9) to ﬁnd expressions for the optimal factors. Consider ﬁrst the distribution $q(\mathbf{w})$. Discarding terms that are independent of $\mathbf{w}$, we have

$$
\begin{aligned}
\ln q(\mathbf{w}) &= \mathbb{E}_\alpha \left[ \ln \{ h(\mathbf{w}, \boldsymbol{\xi})p(\mathbf{w}|\alpha)p(\alpha) \} \right] + \text{const} \\
&= \ln h(\mathbf{w}, \boldsymbol{\xi}) + \mathbb{E}_\alpha [\ln p(\mathbf{w}|\alpha)] + \text{const}.
\end{aligned}
$$

We now substitute for $\ln h(\mathbf{w}, \boldsymbol{\xi})$ using (10.153), and for $\ln p(\mathbf{w}|\alpha)$ using (10.165), giving

$$
\ln q(\mathbf{w}) = -\frac{\mathbb{E}[\alpha]}{2} \mathbf{w}^{\text{T}}\mathbf{w} + \sum_{n=1}^N \left\{ (t_n - 1/2)\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n - \lambda(\xi_n)\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n\boldsymbol{\phi}_n^{\text{T}}\mathbf{w} \right\} + \text{const}.
$$

We see that this is a quadratic function of $\mathbf{w}$ and so the solution for $q(\mathbf{w})$ will be Gaussian. Completing the square in the usual way, we obtain

$$
q(\mathbf{w}) = \mathcal{N}(\mathbf{w}|\boldsymbol{\mu}_N, \boldsymbol{\Sigma}_N) \tag{10.174}
$$

where we have deﬁned

$$
\boldsymbol{\mu}_N = \boldsymbol{\Sigma}_N \sum_{n=1}^N (t_n - 1/2)\boldsymbol{\phi}_n \tag{10.175}
$$

$$
\boldsymbol{\Sigma}_N^{-1} = \mathbb{E}[\alpha]\mathbf{I} + 2 \sum_{n=1}^N \lambda(\xi_n)\boldsymbol{\phi}_n\boldsymbol{\phi}_n^{\text{T}}. \tag{10.176}
$$

Similarly, the optimal solution for the factor $q(\alpha)$ is obtained from

$$
\ln q(\alpha) = \mathbb{E}_{\mathbf{w}} [\ln p(\mathbf{w}|\alpha)] + \ln p(\alpha) + \text{const}.
$$

Substituting for $\ln p(\mathbf{w}|\alpha)$ using (10.165), and for $\ln p(\alpha)$ using (10.166), we obtain

$$
\ln q(\alpha) = \frac{M}{2} \ln \alpha - \frac{\alpha}{2} \mathbb{E} [\mathbf{w}^{\text{T}}\mathbf{w}] + (a_0 - 1)\ln \alpha - b_0\alpha + \text{const}.
$$

We recognize this as the log of a gamma distribution, and so we obtain

$$
q(\alpha) = \text{Gam}(\alpha|a_N, b_N) = \frac{1}{\Gamma(a_N)} b_N^{a_N} \alpha^{a_N - 1} e^{-b_N \alpha} \tag{10.177}
$$

where

$$
a_N = a_0 + \frac{M}{2} \tag{10.178}
$$

$$
b_N = b_0 + \frac{1}{2} \mathbb{E}_{\mathbf{w}} \left[ \mathbf{w}^{\text{T}}\mathbf{w} \right]. \tag{10.179}
$$
