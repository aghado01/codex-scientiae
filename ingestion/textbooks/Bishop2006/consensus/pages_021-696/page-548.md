[Page 548]

$$
y_1 = z_1 \left( \frac{-2 \ln z_1}{r^2} \right)^{1/2} \tag{11.10}
$$

$$
y_2 = z_2 \left( \frac{-2 \ln z_2}{r^2} \right)^{1/2} \tag{11.11}
$$

where $r^2 = z_1^2 + z_2^2$. Then the joint distribution of $y_1$ and $y_2$ is given by

$$
p(y_1, y_2) = p(z_1, z_2) \left| \frac{\partial(z_1, z_2)}{\partial(y_1, y_2)} \right| = \left[ \frac{1}{\sqrt{2\pi}} \exp(-y_1^2/2) \right] \left[ \frac{1}{\sqrt{2\pi}} \exp(-y_2^2/2) \right] \tag{11.12}
$$

and so $y_1$ and $y_2$ are independent and each has a Gaussian distribution with zero mean and unit variance.

If $y$ has a Gaussian distribution with zero mean and unit variance, then $\sigma y + \mu$ will have a Gaussian distribution with mean $\mu$ and variance $\sigma^2$. To generate vector-valued variables having a multivariate Gaussian distribution with mean $\boldsymbol{\mu}$ and covariance $\boldsymbol{\Sigma}$, we can make use of the Cholesky decomposition, which takes the form $\boldsymbol{\Sigma} = \mathbf{L}\mathbf{L}^{\text{T}}$ (Press et al., 1992). Then, if $\mathbf{z}$ is a vector valued random variable whose components are independent and Gaussian distributed with zero mean and unit variance, then $\mathbf{y} = \boldsymbol{\mu} + \mathbf{L}\mathbf{z}$ will have mean $\boldsymbol{\mu}$ and covariance $\boldsymbol{\Sigma}$.

Obviously, the transformation technique depends for its success on the ability to calculate and then invert the indeﬁnite integral of the required distribution. Such operations will only be feasible for a limited number of simple distributions, and so we must turn to alternative approaches in search of a more general strategy. Here we consider two techniques called rejection sampling and importance sampling. Although mainly limited to univariate distributions and thus not directly applicable to complex problems in many dimensions, they do form important components in more general strategies.

### 11.1.2 Rejection sampling

The rejection sampling framework allows us to sample from relatively complex distributions, subject to certain constraints. We begin by considering univariate distributions and discuss the extension to multiple dimensions subsequently.

Suppose we wish to sample from a distribution $p(z)$ that is not one of the simple, standard distributions considered so far, and that sampling directly from $p(z)$ is difﬁcult. Furthermore suppose, as is often the case, that we are easily able to evaluate $p(z)$ for any given value of $z$, up to some normalizing constant $Z_p$, so that

$$
p(z) = \frac{1}{Z_p} \widetilde{p}(z) \tag{11.13}
$$

where $\widetilde{p}(z)$ can readily be evaluated, but $Z_p$ is unknown.

In order to apply rejection sampling, we need some simpler distribution $q(z)$, sometimes called a proposal distribution, from which we can readily draw samples.
