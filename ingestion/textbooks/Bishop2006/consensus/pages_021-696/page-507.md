[Page 507]

Figure 10.8 Probabilistic graphical model representing the joint distribution (10.90) for the Bayesian linear regression model.

![image 240](../images/imageFile240.png)

posterior distribution given by the factorized expression

$$
q(\mathbf{w}, \alpha) = q(\mathbf{w})q(\alpha). \tag{10.91}
$$

We can ﬁnd re-estimation equations for the factors in this distribution by making use of the general result (10.9). Recall that for each factor, we take the log of the joint distribution over all variables and then average with respect to those variables not in that factor. Consider ﬁrst the distribution over $\alpha$. Keeping only terms that have a functional dependence on $\alpha$, we have

$$
\begin{aligned}
\ln q^\star(\alpha) &= \ln p(\alpha) + \mathbb{E}_{\mathbf{w}}[\ln p(\mathbf{w}|\alpha)] + \text{const} \\
&= (a_0 - 1)\ln \alpha - b_0 \alpha + \frac{M}{2} \ln \alpha - \frac{\alpha}{2} \mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}] + \text{const}.
\end{aligned} \tag{10.92}
$$

We recognize this as the log of a gamma distribution, and so identifying the coefﬁcients of $\alpha$ and $\ln \alpha$ we obtain

$$
q^\star(\alpha) = \text{Gam}(\alpha|a_N, b_N) \tag{10.93}
$$

where

$$
a_N = a_0 + \frac{M}{2} \tag{10.94}
$$

$$
b_N = b_0 + \frac{1}{2} \mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}]. \tag{10.95}
$$

Similarly, we can ﬁnd the variational re-estimation equation for the posterior distribution over $\mathbf{w}$. Again, using the general result (10.9), and keeping only those terms that have a functional dependence on $\mathbf{w}$, we have

$$
\ln q^\star(\mathbf{w}) = \ln p(\mathbf{t}|\mathbf{w}) + \mathbb{E}_{\alpha}[\ln p(\mathbf{w}|\alpha)] + \text{const} \tag{10.96}
$$

$$
= -\frac{\beta}{2} \sum_{n=1}^N \{ \mathbf{w}^{\text{T}}\boldsymbol{\phi}_n - t_n \}^2 - \frac{1}{2} \mathbb{E}[\alpha]\mathbf{w}^{\text{T}}\mathbf{w} + \text{const} \tag{10.97}
$$

$$
= -\frac{1}{2} \mathbf{w}^{\text{T}} (\mathbb{E}[\alpha]\mathbf{I} + \beta \boldsymbol{\Phi}^{\text{T}}\boldsymbol{\Phi})\mathbf{w} + \beta \mathbf{w}^{\text{T}} \boldsymbol{\Phi}^{\text{T}} \mathbf{t} + \text{const}. \tag{10.98}
$$

Because this is a quadratic form, the distribution $q^\star(\mathbf{w})$ is Gaussian, and so we can complete the square in the usual way to identify the mean and covariance, giving

$$
q^\star(\mathbf{w}) = \mathcal{N}(\mathbf{w}|\mathbf{m}_N, \mathbf{S}_N) \tag{10.99}
$$
