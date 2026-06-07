[Page 239]

where

$$
p(a) = \int \delta(a - \mathbf{w}^T \boldsymbol{\phi}) q(\mathbf{w}) \, d\mathbf{w}. \tag{4.148}
$$

We can evaluate $p(a)$ by noting that the delta function imposes a linear constraint on $\mathbf{w}$ and so forms a marginal distribution from the joint distribution $q(\mathbf{w})$ by integrating out all directions orthogonal to $\boldsymbol{\phi}$. Because $q(\mathbf{w})$ is Gaussian, we know from Section 2.3.2 that the marginal distribution will also be Gaussian. We can evaluate the mean and covariance of this distribution by taking moments, and interchanging the order of integration over $a$ and $\mathbf{w}$, so that

$$
\mu_a = \mathbb{E}[a] = \int p(a) a \, da = \int q(\mathbf{w}) \mathbf{w}^T \boldsymbol{\phi} \, d\mathbf{w} = \mathbf{w}_{\text{MAP}}^T \boldsymbol{\phi} \tag{4.149}
$$

where we have used the result (4.144) for the variational posterior distribution $q(\mathbf{w})$. Similarly

$$
\begin{align}
\sigma_a^2 &= \text{var}[a] = \int p(a) \left\{a^2 - \mathbb{E}[a]^2\right\} \, da \\
&= \int q(\mathbf{w}) \left\{(\mathbf{w}^T \boldsymbol{\phi})^2 - (\mathbf{m}_N^T \boldsymbol{\phi})^2\right\} \, d\mathbf{w} = \boldsymbol{\phi}^T \mathbf{S}_N \boldsymbol{\phi}. \tag{4.150}
\end{align}
$$

Note that the distribution of $a$ takes the same form as the predictive distribution (3.58) for the linear regression model, with the noise variance set to zero. Thus our variational approximation to the predictive distribution becomes

$$
p(\mathcal{C}_1|\mathbf{t}) = \int \sigma(a)p(a) \, da = \int \sigma(a)\mathcal{N}(a|\mu_a, \sigma_a^2) \, da. \tag{4.151}
$$

This result can also be derived directly by making use of the results for the marginal of a Gaussian distribution given in Section 2.3.2. 

The integral over $a$ represents the convolution of a Gaussian with a logistic sigmoid, and cannot be evaluated analytically. We can, however, obtain a good approximation (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b; Barber and Bishop, 1998a) by making use of the close similarity between the logistic sigmoid function $\sigma(a)$ defined by (4.59) and the probit function $\Phi(a)$ defined by (4.114). In order to obtain the best approximation to the logistic function we need to re-scale the horizontal axis, so that we approximate $\sigma(a)$ by $\Phi(\lambda a)$. We can find a suitable value of $\lambda$ by requiring that the two functions have the same slope at the origin, which gives $\lambda^2 = \pi/8$. The similarity of the logistic sigmoid and the probit function, for this choice of $\lambda$, is illustrated in Figure 4.9.

The advantage of using a probit function is that its convolution with a Gaussian can be expressed analytically in terms of another probit function. Specifically we can show that

$$
\int \Phi(\lambda a)\mathcal{N}(a|\mu, \sigma^2) \, da = \Phi\left( \frac{\mu}{(\lambda^{-2} + \sigma^2)^{1/2}} \right). \tag{4.152}
$$
