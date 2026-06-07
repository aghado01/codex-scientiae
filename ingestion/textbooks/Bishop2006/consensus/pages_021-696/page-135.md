[Page 135]

Making use of the constraint (2.209), the multinomial distribution in this representation then becomes

$$
\begin{aligned}
\exp \left\{ \sum_{k=1}^{M} x_k \ln \mu_k \right\} &= \exp \left\{ \sum_{k=1}^{M-1} x_k \ln \mu_k + \left( 1 - \sum_{k=1}^{M-1} x_k \right) \ln \left( 1 - \sum_{k=1}^{M-1} \mu_k \right) \right\} \\
&= \exp \left\{ \sum_{k=1}^{M-1} x_k \ln \left( \frac{\mu_k}{1 - \sum_{j=1}^{M-1} \mu_j} \right) + \ln \left( 1 - \sum_{k=1}^{M-1} \mu_k \right) \right\}.
\end{aligned} \tag{2.211}
$$

We now identify

$$
\ln \left( \frac{\mu_k}{1 - \sum_{j} \mu_j} \right) = \eta_k \tag{2.212}
$$

which we can solve for $\mu_k$ by first summing both sides over $k$ and then rearranging and back-substituting to give

$$
\mu_k = \frac{\exp(\eta_k)}{1 + \sum_j \exp(\eta_j)}. \tag{2.213}
$$

This is called the *softmax* function, or the *normalized exponential*. In this representation, the multinomial distribution therefore takes the form

$$
p(\mathbf{x}|\boldsymbol{\eta}) = \left( 1 + \sum_{k=1}^{M-1} \exp(\eta_k) \right)^{-1} \exp(\boldsymbol{\eta}^{\text{T}} \mathbf{x}). \tag{2.214}
$$

This is the standard form of the exponential family, with parameter vector $\boldsymbol{\eta} = (\eta_1, \ldots, \eta_{M-1})^{\text{T}}$ in which

$$
\mathbf{u}(\mathbf{x}) = \mathbf{x} \tag{2.215}
$$

$$
h(\mathbf{x}) = 1 \tag{2.216}
$$

$$
g(\boldsymbol{\eta}) = \left( 1 + \sum_{k=1}^{M-1} \exp(\eta_k) \right)^{-1}. \tag{2.217}
$$

Finally, let us consider the Gaussian distribution. For the univariate Gaussian, we have

$$
\begin{aligned}
p(x|\mu, \sigma^2) &= \frac{1}{(2\pi\sigma^2)^{1/2}} \exp \left\{ -\frac{1}{2\sigma^2} (x - \mu)^2 \right\} \quad \quad \quad \quad \quad (2.218) \\
&= \frac{1}{(2\pi\sigma^2)^{1/2}} \exp \left\{ -\frac{1}{2\sigma^2} x^2 + \frac{\mu}{\sigma^2} x - \frac{1}{2\sigma^2} \mu^2 \right\} \\
\end{aligned}
$$
