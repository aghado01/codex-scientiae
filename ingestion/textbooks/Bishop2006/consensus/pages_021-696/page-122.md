[Page 122]

Figure 2.14 Contour plot of the normal-gamma distribution (2.154) for parameter values $\mu_0 = 0$, $\beta = 2$, $a = 5$ and $b = 6$.

![The image consists of a diagram with a circular and a semi-circle. The diagram is labeled as h and h. The diagram is divided into two parts, labeled as h and h. The diagram is a circle with a diameter labeled as h. The diameter of the circle is marked as h. The diagram is divided into two parts, labeled as h and h. The diagram is a circle with a diameter labeled as h. The diameter of the circle is marked as h. The diagram is divided into two parts, labeled as h and h. The diagram is a circle with a diameter labeled as h. The diameter of the circle is marked as h. The diagram is divided into two parts, labeled as h and h. The diagram is a circle with a diameter labeled as h. The diameter of the circle is marked as h. The diagram is divided into two parts, labeled](../images/imageFile55.png)

In the case of the multivariate Gaussian distribution $\mathcal{N}(\mathbf{x} \mid \mu, \Lambda^{-1})$ for a $D$-dimensional variable $\mathbf{x}$, the conjugate prior distribution for the mean $\mu$, assuming the precision is known, is again a Gaussian. For known mean and unknown precision matrix $\Lambda$, the conjugate prior is the Wishart distribution given by

$$
\mathcal{W}(\Lambda \mid \mathbf{W}, \nu) = B |\Lambda|^{(\nu - D - 1)/2} \exp \left( -\frac{1}{2} \text{Tr}(\mathbf{W}^{-1} \Lambda) \right) \tag{2.155}
$$

where $\nu$ is called the number of degrees of freedom of the distribution, $\mathbf{W}$ is a $D \times D$ scale matrix, and $\text{Tr}(\cdot)$ denotes the trace. The normalization constant $B$ is given by

$$
B(\mathbf{W}, \nu) = |\mathbf{W}|^{-\nu/2} \left( 2^{\nu D / 2} \pi^{D(D-1)/4} \prod_{i=1}^{D} \Gamma \left( \frac{\nu + 1 - i}{2} \right) \right)^{-1}. \tag{2.156}
$$

Again, it is also possible to deﬁne a conjugate prior over the covariance matrix itself, rather than over the precision matrix, which leads to the inverse Wishart distribution, although we shall not discuss this further. If both the mean and the precision are unknown, then, following a similar line of reasoning to the univariate case, the conjugate prior is given by

$$
p(\mu, \Lambda \mid \mu_0, \beta, \mathbf{W}, \nu) = \mathcal{N}(\mu \mid \mu_0, (\beta\Lambda)^{-1}) \mathcal{W}(\Lambda \mid \mathbf{W}, \nu) \tag{2.157}
$$

which is known as the normal-Wishart or Gaussian-Wishart distribution.

### 2.3.7 Student’s t-distribution

We have seen that the conjugate prior for the precision of a Gaussian is given by a gamma distribution. If we have a univariate Gaussian $\mathcal{N}(x \mid \mu, \tau^{-1})$ together with a Gamma prior $\text{Gam}(\tau \mid a, b)$ and we integrate out the precision, we obtain the marginal distribution of $x$ in the form
