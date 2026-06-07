[Page 490]

of divergences (Ali and Silvey, 1966; Amari, 1985; Minka, 2005) deﬁned by

$$
D_\alpha(p \| q) = \frac{4}{1-\alpha^2} \left( 1 - \int p(x)^{(1+\alpha)/2} q(x)^{(1-\alpha)/2} \text{d}x \right) \tag{10.19}
$$

where $-\infty < \alpha < \infty$ is a continuous parameter. The Kullback-Leibler divergence $\text{KL}(p \| q)$ corresponds to the limit $\alpha \to 1$, whereas $\text{KL}(q \| p)$ corresponds to the limit $\alpha \to -1$. For all values of $\alpha$ we have $D_\alpha(p \| q) \ge 0$, with equality if, and only if, $p(x) = q(x)$. Suppose $p(x)$ is a ﬁxed distribution, and we minimize $D_\alpha(p \| q)$ with respect to some set of distributions $q(x)$. Then for $\alpha \le -1$ the divergence is zero forcing, so that any values of $x$ for which $p(x) = 0$ will have $q(x) = 0$, and typically $q(x)$ will under-estimate the support of $p(x)$ and will tend to seek the mode with the largest mass. Conversely for $\alpha \ge 1$ the divergence is zero-avoiding, so that values of $x$ for which $p(x) > 0$ will have $q(x) > 0$, and typically $q(x)$ will stretch to cover all of $p(x)$, and will over-estimate the support of $p(x)$. When $\alpha = 0$ we obtain a symmetric divergence that is linearly related to the Hellinger distance given by

$$
D_H(p \| q) = \int \left( p(x)^{1/2} - q(x)^{1/2} \right)^2 \text{d}x. \tag{10.20}
$$

The square root of the Hellinger distance is a valid distance metric.

### 10.1.3 Example: The univariate Gaussian

We now illustrate the factorized variational approximation using a Gaussian distribution over a single variable $x$ (MacKay, 2003). Our goal is to infer the posterior distribution for the mean $\mu$ and precision $\tau$, given a data set $\mathcal{D} = \{x_1,\dots,x_N\}$ of observed values of $x$ which are assumed to be drawn independently from the Gaussian. The likelihood function is given by

$$
p(\mathcal{D}|\mu, \tau) = \left( \frac{\tau}{2\pi} \right)^{N/2} \exp \left\{ - \frac{\tau}{2} \sum_{n=1}^N (x_n - \mu)^2 \right\}. \tag{10.21}
$$

We now introduce conjugate prior distributions for $\mu$ and $\tau$ given by

$$
p(\mu|\tau) = \mathcal{N}\left(\mu|\mu_0, (\lambda_0 \tau)^{-1}\right) \tag{10.22}
$$

$$
p(\tau) = \text{Gam}(\tau|a_0, b_0) \tag{10.23}
$$

where $\text{Gam}(\tau|a_0, b_0)$ is the gamma distribution deﬁned by (2.146). Together these distributions constitute a Gaussian-Gamma conjugate prior distribution. For this simple problem the posterior distribution can be found exactly, and again takes the form of a Gaussian-gamma distribution. However, for tutorial purposes we will consider a factorized variational approximation to the posterior distribution given by

$$
q(\mu, \tau) = q_\mu(\mu) q_\tau(\tau). \tag{10.24}
$$
