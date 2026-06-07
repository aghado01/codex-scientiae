[Page 127]

![Figure 2.18](../images/imageFile59.png)
Figure 2.18 The von Mises distribution can be derived by considering a two-dimensional Gaussian of the form (2.173), whose density contours are shown in blue and conditioning on the unit circle shown in red.

to one, but it must also be periodic. Thus $p(\theta)$ must satisfy the three conditions
$$
p(\theta) \geq 0 \tag{2.170}
$$
$$
\int_{0}^{2\pi} p(\theta) \, d\theta = 1 \tag{2.171}
$$
$$
p(\theta + 2\pi) = p(\theta). \tag{2.172}
$$

From (2.172), it follows that $p(\theta + M2\pi) = p(\theta)$ for any integer $M$.

We can easily obtain a Gaussian-like distribution that satisfies these three properties as follows. Consider a Gaussian distribution over two variables $\mathbf{x} = (x_1, x_2)$ having mean $\boldsymbol{\mu} = (\mu_1, \mu_2)$ and a covariance matrix $\boldsymbol{\Sigma} = \sigma^2\mathbf{I}$ where $\mathbf{I}$ is the $2 \times 2$ identity matrix, so that
$$
p(x_1, x_2) = \frac{1}{2\pi\sigma^2} \exp \left\{ -\frac{(x_1 - \mu_1)^2 + (x_2 - \mu_2)^2}{2\sigma^2} \right\}. \tag{2.173}
$$

The contours of constant $p(\mathbf{x})$ are circles, as illustrated in Figure 2.18. Now suppose we consider the value of this distribution along a circle of fixed radius. Then by construction this distribution will be periodic, although it will not be normalized. We can determine the form of this distribution by transforming from Cartesian coordinates $(x_1, x_2)$ to polar coordinates $(r, \theta)$ so that
$$
x_1 = r \cos \theta, \quad x_2 = r \sin \theta. \tag{2.174}
$$

We also map the mean $\boldsymbol{\mu}$ into polar coordinates by writing
$$
\mu_1 = r_0 \cos \theta_0, \quad \mu_2 = r_0 \sin \theta_0. \tag{2.175}
$$

Next we substitute these transformations into the two-dimensional Gaussian distribution (2.173), and then condition on the unit circle $r = 1$, noting that we are interested only in the dependence on $\theta$. Focussing on the exponent in the Gaussian distribution we have
$$
\begin{aligned}
&-\frac{1}{2\sigma^2} \left\{ (r \cos \theta - r_0 \cos \theta_0)^2 + (r \sin \theta - r_0 \sin \theta_0)^2 \right\} \\
&= -\frac{1}{2\sigma^2} \left\{ 1 + r_0^2 - 2r_0 \cos \theta \cos \theta_0 - 2r_0 \sin \theta \sin \theta_0 \right\} \\
&= \frac{r_0}{\sigma^2} \cos(\theta - \theta_0) + \text{const}
\end{aligned} \tag{2.176}
$$
