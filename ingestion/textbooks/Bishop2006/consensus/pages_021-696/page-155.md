[Page 155]

variable drawn from the distribution (2.293). Show that the log likelihood function over $\mathbf{w}$ and $\sigma^2$, for an observed data set of input vectors $\mathbf{X} = \{\mathbf{x}_1,\ldots,\mathbf{x}_N\}$ and corresponding target variables $\mathbf{t} = (t_1,\ldots,t_N)^{\mathrm{T}}$, is given by

$$
\ln p(\mathbf{t}|\mathbf{X},\mathbf{w},\sigma^2) = -\frac{1}{2\sigma^2} \sum_{n=1}^N |y(\mathbf{x}_n,\mathbf{w}) - t_n|^q - \frac{N}{q} \ln(2\sigma^2) + \text{const} \tag{2.295}
$$

where 'const' denotes terms independent of both $\mathbf{w}$ and $\sigma^2$. Note that, as a function of $\mathbf{w}$, this is the $L_q$ error function considered in Section 1.5.5.

2.44 ($\star$) Consider a univariate Gaussian distribution $\mathcal{N}(x|\mu,\tau^{-1})$ having conjugate Gaussian-gamma prior given by (2.154), and a data set $\mathbf{x} = \{x_1,\ldots,x_N\}$ of i.i.d. observations. Show that the posterior distribution is also a Gaussian-gamma distribution of the same functional form as the prior, and write down expressions for the parameters of this posterior distribution.

2.45 ($\star$) Verify that the Wishart distribution defined by (2.155) is indeed a conjugate prior for the precision matrix of a multivariate Gaussian.

2.46 ($\star$) www Verify that evaluating the integral in (2.158) leads to the result (2.159).

2.47 ($\star$) www Show that in the limit $\nu \to \infty$, the t-distribution (2.159) becomes a Gaussian. Hint: ignore the normalization coefficient, and simply look at the dependence on $x$.

2.48 ($\star$) By following analogous steps to those used to derive the univariate Student's t-distribution (2.159), verify the result (2.162) for the multivariate form of the Student's t-distribution, by marginalizing over the variable $\eta$ in (2.161). Using the definition (2.161), show by exchanging integration variables that the multivariate t-distribution is correctly normalized.

2.49 ($\star$) By using the definition (2.161) of the multivariate Student's t-distribution as a convolution of a Gaussian with a gamma distribution, verify the properties (2.164), (2.165), and (2.166) for the multivariate t-distribution defined by (2.162).

2.50 ($\star$) Show that in the limit $\nu \to \infty$, the multivariate Student's t-distribution (2.162) reduces to a Gaussian with mean $\boldsymbol{\mu}$ and precision $\boldsymbol{\Lambda}$.

2.51 ($\star$) www The various trigonometric identities used in the discussion of periodic variables in this chapter can be proven easily from the relation

$$
\exp(iA) = \cos A + i\sin A \tag{2.296}
$$

in which $i$ is the square root of minus one. By considering the identity

$$
\exp(iA)\exp(-iA) = 1 \tag{2.297}
$$

prove the result (2.177). Similarly, using the identity

$$
\cos(A - B) = \Re \exp\{i(A - B)\} \tag{2.298}
$$
