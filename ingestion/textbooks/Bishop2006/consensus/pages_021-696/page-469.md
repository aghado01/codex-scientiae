[Page 469]

where the likelihood $p(\mathbf{t}|\mathbf{w},\beta)$ and the prior $p(\mathbf{w}|\alpha)$ are given by (3.10) and (3.52), respectively, and $y(\mathbf{x},\mathbf{w})$ is given by (3.3). Taking the expectation with respect to the posterior distribution of $\mathbf{w}$ then gives

$$
\mathbb{E}[\ln p(\mathbf{t}, \mathbf{w}|\alpha, \beta)] = \frac{M}{2} \ln \left( \frac{\alpha}{2\pi} \right) - \frac{\alpha}{2} \mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}] + \frac{N}{2} \ln \left( \frac{\beta}{2\pi} \right) - \frac{\beta}{2} \sum_{n=1}^N \mathbb{E}[(t_n - \mathbf{w}^{\text{T}}\boldsymbol{\phi}_n)^2]. \tag{9.62}
$$

Setting the derivatives with respect to $\alpha$ to zero, we obtain the M step re-estimation equation

$$
\alpha = \frac{M}{\mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}]} = \frac{M}{\mathbf{m}_N^{\text{T}}\mathbf{m}_N + \text{Tr}(\mathbf{S}_N)}. \tag{9.63}
$$

An analogous result holds for $\beta$. Note that this re-estimation equation takes a slightly different form from the corresponding result (3.92) derived by direct evaluation of the evidence function. However, they each involve computation and inversion (or eigen decomposition) of an $M \times M$ matrix and hence will have comparable computational cost per iteration.

These two approaches to determining $\alpha$ should of course converge to the same result (assuming they ﬁnd the same local maximum of the evidence function). This can be veriﬁed by ﬁrst noting that the quantity $\gamma$ is deﬁned by

$$
\gamma = M - \alpha \sum_{i=1}^M \frac{1}{\lambda_i + \alpha} = M - \alpha \text{Tr}(\mathbf{S}_N). \tag{9.64}
$$

At a stationary point of the evidence function, the re-estimation equation (3.92) will be self-consistently satisﬁed, and hence we can substitute for $\gamma$ to give

$$
\alpha \mathbf{m}_N^{\text{T}}\mathbf{m}_N = \gamma = M - \alpha \text{Tr}(\mathbf{S}_N) \tag{9.65}
$$

and solving for $\alpha$ we obtain (9.63), which is precisely the EM re-estimation equation.

As a ﬁnal example, we consider a closely related model, namely the relevance vector machine for regression discussed in Section 7.2.1. There we used direct maximization of the marginal likelihood to derive re-estimation equations for the hyperparameters $\boldsymbol{\alpha}$ and $\beta$. Here we consider an alternative approach in which we view the weight vector $\mathbf{w}$ as a latent variable and apply the EM algorithm. The E step involves ﬁnding the posterior distribution over the weights, and this is given by (7.81). In the M step we maximize the expected complete-data log likelihood, which is deﬁned by

$$
\mathbb{E}_{\mathbf{w}} [\ln p(\mathbf{t}|\mathbf{X}, \mathbf{w}, \beta) p(\mathbf{w}|\boldsymbol{\alpha})] \tag{9.66}
$$

where the expectation is taken with respect to the posterior distribution computed using the ‘old’ parameter values. To compute the new parameter values we maximize with respect to $\boldsymbol{\alpha}$ and $\beta$ to give
