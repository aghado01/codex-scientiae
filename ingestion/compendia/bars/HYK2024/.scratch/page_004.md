Suppose $k_1, \ldots, k_d \ll m$, then $Z^\top Z$ is of full rank. In terms of $\beta, \sigma$, we assume

$$
\beta | Z, \sigma \sim N_\nu\left(0, m\sigma^2(Z^\top Z)^{-1}\right), \quad \pi(\sigma) = \frac{1}{\sigma}, \quad \sigma > 0 \tag{4}
$$

The prior of $\beta$ is the so-called unit information prior. According to the linear regression theory, the least squares estimator of $\beta$ is $\hat{\beta} = (Z^\top Z)^{-1}Z^\top y$. Then the precision matrix (inverse covariance) is given by $(Z^\top Z)/\sigma^2$. The unit precision matrix is defined as $(Z^\top Z)/m\sigma^2$, implying the prior of $\beta$ in (4). The prior of $\sigma$ is an improper prior as $\int_0^\infty 1/\sigma d\sigma = \infty$.

According to the Bayesian formula, the posterior density of $k, \xi, \beta, \sigma$ is

$$
p(k, \xi, \beta, \sigma | y) = p(\beta, \sigma | k, \xi, y) p(k, \xi | y) \tag{5}
$$

where $p(k, \xi | y) \propto p(y | k, \xi) \pi(k, \xi)$. Let $a_{k,\xi} = y^\top (I_m - \frac{m}{m+1}Z(Z^\top Z)^{-1}Z^\top)y$.

> [!NOTE]
> **Lemma 1.** With the above priors of $k, \xi, \beta, \sigma$ in (2), we have
> $$
> p(y|k,\xi) \propto (m+1)^{-\nu/2} a_{k,\xi}^{-m/2}, \quad p(k,\xi|y) \propto (m+1)^{-\nu/2} a_{k,\xi}^{-m/2} \tau(\mathcal{M}_k)^{-\gamma} \tag{6}
> $$

The posterior $p(k, \xi | y)$ consists of three main components. The first term $(m+1)^{-\nu/2}$ serves as the dimensional penalty. It balances the number of parameters and the bias of model fitting. The second term $a_{k,\xi}^{-m/2}$ represents the effect of the likelihood. When $m$ is sufficiently large, $a_{k,\xi}$ is approximately equal to the residual sum of squares. The third term $\tau(\mathcal{M}_k)^{-\gamma}$ corresponds to the priors of $k, \xi$. It takes the complexity of $\mathcal{M}_k$ into consideration.

Subsequently, we can simulate samples of $\beta, \sigma$ given $k, \xi$ from the conditional posterior density in (5) via a Gibbs sampler, contributing to a fully Bayesian model.

## 2.3 Extended Bayesian information criterion

The Gaussian prior of $\beta$ is a conjugate prior in (2), yielding a closed expression of $p(y|k,\xi)$. Generally, $p(y|k,\xi)$ is analytically intractable except for the normal regression model. For those non-conjugate cases, we utilize the extended Bayesian information criterion (EBIC) of Chen and Chen [2008] to approximate the posterior density. In the spline knot estimation, the cardinality of all candidate knots (i.e., $n$) can be very large but the number of the true knots (i.e., $k$) is small compared to the sample size (i.e., $m$). Thus, EBIC will be extremely useful for model selection as the small-$m$-large-$n$ assumption holds and the Laplace approximation is valid [Foygel and Drton, 2010, Chen and Chen, 2012, Luo et al., 2015].

According to the definition, the EBIC of $k, \xi$ is

$$
\text{BIC}_\gamma(k,\xi) = -2\log L(\hat{\beta},\hat{\sigma}|y,k,\xi) + (\nu+1)\log m + 2\gamma\log\tau(\mathcal{M}_k), \quad 0\leq \gamma\leq 1 \tag{7}
$$

where $\hat{\beta}, \hat{\sigma}$ are the maximum likelihood estimators of $\beta, \sigma$ given $k, \xi$. Especially in (2), $\hat{\beta} = (Z^\top Z)^{-1}Z^\top y$ and $\hat{\sigma}^2 = y^\top (I_m - Z(Z^\top Z)^{-1}Z^\top)y/m$. As $\gamma = 0$, (7) is the ordinary BIC. Since $n_1, \ldots, n_d \gg m$, the EBIC with $\gamma > 0$ is preferable to the ordinary BIC in knot estimation. From the Laplace approximation, $p(k, \xi | y) \approx \exp\{-\text{BIC}_\gamma(k, \xi)/2\}$, denoted by $\hat{p}(k, \xi | y)$.

> [!NOTE]
> **Lemma 2.** In multivariate spline model (2), the EBIC approximation of the posterior density is
> $$
> \hat{p}(k,\xi|y) \propto m^{-(\nu+1)/2} (\hat{\sigma}^2)^{-m/2} \tau(\mathcal{M}_k)^{-\gamma} \tag{8}
> $$

Suppose $k', \xi'$ are another group of knots. Comparing (6) and (8), we can find $p(k, \xi | y) / p(k', \xi' | y) \approx \hat{p}(k, \xi | y) / \hat{p}(k', \xi' | y)$ when $m$ is sufficiently large. Since the sampling procedure of MCMC is determined by the posterior density ratio, the EBIC contributes to a consistent estimation.

## 3 Reversible jump Markov chain Monte Carlo

The reversible jump approach [Green, 1995] is an extension of the standard Metropolis-Hastings algorithm, allowing the trans-dimensional movement. These algorithms are widely used in the (Bayesian) model determination problems where the dimension of parameters is unknown [Bolton and Heard, 2018, Chapple et al., 2020].
