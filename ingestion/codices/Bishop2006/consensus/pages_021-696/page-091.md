[Page 91]

given by (2.3) and (2.4), respectively, we have

$$
\mathbb{E}[m] \equiv \sum_{m=0}^{N} m \text{Bin}(m|N,\mu) = N\mu \tag{2.11}
$$

$$
\text{var}[m] \equiv \sum_{m=0}^{N} (m - \mathbb{E}[m])^2 \text{Bin}(m|N,\mu) = N\mu(1-\mu). \tag{2.12}
$$

These results can also be proved directly using calculus.

### 2.1.1 The beta distribution

We have seen in (2.8) that the maximum likelihood setting for the parameter $\mu$ in the Bernoulli distribution, and hence in the binomial distribution, is given by the fraction of the observations in the data set having $x = 1$. As we have already noted, this can give severely over-fitted results for small data sets. In order to develop a Bayesian treatment for this problem, we need to introduce a prior distribution $p(\mu)$ over the parameter $\mu$. Here we consider a form of prior distribution that has a simple interpretation as well as some useful analytical properties. To motivate this prior, we note that the likelihood function takes the form of the product of factors of the form $\mu^x(1 - \mu)^{1-x}$. If we choose a prior to be proportional to powers of $\mu$ and $(1 - \mu)$, then the posterior distribution, which is proportional to the product of the prior and the likelihood function, will have the same functional form as the prior. This property is called conjugacy and we will see several examples of it later in this chapter. We therefore choose a prior, called the beta distribution, given by

$$
\text{Beta}(\mu|a,b) = \frac{\Gamma(a+b)}{\Gamma(a)\Gamma(b)} \mu^{a-1}(1-\mu)^{b-1} \tag{2.13}
$$

where $\Gamma(x)$ is the gamma function defined by (1.141), and the coefficient in (2.13) ensures that the beta distribution is normalized, so that

$$
\int_{0}^{1} \text{Beta}(\mu|a,b) \mathrm{d}\mu = 1. \tag{2.14}
$$

The mean and variance of the beta distribution are given by

$$
\mathbb{E}[\mu] = \frac{a}{a+b} \tag{2.15}
$$

$$
\text{var}[\mu] = \frac{ab}{(a+b)^2(a+b+1)}. \tag{2.16}
$$

The parameters $a$ and $b$ are often called hyperparameters because they control the distribution of the parameter $\mu$. Figure 2.2 shows plots of the beta distribution for various values of the hyperparameters.

The posterior distribution of $\mu$ is now obtained by multiplying the beta prior (2.13) by the binomial likelihood function (2.9) and normalizing. Keeping only the factors that depend on $\mu$, we see that this posterior distribution has the form

$$
p(\mu|m,l,a,b) \propto \mu^{m+a-1}(1-\mu)^{l+b-1} \tag{2.17}
$$
