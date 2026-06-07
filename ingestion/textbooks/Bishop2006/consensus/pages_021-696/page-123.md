[Page 123]

Figure 2.15 Plot of Student’s t-distribution (2.159) for $\mu = 0$ and $\lambda = 1$ for various values of $\nu$. The limit $\nu \to \infty$ corresponds to a Gaussian distribution with mean $\mu$ and precision $\lambda$.

![The image is a graph that shows the behavior of a series of waves. The graph is titled Waves and has a title at the top that reads Waves. The graph has a horizontal axis labeled x and a vertical axis labeled y. The x-axis is labeled x and the y-axis is labeled y. The graph shows a series of waves, each represented by a different color. The waves are represented by different colors, with each wave having a different amplitude. The amplitude is the maximum displacement of the wave from its equilibrium position. The amplitude is represented by a value between -5 and 0.5. The graph shows the following waves: 1. A green wave with a height of 0.1. 2. A red wave with a height of 0.2. 3. A blue wave with a height of 0.3. 4. A green wave with a height of 0](../images/imageFile56.png)

$$
\begin{aligned}
p(x \mid \mu, a, b) &= \int_{0}^{\infty} \mathcal{N}(x \mid \mu, \tau^{-1}) \text{Gam}(\tau \mid a, b) \, d\tau \\
&= \int_{0}^{\infty} \frac{b^a e^{-b\tau} \tau^{a-1}}{\Gamma(a)} \left( \frac{\tau}{2\pi} \right)^{1/2} \exp \left\{ -\frac{\tau}{2} (x - \mu)^2 \right\} \, d\tau \\
&= \frac{b^a}{\Gamma(a)} \left( \frac{1}{2\pi} \right)^{1/2} \left[ b + \frac{(x - \mu)^2}{2} \right]^{-a-1/2} \Gamma(a + 1/2) \tag{2.158}
\end{aligned}
$$

where we have made the change of variable $z = \tau[b + (x - \mu)^2/2]$. By convention we define new parameters given by $\nu = 2a$ and $\lambda = a/b$, in terms of which the distribution $p(x \mid \mu, a, b)$ takes the form

$$
\text{St}(x \mid \mu, \lambda, \nu) = \frac{\Gamma(\nu/2 + 1/2)}{\Gamma(\nu/2)} \left( \frac{\lambda}{\pi\nu} \right)^{1/2} \left[ 1 + \frac{\lambda(x - \mu)^2}{\nu} \right]^{-\nu/2 - 1/2} \tag{2.159}
$$

which is known as Student’s t-distribution. The parameter $\lambda$ is sometimes called the precision of the t-distribution, even though it is not in general equal to the inverse of the variance. The parameter $\nu$ is called the degrees of freedom, and its effect is illustrated in Figure 2.15. For the particular case of $\nu = 1$, the t-distribution reduces to the Cauchy distribution, while in the limit $\nu \to \infty$ the t-distribution $\text{St}(x \mid \mu, \lambda, \nu)$ becomes a Gaussian $\mathcal{N}(x \mid \mu, \lambda^{-1})$ with mean $\mu$ and precision $\lambda$. From (2.158), we see that Student’s t-distribution is obtained by adding up an infinite number of Gaussian distributions having the same mean but different precisions. This can be interpreted as an infinite mixture of Gaussians (Gaussian mixtures will be discussed in detail in Section 2.3.9). The result is a distribution that in general has longer ‘tails’ than a Gaussian, as was seen in Figure 2.15. This gives the t-distribution an important property called robustness, which means that it is much less sensitive than the Gaussian to the presence of a few data points which are outliers. The robustness of the t-distribution is illustrated in Figure 2.16, which compares the maximum likelihood solutions for a Gaussian and a t-distribution. Note that the maximum likelihood solution for the t-distribution can be found using the expectation-maximization (EM) algorithm. Here we see that the effect of a small number of
