[Page 12]

This integral is complicated, and we approximate it using the Laplace method. This involves fitting a scaled normal density to the integrand. Specifically, if we wish to evaluate $\int h(\theta)\,d\theta$, we assume that $h(\theta) \approx h(\hat{\theta})\exp\!\left(-\frac{(\theta - \hat{\theta})^2}{2\hat{\sigma}^2}\right)$, where $\hat{\theta}$ is the mode of $h(\theta)$ and $\hat{\sigma}^2$ is the estimate of the variance of the normal density. A good estimate of the mode, $\hat{\theta}$, can be obtained with a numerical search algorithm. The variance can be estimated by noting that $h(\hat{\theta})/h(\hat{\theta} + \varepsilon) \approx \exp(\varepsilon^2 / 2\hat{\sigma}^2)$. We evaluate $h$ at $(\hat{\theta} + \varepsilon)$ and $(\hat{\theta} - \varepsilon)$ and average the two resulting estimates of $\sigma^2$ to get $\hat{\sigma}^2$. The integral is then approximated by $(2\pi)^{1/2}(\hat{\sigma})^{1/2}h(\hat{\theta})$. For additional information on the Laplace method and other methods for Bayes factor approximation, see DiCiccio et al. (1997).

Since the integral we want to approximate is defined over $\mathbb{R}_+$ and the normal distribution is defined over the entire real line, we will transform $\delta_{k^*}$. Simulations show that this has the added benefit of making the integrand more symmetric. Let $\omega = \log(\delta_{k^*})$ and note that the prior on $\omega_{k^*}$ is:

$$
\pi(\omega_{k^*}) = \frac{e^{a_\delta \omega - b_\delta e^\omega}\,b_\delta^{a_\delta}}{\Gamma(a_\delta)}
$$

The integral in (7) can be written:

$$
p(y \mid M^*, \delta, \lambda)
= \int p(y, \omega \mid M^*, \delta, \lambda)\,d\omega
= \int_{-\infty}^{\infty} p(y \mid M^*, \delta, \omega, \lambda)\,\pi(\omega)\,d\omega
$$

$$
= \frac{C(\lambda, k^*)}{\Gamma(a_\delta)}\prod_{l=1}^k \delta_l
\int_{-\infty}^{\infty} e^{(1+a_\delta)\omega - b_\delta e^\omega}
|R^*|^{-1/2}\!\left(b_\tau + \frac{\alpha^*}{2}\right)^{-(n/2+a_\tau)}
\prod_{i=1}^m |U_i^*|^{1/2}\,d\omega
$$

Similarly, a basis removal proposal involves integrating out the element of $\delta$ corresponding to the basis proposed for removal. A proposal to alter a basis involves integrating out the element of $\delta$ corresponding to that basis in both the numerator and the denominator.
