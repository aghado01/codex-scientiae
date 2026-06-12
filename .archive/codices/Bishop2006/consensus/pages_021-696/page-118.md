[Page 118]

conjugate distribution for this likelihood function because the corresponding posterior will be a product of two exponentials of quadratic functions of $\mu$ and hence will also be Gaussian. We therefore take our prior distribution to be

$$
p(\mu) = \mathcal{N}(\mu|\mu_{0}, \sigma_{0}^{2})
\tag{2.138}
$$

and the posterior distribution is given by

$$
p(\mu|\mathbf{X}) \propto p(\mathbf{X}|\mu)p(\mu).
\tag{2.139}
$$

Simple manipulation involving completing the square in the exponent shows that the posterior distribution is given by

$$
p(\mu|\mathbf{X}) = \mathcal{N}(\mu|\mu_{N}, \sigma_{N}^{2})
\tag{2.140}
$$

where

$$
\mu_{N} = \frac{\sigma^{2}}{N\sigma_{0}^{2} + \sigma^{2}}\mu_{0} + \frac{N\sigma_{0}^{2}}{N\sigma_{0}^{2} + \sigma^{2}}\mu_{\text{ML}}
\tag{2.141}
$$

$$
\frac{1}{\sigma_{N}^{2}} = \frac{1}{\sigma_{0}^{2}} + \frac{N}{\sigma^{2}}
\tag{2.142}
$$

in which $\mu_{\text{ML}}$ is the maximum likelihood solution for $\mu$ given by the sample mean

$$
\mu_{\text{ML}} = \frac{1}{N} \sum_{n=1}^{N} x_{n}.
\tag{2.143}
$$

It is worth spending a moment studying the form of the posterior mean and variance. First of all, we note that the mean of the posterior distribution given by (2.141) is a compromise between the prior mean $\mu_{0}$ and the maximum likelihood solution $\mu_{\text{ML}}$. If the number of observed data points $N = 0$, then (2.141) reduces to the prior mean as expected. For $N \to \infty$, the posterior mean is given by the maximum likelihood solution. Similarly, consider the result (2.142) for the variance of the posterior distribution. We see that this is most naturally expressed in terms of the inverse variance, which is called the precision. Furthermore, the precisions are additive, so that the precision of the posterior is given by the precision of the prior plus one contribution of the data precision from each of the observed data points. As we increase the number of observed data points, the precision steadily increases, corresponding to a posterior distribution with steadily decreasing variance. With no observed data points, we have the prior variance, whereas if the number of data points $N \to \infty$, the variance $\sigma_{N}^{2}$ goes to zero and the posterior distribution becomes infinitely peaked around the maximum likelihood solution. We therefore see that the maximum likelihood result of a point estimate for $\mu$ given by (2.143) is recovered precisely from the Bayesian formalism in the limit of an infinite number of observations. Note also that for finite $N$, if we take the limit $\sigma_{0}^{2} \to \infty$ in which the prior has infinite variance then the posterior mean (2.141) reduces to the maximum likelihood result, while from (2.142) the posterior variance is given by $\sigma_{N}^{2} = \sigma^{2}/N$.
