[Page 139]

an interval $A \le \mu \le B$ as to the shifted interval $A - c \le \mu \le B - c$. This implies

$$
\int_{A}^{B} p(\mu) \, d\mu = \int_{A-c}^{B-c} p(\mu) \, d\mu = \int_{A}^{B} p(\mu-c) \, d\mu \tag{2.234}
$$

and because this must hold for all choices of $A$ and $B$, we have

$$
p(\mu-c) = p(\mu) \tag{2.235}
$$

which implies that $p(\mu)$ is constant. An example of a location parameter would be the mean $\mu$ of a Gaussian distribution. As we have seen, the conjugate prior distribution for $\mu$ in this case is a Gaussian $p(\mu|\mu_0, \sigma_0^2) = \mathcal{N}(\mu|\mu_0, \sigma_0^2)$, and we obtain a noninformative prior by taking the limit $\sigma_0^2 \to \infty$. Indeed, from (2.141) and (2.142) we see that this gives a posterior distribution over $\mu$ in which the contributions from the prior vanish.

As a second example, consider a density of the form

$$
p(x|\sigma) = \frac{1}{\sigma} f \left( \frac{x}{\sigma} \right) \tag{2.236}
$$

where $\sigma > 0$. Note that this will be a normalized density provided $f(x)$ is correctly normalized. The parameter $\sigma$ is known as a scale parameter, and the density exhibits scale invariance because if we scale $x$ by a constant to give $\widehat{x} = cx$, then

$$
p(\widehat{x}|\widehat{\sigma}) = \frac{1}{\widehat{\sigma}} f \left( \frac{\widehat{x}}{\widehat{\sigma}} \right) \tag{2.237}
$$

where we have defined $\widehat{\sigma} = c\sigma$. This transformation corresponds to a change of scale, for example from meters to kilometers if $x$ is a length, and we would like to choose a prior distribution that reflects this scale invariance. If we consider an interval $A \le \sigma \le B$, and a scaled interval $A/c \le \sigma \le B/c$, then the prior should assign equal probability mass to these two intervals. Thus we have

$$
\int_{A}^{B} p(\sigma) \, d\sigma = \int_{A/c}^{B/c} p(\sigma) \, d\sigma = \int_{A}^{B} p \left( \frac{1}{c}\sigma \right) \frac{1}{c} \, d\sigma \tag{2.238}
$$

and because this must hold for choices of $A$ and $B$, we have

$$
p(\sigma) = p \left( \frac{1}{c}\sigma \right) \frac{1}{c} \tag{2.239}
$$

and hence $p(\sigma) \propto 1/\sigma$. Note that again this is an improper prior because the integral of the distribution over $0 \le \sigma \le \infty$ is divergent. It is sometimes also convenient to think of the prior distribution for a scale parameter in terms of the density of the log of the parameter. Using the transformation rule (1.27) for densities we see that $p(\ln \sigma) = \text{const}$. Thus, for this prior there is the same probability mass in the range $1 \le \sigma \le 10$ as in the range $10 \le \sigma \le 100$ and in $100 \le \sigma \le 1000$.
