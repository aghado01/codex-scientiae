[Page 521]

we then use these parameter values to ﬁnd the posterior distribution over $\mathbf{w}$, which is given by (10.156). In the M step, we then maximize the expected complete-data log likelihood which is given by

$$
Q(\boldsymbol{\xi}, \boldsymbol{\xi}^{\text{old}}) = \mathbb{E} \left[ \ln h(\mathbf{w}, \boldsymbol{\xi})p(\mathbf{w}) \right] \tag{10.160}
$$

where the expectation is taken with respect to the posterior distribution $q(\mathbf{w})$ evaluated using $\boldsymbol{\xi}^{\text{old}}$. Noting that $p(\mathbf{w})$ does not depend on $\boldsymbol{\xi}$, and substituting for $h(\mathbf{w}, \boldsymbol{\xi})$ we obtain

$$
Q(\boldsymbol{\xi}, \boldsymbol{\xi}^{\text{old}}) = \sum_{n=1}^N \left\{ \ln \sigma(\xi_n) - \xi_n/2 - \lambda(\xi_n)(\boldsymbol{\phi}_n^{\text{T}}\mathbb{E}[\mathbf{w}\mathbf{w}^{\text{T}}]\boldsymbol{\phi}_n - \xi_n^2) \right\} + \text{const} \tag{10.161}
$$

where ‘const’ denotes terms that are independent of $\boldsymbol{\xi}$. We now set the derivative with respect to $\xi_n$ equal to zero. A few lines of algebra, making use of the deﬁnitions of $\sigma(\xi)$ and $\lambda(\xi)$, then gives

$$
0 = \lambda'(\xi_n)(\boldsymbol{\phi}_n^{\text{T}}\mathbb{E}[\mathbf{w}\mathbf{w}^{\text{T}}]\boldsymbol{\phi}_n - \xi_n^2). \tag{10.162}
$$

We now note that $\lambda'(\xi)$ is a monotonic function of $\xi$ for $\xi \geqslant 0$, and that we can restrict attention to nonnegative values of $\xi$ without loss of generality due to the symmetry of the bound around $\xi = 0$. Thus $\lambda'(\xi) \neq 0$, and hence we obtain the following re-estimation equations

$$
(\xi_n^{\text{new}})^2 = \boldsymbol{\phi}_n^{\text{T}}\mathbb{E}[\mathbf{w}\mathbf{w}^{\text{T}}]\boldsymbol{\phi}_n = \boldsymbol{\phi}_n^{\text{T}} \left( \mathbf{S}_N + \mathbf{m}_N\mathbf{m}_N^{\text{T}} \right) \boldsymbol{\phi}_n \tag{10.163}
$$

where we have used (10.156).

Let us summarize the EM algorithm for ﬁnding the variational posterior distribution. We ﬁrst initialize the variational parameters $\boldsymbol{\xi}^{\text{old}}$. In the E step, we evaluate the posterior distribution over $\mathbf{w}$ given by (10.156), in which the mean and covariance are deﬁned by (10.157) and (10.158). In the M step, we then use this variational posterior to compute a new value for $\boldsymbol{\xi}$ given by (10.163). The E and M steps are repeated until a suitable convergence criterion is satisﬁed, which in practice typically requires only a few iterations.

An alternative approach to obtaining re-estimation equations for $\boldsymbol{\xi}$ is to note that in the integral over $\mathbf{w}$ in the deﬁnition (10.159) of the lower bound $\mathcal{L}(\boldsymbol{\xi})$, the integrand has a Gaussian-like form and so the integral can be evaluated analytically. Having evaluated the integral, we can then differentiate with respect to $\xi_n$. It turns out that this gives rise to exactly the same re-estimation equations as does the EM approach given by (10.163).

As we have emphasized already, in the application of variational methods it is useful to be able to evaluate the lower bound $\mathcal{L}(\boldsymbol{\xi})$ given by (10.159). The integration over $\mathbf{w}$ can be performed analytically by noting that $p(\mathbf{w})$ is Gaussian and $h(\mathbf{w}, \boldsymbol{\xi})$ is the exponential of a quadratic function of $\mathbf{w}$. Thus, by completing the square and making use of the standard result for the normalization coefﬁcient of a Gaussian distribution, we can obtain a closed form solution which takes the form
