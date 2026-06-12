[Page 491]

Note that the true posterior distribution does not factorize in this way. The optimum factors $q_\mu(\mu)$ and $q_\tau(\tau)$ can be obtained from the general result (10.9) as follows. For $q_\mu(\mu)$ we have

$$
\begin{aligned}
\ln q^\star_\mu(\mu) &= \mathbb{E}_\tau [\ln p(\mathcal{D}|\mu, \tau) + \ln p(\mu|\tau)] + \text{const} \\
&= - \frac{\mathbb{E}[\tau]}{2} \left\{ \lambda_0(\mu - \mu_0)^2 + \sum_{n=1}^N (x_n - \mu)^2 \right\} + \text{const}.
\end{aligned} \tag{10.25}
$$

Completing the square over $\mu$ we see that $q_\mu(\mu)$ is a Gaussian $\mathcal{N}(\mu|\mu_N, \lambda_N^{-1})$ with mean and precision given by

$$
\mu_N = \frac{\lambda_0 \mu_0 + N \overline{x}}{\lambda_0 + N} \tag{10.26}
$$

$$
\lambda_N = (\lambda_0 + N)\mathbb{E}[\tau]. \tag{10.27}
$$

Note that for $N \to \infty$ this gives the maximum likelihood result in which $\mu_N = \overline{x}$ and the precision is inﬁnite.

Similarly, the optimal solution for the factor $q_\tau(\tau)$ is given by

$$
\begin{aligned}
\ln q^\star_\tau(\tau) &= \mathbb{E}_\mu [\ln p(\mathcal{D}|\mu, \tau) + \ln p(\mu|\tau)] + \ln p(\tau) + \text{const} \\
&= (a_0 - 1)\ln \tau - b_0 \tau + \frac{N}{2} \ln \tau \\
&\quad - \frac{\tau}{2} \mathbb{E}_\mu \left[ \sum_{n=1}^N (x_n - \mu)^2 + \lambda_0(\mu - \mu_0)^2 \right] + \text{const}
\end{aligned} \tag{10.28}
$$

and hence $q_\tau(\tau)$ is a gamma distribution $\text{Gam}(\tau|a_N, b_N)$ with parameters

$$
a_N = a_0 + \frac{N}{2} \tag{10.29}
$$

$$
b_N = b_0 + \frac{1}{2} \mathbb{E}_\mu \left[ \sum_{n=1}^N (x_n - \mu)^2 + \lambda_0(\mu - \mu_0)^2 \right]. \tag{10.30}
$$

Again this exhibits the expected behaviour when $N \to \infty$. It should be emphasized that we did not assume these speciﬁc functional forms for the optimal distributions $q_\mu(\mu)$ and $q_\tau(\tau)$. They arose naturally from the structure of the likelihood function and the corresponding conjugate priors.

Thus we have expressions for the optimal distributions $q_\mu(\mu)$ and $q_\tau(\tau)$ each of which depends on moments evaluated with respect to the other distribution. One approach to ﬁnding a solution is therefore to make an initial guess for, say, the moment $\mathbb{E}[\tau]$ and use this to re-compute the distribution $q_\mu(\mu)$. Given this revised distribution we can then extract the required moments $\mathbb{E}[\mu]$ and $\mathbb{E}[\mu^2]$, and use these to recompute the distribution $q_\tau(\tau)$, and so on. Since the space of hidden variables for this example is only two dimensional, we can illustrate the variational approximation to the posterior distribution by plotting contours of both the true posterior and the factorized approximation, as illustrated in Figure 10.4.
