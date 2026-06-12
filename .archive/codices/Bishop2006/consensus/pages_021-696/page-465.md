[Page 465]

Consider a set of $D$ binary variables $x_i$, where $i = 1,\dots,D$, each of which is governed by a Bernoulli distribution with parameter $\mu_i$, so that

$$
p(\mathbf{x}|\boldsymbol{\mu}) = \prod_{i=1}^D \mu_i^{x_i} (1 - \mu_i)^{(1 - x_i)} \tag{9.44}
$$

where $\mathbf{x} = (x_1,\dots,x_D)^{\text{T}}$ and $\boldsymbol{\mu} = (\mu_1,\dots,\mu_D)^{\text{T}}$. We see that the individual variables $x_i$ are independent, given $\boldsymbol{\mu}$. The mean and covariance of this distribution are easily seen to be

$$
\mathbb{E}[\mathbf{x}] = \boldsymbol{\mu} \tag{9.45}
$$

$$
\text{cov}[\mathbf{x}] = \text{diag}\{\mu_i(1 - \mu_i)\}. \tag{9.46}
$$

Now let us consider a ﬁnite mixture of these distributions given by

$$
p(\mathbf{x}|\boldsymbol{\mu}, \boldsymbol{\pi}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|\boldsymbol{\mu}_k) \tag{9.47}
$$

where $\boldsymbol{\mu} = \{\boldsymbol{\mu}_1,\dots,\boldsymbol{\mu}_K\}$, $\boldsymbol{\pi} = \{\pi_1,\dots,\pi_K\}$, and

$$
p(\mathbf{x}|\boldsymbol{\mu}_k) = \prod_{i=1}^D \mu_{ki}^{x_i} (1 - \mu_{ki})^{(1 - x_i)}. \tag{9.48}
$$

The mean and covariance of this mixture distribution are given by

$$
\mathbb{E}[\mathbf{x}] = \sum_{k=1}^K \pi_k \boldsymbol{\mu}_k \tag{9.49}
$$

$$
\text{cov}[\mathbf{x}] = \sum_{k=1}^K \pi_k \{ \boldsymbol{\Sigma}_k + \boldsymbol{\mu}_k \boldsymbol{\mu}_k^{\text{T}} \} - \mathbb{E}[\mathbf{x}]\mathbb{E}[\mathbf{x}]^{\text{T}} \tag{9.50}
$$

where $\boldsymbol{\Sigma}_k = \text{diag} \{\mu_{ki}(1 - \mu_{ki})\}$. Because the covariance matrix $\text{cov}[\mathbf{x}]$ is no longer diagonal, the mixture distribution can capture correlations between the variables, unlike a single Bernoulli distribution.

If we are given a data set $\mathbf{X} = \{\mathbf{x}_1,\dots,\mathbf{x}_N\}$ then the log likelihood function for this model is given by

$$
\ln p(\mathbf{X}|\boldsymbol{\mu}, \boldsymbol{\pi}) = \sum_{n=1}^N \ln \left\{ \sum_{k=1}^K \pi_k p(\mathbf{x}_n|\boldsymbol{\mu}_k) \right\}. \tag{9.51}
$$

Again we see the appearance of the summation inside the logarithm, so that the maximum likelihood solution no longer has closed form.

We now derive the EM algorithm for maximizing the likelihood function for the mixture of Bernoulli distributions. To do this, we ﬁrst introduce an explicit latent
