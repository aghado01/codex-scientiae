[Page 148]

Use this result to prove by induction the following result
$$
(1 + x)^N = \sum_{m=0}^N \binom{N}{m} x^m \tag{2.263}
$$
which is known as the binomial theorem, and which is valid for all real values of $x$. Finally, show that the binomial distribution is normalized, so that
$$
\sum_{m=0}^N \binom{N}{m} \mu^m (1 - \mu)^{N-m} = 1 \tag{2.264}
$$
which can be done by first pulling out a factor $(1 - \mu)^N$ out of the summation and then making use of the binomial theorem.

2.4 ($\star$) Show that the mean of the binomial distribution is given by (2.11). To do this, differentiate both sides of the normalization condition (2.264) with respect to $\mu$ and then rearrange to obtain an expression for the mean of $n$. Similarly, by differentiating (2.264) twice with respect to $\mu$ and making use of the result (2.11) for the mean of the binomial distribution prove the result (2.12) for the variance of the binomial.

2.5 ($\star$) www In this exercise, we prove that the beta distribution, given by (2.13), is correctly normalized, so that (2.14) holds. This is equivalent to showing that
$$
\int_0^1 \mu^{a-1} (1 - \mu)^{b-1} d\mu = \frac{\Gamma(a)\Gamma(b)}{\Gamma(a + b)}. \tag{2.265}
$$

From the definition (1.141) of the gamma function, we have
$$
\Gamma(a)\Gamma(b) = \int_0^\infty \exp(-x) x^{a-1} dx \int_0^\infty \exp(-y) y^{b-1} dy. \tag{2.266}
$$
Use this expression to prove (2.265) as follows. First bring the integral over $y$ inside the integrand of the integral over $x$, next make the change of variable $t = y + x$ where $x$ is fixed, then interchange the order of the $x$ and $t$ integrations, and finally make the change of variable $x = t\mu$ where $t$ is fixed.

2.6 ($\star$) Make use of the result (2.265) to show that the mean, variance, and mode of the beta distribution (2.13) are given respectively by
$$
\mathbb{E}[\mu] = \frac{a}{a + b} \tag{2.267}
$$
$$
\text{var}[\mu] = \frac{ab}{(a + b)^2(a + b + 1)} \tag{2.268}
$$
$$
\text{mode}[\mu] = \frac{a - 1}{a + b - 2}. \tag{2.269}
$$
