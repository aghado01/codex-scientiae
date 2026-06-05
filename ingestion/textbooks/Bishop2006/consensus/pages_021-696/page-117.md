[Page 117]

Figure 2.11 In the case of a Gaussian distribution, with $\theta$ corresponding to the mean $\mu$, the regression function illustrated in Figure 2.10 takes the form of a straight line, as shown in red. In this case, the random variable $z$ corresponds to the derivative of the log likelihood function and is given by $(x - \mu_{ML})/\sigma^2$, and its expectation that deﬁnes the regression function is a straight line given by $(\mu - \mu_{ML})/\sigma^2$. The root of the regression function corresponds to the maximum likelihood estimator $\mu_{ML}$.

As a speciﬁc example, we consider once again the sequential estimation of the mean of a Gaussian distribution, in which case the parameter $\theta^{(N)}$ is the estimate $\mu_{ML}^{(N)}$ of the mean of the Gaussian, and the random variable $z$ is given by

$$
z = \frac{\partial}{\partial \mu_{ML}} \ln p(x \mid \mu_{ML}, \sigma^2) = \frac{1}{\sigma^2}(x - \mu_{ML}). \tag{2.136}
$$

Thus the distribution of $z$ is Gaussian with mean $\mu - \mu_{ML}$, as illustrated in Figure 2.11. Substituting (2.136) into (2.135), we obtain the univariate form of (2.126), provided we choose the coefﬁcients $a_N$ to have the form $a_N = \sigma^2/N$. Note that although we have focussed on the case of a single variable, the same technique, together with the same restrictions (2.130)-(2.132) on the coefﬁcients $a_N$, apply equally to the multivariate case (Blum, 1965).

###### 2.3.6 Bayesian inference for the Gaussian

The maximum likelihood framework gave point estimates for the parameters $\mu$ and $\Sigma$. Now we develop a Bayesian treatment by introducing prior distributions over these parameters. Let us begin with a simple example in which we consider a single Gaussian random variable $x$. We shall suppose that the variance $\sigma^2$ is known, and we consider the task of inferring the mean $\mu$ given a set of $N$ observations $X = \{x_1, \ldots, x_N\}$. The likelihood function, that is the probability of the observed data given $\mu$, viewed as a function of $\mu$, is given by

$$
p(X \mid \mu) = \prod_{n=1}^{N} p(x_n \mid \mu) = \frac{1}{(2\pi\sigma^2)^{N/2}} \exp\left\{-\frac{1}{2\sigma^2}\sum_{n=1}^{N}(x_n - \mu)^2\right\}. \tag{2.137}
$$

Again we emphasize that the likelihood function $p(X \mid \mu)$ is not a probability distribution over $\mu$ and is not normalized.

We see that the likelihood function takes the form of the exponential of a quadratic form in $\mu$. Thus if we choose a prior $p(\mu)$ given by a Gaussian, it will be a
