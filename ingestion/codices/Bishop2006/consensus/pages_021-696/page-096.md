[Page 96]

We can solve for the Lagrange multiplier $\lambda$ by substituting (2.32) into the constraint $\sum_k \mu_k = 1$ to give $\lambda = -N$. Thus we obtain the maximum likelihood solution in the form
$$
\mu_k^{\text{ML}} = \frac{m_k}{N} \tag{2.33}
$$
which is the fraction of the $N$ observations for which $x_k = 1$.

We can consider the joint distribution of the quantities $m_1, \ldots, m_K$, conditioned on the parameters $\boldsymbol{\mu}$ and on the total number $N$ of observations. From (2.29) this takes the form
$$
\text{Mult}(m_1, m_2, \ldots, m_K | \boldsymbol{\mu}, N) = \binom{N}{m_1 m_2 \ldots m_K} \prod_{k=1}^{K} \mu_k^{m_k} \tag{2.34}
$$
which is known as the multinomial distribution. The normalization coefficient is the number of ways of partitioning $N$ objects into $K$ groups of size $m_1, \ldots, m_K$ and is given by
$$
\binom{N}{m_1 m_2 \ldots m_K} = \frac{N!}{m_1! m_2! \ldots m_K!} . \tag{2.35}
$$
Note that the variables $m_k$ are subject to the constraint
$$
\sum_{k=1}^{K} m_k = N . \tag{2.36}
$$

### 2.2.1 The Dirichlet distribution

We now introduce a family of prior distributions for the parameters $\{\mu_k\}$ of the multinomial distribution (2.34). By inspection of the form of the multinomial distribution, we see that the conjugate prior is given by
$$
p(\boldsymbol{\mu}|\boldsymbol{\alpha}) \propto \prod_{k=1}^{K} \mu_k^{\alpha_k - 1} \tag{2.37}
$$
where $0 \le \mu_k \le 1$ and $\sum_k \mu_k = 1$. Here $\alpha_1, \ldots, \alpha_K$ are the parameters of the distribution, and $\boldsymbol{\alpha}$ denotes $(\alpha_1, \ldots, \alpha_K)^{\text{T}}$. Note that, because of the summation constraint, the distribution over the space of the $\{\mu_k\}$ is confined to a simplex of dimensionality $K - 1$, as illustrated for $K = 3$ in Figure 2.4.

The normalized form for this distribution is by
$$
\text{Dir}(\boldsymbol{\mu}|\boldsymbol{\alpha}) = \frac{\Gamma(\alpha_0)}{\Gamma(\alpha_1) \cdots \Gamma(\alpha_K)} \prod_{k=1}^{K} \mu_k^{\alpha_k - 1} \tag{2.38}
$$
which is called the Dirichlet distribution. Here $\Gamma(x)$ is the gamma function defined by (1.141) while
$$
\alpha_0 = \sum_{k=1}^{K} \alpha_k . \tag{2.39}
$$
