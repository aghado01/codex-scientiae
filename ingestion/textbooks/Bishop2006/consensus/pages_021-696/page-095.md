[Page 95]

0. So, for instance if we have a variable that can take $K = 6$ states and a particular observation of the variable happens to correspond to the state where $x_3 = 1$, then $\mathbf{x}$ will be represented by

$$
\mathbf{x} = (0, 0, 1, 0, 0, 0)^T. \tag{2.25}
$$

Note that such vectors satisfy $\sum_{k=1}^{K} x_k = 1$. If we denote the probability of $x_k = 1$ by the parameter $\mu_k$, then the distribution of $\mathbf{x}$ is given by

$$
p(\mathbf{x} \mid \boldsymbol{\mu}) = \prod_{k=1}^{K} \mu_k^{x_k}. \tag{2.26}
$$

where $\boldsymbol{\mu} = (\mu_1, \ldots, \mu_K)^T$, and the parameters $\mu_k$ are constrained to satisfy $\mu_k \ge 0$ and $\sum_k \mu_k = 1$, because they represent probabilities. The distribution (2.26) can be regarded as a generalization of the Bernoulli distribution to more than two outcomes. It is easily seen that the distribution is normalized

$$
\sum_{\mathbf{x}} p(\mathbf{x} \mid \boldsymbol{\mu}) = \sum_{k=1}^{K} \mu_k = 1 \tag{2.27}
$$

and that

$$
\mathbb{E}[\mathbf{x} \mid \boldsymbol{\mu}] = \sum_{\mathbf{x}} p(\mathbf{x} \mid \boldsymbol{\mu})\mathbf{x} = (\mu_1, \ldots, \mu_K)^T = \boldsymbol{\mu}. \tag{2.28}
$$

Now consider a data set $\mathcal{D}$ of $N$ independent observations $\mathbf{x}_1, \ldots, \mathbf{x}_N$. The corresponding likelihood function takes the form

$$
p(\mathcal{D} \mid \boldsymbol{\mu}) = \prod_{n=1}^{N} \prod_{k=1}^{K} \mu_k^{x_{nk}} = \prod_{k=1}^{K} \mu_k^{\sum_n x_{nk}} = \prod_{k=1}^{K} \mu_k^{m_k}. \tag{2.29}
$$

We see that the likelihood function depends on the $N$ data points only through the $K$ quantities

$$
m_k = \sum_n x_{nk} \tag{2.30}
$$

which represent the number of observations of $x_k = 1$. These are called the sufﬁcient statistics for this distribution.

In order to ﬁnd the maximum likelihood solution for $\boldsymbol{\mu}$, we need to maximize $\ln p(\mathcal{D} \mid \boldsymbol{\mu})$ with respect to $\mu_k$ taking account of the constraint that the $\mu_k$ must sum to one. This can be achieved using a Lagrange multiplier $\lambda$ and maximizing

$$
\sum_{k=1}^{K} m_k \ln \mu_k + \lambda\left(\sum_{k=1}^{K} \mu_k - 1\right). \tag{2.31}
$$

Setting the derivative of (2.31) with respect to $\mu_k$ to zero, we obtain

$$
\mu_k = -\frac{m_k}{\lambda}. \tag{2.32}
$$
