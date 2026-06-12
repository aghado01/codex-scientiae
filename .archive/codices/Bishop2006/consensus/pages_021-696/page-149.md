[Page 149]

2.7 ($\star$) Consider a binomial random variable $x$ given by (2.9), with prior distribution for $\mu$ given by the beta distribution (2.13), and suppose we have observed $m$ occurrences of $x = 1$ and $l$ occurrences of $x = 0$. Show that the posterior mean value of $x$ lies between the prior mean and the maximum likelihood estimate for $\mu$. To do this, show that the posterior mean can be written as $\lambda$ times the prior mean plus $(1 - \lambda)$ times the maximum likelihood estimate, where $0 \le \lambda \le 1$. This illustrates the concept of the posterior distribution being a compromise between the prior distribution and the maximum likelihood solution.

2.8 ($\star$) Consider two variables $x$ and $y$ with joint distribution $p(x,y)$. Prove the following two results
$$
\begin{aligned}
\mathbb{E}[x] &= \mathbb{E}_y [\mathbb{E}_x[x|y]] \tag{2.270} \\
\text{var}[x] &= \mathbb{E}_y [\text{var}_x[x|y]] + \text{var}_y [\mathbb{E}_x[x|y]]. \tag{2.271}
\end{aligned}
$$

Here $\mathbb{E}_x[x|y]$ denotes the expectation of $x$ under the conditional distribution $p(x|y)$, with a similar notation for the conditional variance.

2.9 ($\star$) www In this exercise, we prove the normalization of the Dirichlet distribution (2.38) using induction. We have already shown in Exercise 2.5 that the beta distribution, which is a special case of the Dirichlet for $M = 2$, is normalized. We now assume that the Dirichlet distribution is normalized for $M - 1$ variables and prove that it is normalized for $M$ variables. To do this, consider the Dirichlet distribution over $M$ variables, and take account of the constraint $\sum_{k=1}^{M} \mu_k = 1$ by eliminating $\mu_M$, so that the Dirichlet is written
$$
p_M(\mu_1,\ldots,\mu_{M-1}) = C_M \prod_{k=1}^{M-1} \mu_k^{\alpha_k-1} \left( 1 - \sum_{j=1}^{M-1} \mu_j \right)^{\alpha_M-1} \tag{2.272}
$$
and our goal is to find an expression for $C_M$. To do this, integrate over $\mu_{M-1}$, taking care over the limits of integration, and then make a change of variable so that this integral has limits $0$ and $1$. By assuming the correct result for $C_{M-1}$ and making use of (2.265), derive the expression for $C_M$.

2.10 ($\star$) Using the property $\Gamma(x + 1) = x\Gamma(x)$ of the gamma function, derive the following results for the mean, variance, and covariance of the Dirichlet distribution given by (2.38)
$$
\mathbb{E}[\mu_j] = \frac{\alpha_j}{\alpha_0} \tag{2.273}
$$
$$
\text{var}[\mu_j] = \frac{\alpha_j(\alpha_0 - \alpha_j)}{\alpha_0^2(\alpha_0 + 1)} \tag{2.274}
$$
$$
\text{cov}[\mu_j\mu_l] = -\frac{\alpha_j\alpha_l}{\alpha_0^2(\alpha_0 + 1)}, \quad j \neq l \tag{2.275}
$$
where $\alpha_0$ is defined by (2.39).
