[Page 487]

optimal factor $q^\star_1(z_1)$. In doing so it is useful to note that on the right-hand side we only need to retain those terms that have some functional dependence on $z_1$ because all other terms can be absorbed into the normalization constant. Thus we have

$$
\begin{aligned}
\ln q^\star_1(z_1) &= \mathbb{E}_{z_2}[\ln p(\mathbf{z})] + \text{const} \\
&= \mathbb{E}_{z_2} \left[ - \frac{1}{2} (z_1 - \mu_1)^2 \Lambda_{11} - (z_1 - \mu_1)\Lambda_{12}(z_2 - \mu_2) \right] + \text{const} \\
&= - \frac{1}{2} z_1^2 \Lambda_{11} + z_1 \mu_1 \Lambda_{11} - z_1 \Lambda_{12} (\mathbb{E}[z_2] - \mu_2) + \text{const}.
\end{aligned} \tag{10.11}
$$

Next we observe that the right-hand side of this expression is a quadratic function of $z_1$, and so we can identify $q^\star(z_1)$ as a Gaussian distribution. It is worth emphasizing that we did not assume that $q(z_i)$ is Gaussian, but rather we derived this result by variational optimization of the KL divergence over all possible distributions $q(z_i)$. Note also that we do not need to consider the additive constant in (10.9) explicitly because it represents the normalization constant that can be found at the end by inspection if required. Using the technique of completing the square, we can identify the mean and precision of this Gaussian, giving

$$
q^\star_1(z_1) = \mathcal{N}(z_1 | m_1, \Lambda_{11}^{-1}) \tag{10.12}
$$

where

$$
m_1 = \mu_1 - \Lambda_{11}^{-1} \Lambda_{12} (\mathbb{E}[z_2] - \mu_2). \tag{10.13}
$$

By symmetry, $q^\star_2(z_2)$ is also Gaussian and can be written as

$$
q^\star_2(z_2) = \mathcal{N}(z_2 | m_2, \Lambda_{22}^{-1}) \tag{10.14}
$$

in which

$$
m_2 = \mu_2 - \Lambda_{22}^{-1} \Lambda_{21} (\mathbb{E}[z_1] - \mu_1). \tag{10.15}
$$

Note that these solutions are coupled, so that $q^\star_1(z_1)$ depends on expectations computed with respect to $q^\star_2(z_2)$ and vice versa. In general, we address this by treating the variational solutions as re-estimation equations and cycling through the variables in turn updating them until some convergence criterion is satisﬁed. We shall see an example of this shortly. Here, however, we note that the problem is sufﬁciently simple that a closed form solution can be found. In particular, because $\mathbb{E}[z_1] = m_1$ and $\mathbb{E}[z_2] = m_2$, we see that the two equations are satisﬁed if we take $\mathbb{E}[z_1] = \mu_1$ and $\mathbb{E}[z_2] = \mu_2$, and it is easily shown that this is the only solution provided the distribution is nonsingular. This result is illustrated in Figure 10.2(a). We see that the mean is correctly captured but that the variance of $q(\mathbf{z})$ is controlled by the direction of smallest variance of $p(\mathbf{z})$, and that the variance along the orthogonal direction is signiﬁcantly under-estimated. It is a general result that a factorized variational approximation tends to give approximations to the posterior distribution that are too compact.

By way of comparison, suppose instead that we had been minimizing the reverse Kullback-Leibler divergence $\text{KL}(p \| q)$. As we shall see, this form of KL divergence
