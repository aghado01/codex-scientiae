[Page 120]

![The image consists of three different diagrams, each with a red line. The line in each diagram is a straight line, and the points on the line are labeled as follows: 1. **Diagram 1**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is located at the top of the line. - Point D is located at the top of the line. 2. **Diagram 2**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is located at the top of the line. - Point D is located at the top of the line. 3. **Diagram 3**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is](../images/imageFile54.png)

Figure 2.13 Plot of the gamma distribution $\text{Gam}(\lambda \mid a, b)$ defined by (2.146) for various values of the parameters $a$ and $b$.

The corresponding conjugate prior should therefore be proportional to the product of a power of $\lambda$ and the exponential of a linear function of $\lambda$. This corresponds to the gamma distribution which is defined by

$$
\text{Gam}(\lambda \mid a, b) = \frac{1}{\Gamma(a)} b^a \lambda^{a-1} \exp(-b\lambda). \tag{2.146}
$$

Here $\Gamma(a)$ is the gamma function that is defined by (1.141) and that ensures that (2.146) is correctly normalized. The gamma distribution has a finite integral if $a > 0$, and the distribution itself is finite if $a \ge 1$. It is plotted, for various values of $a$ and $b$, in Figure 2.13. The mean and variance of the gamma distribution are given by

$$
\mathbb{E}[\lambda] = \frac{a}{b} \tag{2.147}
$$

$$
\text{var}[\lambda] = \frac{a}{b^2}. \tag{2.148}
$$

Consider a prior distribution $\text{Gam}(\lambda \mid a_0, b_0)$. If we multiply by the likelihood function (2.145), then we obtain a posterior distribution

$$
p(\lambda \mid X) \propto \lambda^{a_0-1} \lambda^{N/2} \exp \left\{ -b_0\lambda - \frac{\lambda}{2} \sum_{n=1}^{N} (x_n - \mu)^2 \right\} \tag{2.149}
$$

which we recognize as a gamma distribution of the form $\text{Gam}(\lambda \mid a_N, b_N)$ where

$$
a_N = a_0 + \frac{N}{2} \tag{2.150}
$$

$$
b_N = b_0 + \frac{1}{2} \sum_{n=1}^{N} (x_n - \mu)^2 = b_0 + \frac{N}{2} \sigma_{ML}^2 \tag{2.151}
$$

where $\sigma_{ML}^2$ is the maximum likelihood estimator of the variance. Note that in (2.149) there is no need to keep track of the normalization constants in the prior and the likelihood function because, if required, the correct coefficient can be found at the end using the normalized form (2.146) for the gamma distribution.
