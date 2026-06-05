[Page 45]

Figure 1.13 Plot of the univariate Gaussian showing the mean $\mu$ and the standard deviation $\sigma$.

![image 18](../../../../../images/imageFile18.png)

$$
\int_{-\infty}^{\infty} \mathcal{N}(x \mid \mu, \sigma^2)\,dx = 1. \tag{1.48}
$$

Thus (1.46) satisﬁes the two requirements for a valid probability density. We can readily ﬁnd expectations of functions of $x$ under the Gaussian distribu-

tion. In particular, the average value of $x$ is given by

$$
\mathbb{E}[x] = \int_{-\infty}^{\infty} \mathcal{N}(x \mid \mu, \sigma^2)x\,dx = \mu. \tag{1.49}
$$

Because the parameter $\mu$ represents the average value of $x$ under the distribution, it is referred to as the mean. Similarly, for the second order moment

$$
\mathbb{E}[x^2] = \int_{-\infty}^{\infty} \mathcal{N}(x \mid \mu, \sigma^2)x^2\,dx = \mu^2 + \sigma^2. \tag{1.50}
$$

From (1.49) and (1.50), it follows that the variance of $x$ is given by

$$
\operatorname{var}[x] = \mathbb{E}[x^2] - \mathbb{E}[x]^2 = \sigma^2. \tag{1.51}
$$

and hence $\sigma^2$ is referred to as the variance parameter. The maximum of a distribution

is known as its mode. For a Gaussian, the mode coincides with the mean. We are also interested in the Gaussian distribution deﬁned over a $D$-dimensional

vector $\mathbf{x}$ of continuous variables, which is given by

$$
\mathcal{N}(\mathbf{x} \mid \boldsymbol{\mu}, \Sigma) = \frac{1}{(2\pi)^{D/2}} \frac{1}{|\Sigma|^{1/2}} \exp\left\{-\frac{1}{2}(\mathbf{x} - \boldsymbol{\mu})^T \Sigma^{-1}(\mathbf{x} - \boldsymbol{\mu})\right\}. \tag{1.52}
$$

where the $D$-dimensional vector $\boldsymbol{\mu}$ is called the mean, the $D \times D$ matrix $\Sigma$ is called the covariance, and $|\Sigma|$ denotes the determinant of $\Sigma$. We shall make use of the multivariate Gaussian distribution brieﬂy in this chapter, although its properties will be studied in detail in Section 2.3.
