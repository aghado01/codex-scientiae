[Page 154]

distribution, by starting with the maximum likelihood expression
$$
\sigma_{\text{ML}}^2 = \frac{1}{N} \sum_{n=1}^N (x_n - \mu)^2. \tag{2.292}
$$
Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients $a_N$.

- 2.37 ( ) Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the covariance of a multivariate Gaussian distribution, by starting with the maximum likelihood expression (2.122). Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients $a_N$.

- 2.38 ( ) Use the technique of completing the square for the quadratic form in the exponent to derive the results (2.141) and (2.142).

- 2.39 ( ) Starting from the results (2.141) and (2.142) for the posterior distribution of the mean of a Gaussian random variable, dissect out the contributions from the ﬁrst $N - 1$ data points and hence obtain expressions for the sequential update of $\mu_N$ and $\sigma_N^2$. Now derive the same results starting from the posterior distribution $p(\mu|x_1,\ldots,x_{N-1}) = \mathcal{N}(\mu|\mu_{N-1},\sigma_{N-1}^2)$ and multiplying by the likelihood function $p(x_N|\mu) = \mathcal{N}(x_N|\mu,\sigma^2)$ and then completing the square and normalizing to obtain the posterior distribution after $N$ observations.

- 2.40 ( ) www Consider a $D$-dimensional Gaussian random variable $\mathbf{x}$ with distribution $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ in which the covariance $\boldsymbol{\Sigma}$ is known and for which we wish to infer the mean $\boldsymbol{\mu}$ from a set of observations $\mathbf{X} = \{\mathbf{x}_1,\ldots,\mathbf{x}_N\}$. Given a prior distribution $p(\boldsymbol{\mu}) = \mathcal{N}(\boldsymbol{\mu}|\boldsymbol{\mu}_0,\boldsymbol{\Sigma}_0)$, ﬁnd the corresponding posterior distribution $p(\boldsymbol{\mu}|\mathbf{X})$.

- 2.41 ( ) Use the deﬁnition of the gamma function (1.141) to show that the gamma distribution (2.146) is normalized.

- 2.42 ( ) Evaluate the mean, variance, and mode of the gamma distribution (2.146).

- 2.43 ( ) The following distribution
$$
p(x|\sigma^2, q) = \frac{q}{2(2\sigma^2)^{1/q}\Gamma(1/q)} \exp \left( - \frac{|x|^q}{2\sigma^2} \right) \tag{2.293}
$$
is a generalization of the univariate Gaussian distribution. Show that this distribution is normalized so that
$$
\int_{-\infty}^{\infty} p(x|\sigma^2, q) \, dx = 1 \tag{2.294}
$$
and that it reduces to the Gaussian when $q = 2$. Consider a regression model in which the target variable is given by $t = y(\mathbf{x},\mathbf{w}) + \epsilon$ and $\epsilon$ is a random noise
