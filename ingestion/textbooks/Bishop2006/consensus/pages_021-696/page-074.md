[Page 74]

three constraints

$$
\int_{-\infty}^{\infty} p(x)\, dx = 1 \tag{1.105}
$$

$$
\int_{-\infty}^{\infty} x p(x)\, dx = \mu \tag{1.106}
$$

$$
\int_{-\infty}^{\infty} (x - \mu)^2 p(x)\, dx = \sigma^2. \tag{1.107}
$$

The constrained maximization can be performed using Lagrange multipliers so that we maximize the following functional with respect to $p(x)$:

$$
-\int_{-\infty}^{\infty} p(x)\ln p(x)\, dx + \lambda_1\left(\int_{-\infty}^{\infty} p(x)\, dx - 1\right) + \lambda_2\left(\int_{-\infty}^{\infty} x p(x)\, dx - \mu\right) + \lambda_3\left(\int_{-\infty}^{\infty} (x - \mu)^2 p(x)\, dx - \sigma^2\right).
$$

Using the calculus of variations, we set the derivative of this functional to zero giving

$$
p(x) = \exp\{-1 + \lambda_1 + \lambda_2 x + \lambda_3 (x - \mu)^2\}. \tag{1.108}
$$

The Lagrange multipliers can be found by back substitution of this result into the three constraint equations, leading ﬁnally to the result

$$
p(x) = \frac{1}{(2\pi\sigma^2)^{1/2}} \exp\left\{-\frac{(x - \mu)^2}{2\sigma^2}\right\}. \tag{1.109}
$$

and so the distribution that maximizes the differential entropy is the Gaussian. Note that we did not constrain the distribution to be nonnegative when we maximized the entropy. However, because the resulting distribution is indeed nonnegative, we see with hindsight that such a constraint is not necessary.

If we evaluate the differential entropy of the Gaussian, we obtain

$$
H[x] = \frac{1}{2}\left\{1 + \ln(2\pi\sigma^2)\right\}. \tag{1.110}
$$

Thus we see again that the entropy increases as the distribution becomes broader, i.e., as $\sigma^2$ increases. This result also shows that the differential entropy, unlike the discrete entropy, can be negative, because $H(x) < 0$ in (1.110) for $\sigma^2 < 1/(2\pi e)$.

Suppose we have a joint distribution $p(x, y)$ from which we draw pairs of values of $x$ and $y$. If a value of $x$ is already known, then the additional information needed to specify the corresponding value of $y$ is given by $-\ln p(y \mid x)$. Thus the average additional information needed to specify $y$ can be written as

$$
H[y \mid x] = -\iint p(y, x)\ln p(y \mid x)\, dy\, dx. \tag{1.111}
$$
