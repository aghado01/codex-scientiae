[Page 11]

$$
C(\lambda, k) = \frac{b_\tau^{a_\tau}\,\lambda^{k/2}\,\Gamma(n/2 + a_\tau)}{\Gamma(a_\tau)\,(2\pi)^{n/2}}
$$

In a similar fashion, we can write the marginal likelihood for a proposed model $M^*$ of dimension $k^*$:

$$
p(y \mid M^*, \delta^*, \lambda^*) = C(\lambda^*, k^*)\,|R^*|^{-1/2}\!\left(b_\tau + \frac{\alpha^*}{2}\right)^{-(n/2+a_\tau)}\prod_{l=1}^{k^*} \delta_l^{m/2}\prod_{i=1}^m |U_i^*|^{1/2} \tag{6}
$$

Suppose we propose a move from model $M$ of dimension $k$ to model $M^*$ of dimension $k^*$. If we let the acceptance probability be the ratio of the two marginal likelihoods, then it depends on $\lambda$ and $\delta$. It also depends on $\lambda^*$ and $\delta^*$, for which we do not have estimates. Since we wish to accept or reject a model based only on its set of basis functions, we want to minimize the effects of these variance components on the acceptance probability. Specifically, we assume $\lambda = \lambda^*$ at the current sampled value. Since $\delta^*$ and $\delta$ may be of different dimensions, we cannot assume that they are equal. Instead, we assume that they are equal in the elements corresponding to bases common to both models and condition only on those elements.

Consider a proposal to add a basis to the current model. The current model is nested in the proposed model, and the proposed model has exactly one more basis than the current model. The acceptance probability is:

$$
Q = \min\!\left[1,\; \frac{p(y \mid M^*, \lambda, \delta)}{p(y \mid M, \lambda, \delta)}\right]
$$

The denominator has closed form, as we have shown above, and the numerator can be derived as follows, where $\delta^* = (\delta, \delta_{k^*})$:

$$
p(y \mid M^*, \lambda, \delta)
= \int p(y, \delta_{k^*} \mid M^*, \delta, \lambda)\,d\delta_{k^*}
= \int p(y \mid M^*, \delta^*, \lambda)\,\pi(\delta_{k^*})\,d\delta_{k^*}
$$

$$
= \frac{C(\lambda, k^*)}{\Gamma(a_\delta)}\prod_{l=1}^k \delta_l
\int_0^\infty |R^*|^{-1/2}\!\left(b_\tau + \frac{\alpha^*}{2}\right)^{-(n/2+a_\tau)}
\delta_{k^*}^{a_\delta} e^{-b_\delta \delta_{k^*}}\prod_{i=1}^m |U_i^*|^{1/2}\,d\delta_{k^*}. \tag{7}
$$
