[Page 121]

From (2.150), we see that the effect of observing $N$ data points is to increase the value of the coefﬁcient $a$ by $N/2$. Thus we can interpret the parameter $a_0$ in the prior in terms of $2a_0$ ‘effective’ prior observations. Similarly, from (2.151) we see that the $N$ data points contribute $N\sigma_{ML}^2 / 2$ to the parameter $b$, where $\sigma_{ML}^2$ is the variance, and so we can interpret the parameter $b_0$ in the prior as arising from the $2a_0$ ‘effective’ prior observations having variance $2b_0/(2a_0) = b_0/a_0$. Recall that we made an analogous interpretation for the Dirichlet prior. These distributions are examples of the exponential family, and we shall see that the interpretation of a conjugate prior in terms of effective ﬁctitious data points is a general one for the exponential family of distributions.

Instead of working with the precision, we can consider the variance itself. The conjugate prior in this case is called the inverse gamma distribution, although we shall not discuss this further because we will ﬁnd it more convenient to work with the precision.

Now suppose that both the mean and the precision are unknown. To ﬁnd a conjugate prior, we consider the dependence of the likelihood function on $\mu$ and $\lambda$

$$
\begin{aligned}
p(X \mid \mu, \lambda) &= \prod_{n=1}^{N} \left( \frac{\lambda}{2\pi} \right)^{1/2} \exp \left\{ -\frac{\lambda}{2} (x_n - \mu)^2 \right\} \\
&\propto \left[ \lambda^{1/2} \exp \left( -\frac{\lambda \mu^2}{2} \right) \right]^N \exp \left\{ \lambda \mu \sum_{n=1}^{N} x_n - \frac{\lambda}{2} \sum_{n=1}^{N} x_n^2 \right\}. \tag{2.152}
\end{aligned}
$$

We now wish to identify a prior distribution $p(\mu, \lambda)$ that has the same functional dependence on $\mu$ and $\lambda$ as the likelihood function and that should therefore take the form

$$
\begin{aligned}
p(\mu, \lambda) &\propto \left[ \lambda^{1/2} \exp \left( -\frac{\lambda \mu^2}{2} \right) \right]^\beta \exp \{ c\lambda \mu - d\lambda \} \\
&= \exp \left\{ -\frac{\beta \lambda}{2} (\mu - c/\beta)^2 \right\} \lambda^{\beta/2} \exp \left\{ -\left( d - \frac{c^2}{2\beta} \right) \lambda \right\} \tag{2.153}
\end{aligned}
$$

where $c$, $d$, and $\beta$ are constants. Since we can always write $p(\mu, \lambda) = p(\mu \mid \lambda)p(\lambda)$, we can ﬁnd $p(\mu \mid \lambda)$ and $p(\lambda)$ by inspection. In particular, we see that $p(\mu \mid \lambda)$ is a Gaussian whose precision is a linear function of $\lambda$ and that $p(\lambda)$ is a gamma distribution, so that the normalized prior takes the form

$$
p(\mu, \lambda) = \mathcal{N}(\mu \mid \mu_0, (\beta\lambda)^{-1}) \text{Gam}(\lambda \mid a, b) \tag{2.154}
$$

where we have deﬁned new constants given by $\mu_0 = c/\beta$, $a = 1 + \beta/2$, $b = d - c^2/2\beta$. The distribution (2.154) is called the normal-gamma or Gaussian-gamma distribution and is plotted in Figure 2.14. Note that this is not simply the product of an independent Gaussian prior over $\mu$ and a gamma prior over $\lambda$, because the precision of $\mu$ is a linear function of $\lambda$. Even if we chose a prior in which $\mu$ and $\lambda$ were independent, the posterior distribution would exhibit a coupling between the precision of $\mu$ and the value of $\lambda$.
