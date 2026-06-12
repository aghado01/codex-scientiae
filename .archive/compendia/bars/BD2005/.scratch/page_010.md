[Page 10]

**Step 4:** Update $\{b_i\}$, $\beta$, $\tau$, $\delta$, and $\lambda$ from their full conditionals.

Repeat steps 1–4 for a large number of iterations, collecting samples after a burn-in to allow convergence.

A challenging aspect of the algorithm is comparing models in the RJMCMC sampler. Our prior assigns equal probability to all piecewise linear models and model proposal is based on generation of discrete random variables. Under this scenario, the probability, $Q$, of accepting a proposed model, $M^*$, is the Bayes factor comparing it to the current model, $M$ (Holmes and Mallick, 2003; Denison et al., 2002). The Bayes factor is the ratio of the marginal likelihoods of the data under the two models:

$$
Q = \min\!\left[1,\; \frac{p(y \mid M^*)}{p(y \mid M)}\right].
$$

The marginal likelihoods and thus the Bayes factor for this hierarchical model have no closed form. Consider instead the following marginal likelihood under model $M$:

$$
p(y \mid M, \delta, \lambda) = \int\!\!\int\!\!\int L(y \mid b, \tau, \lambda, M)\,p(b, \tau, \beta \mid \delta, \lambda, M)\,db\,d\beta\,d\tau,
$$

where $p(y \mid \beta, b, \tau, \delta, \lambda, M)$ is the data likelihood under model $M$, and $p(b, \tau, \beta \mid \delta, \lambda, M)$ is the joint prior of $b$, $\beta$, and $\tau$ under model $M$. This integral has a closed form, so the likelihood can be written as follows, where

$$
p(y \mid M, \delta, \lambda) = C(\lambda, k)\,|R|^{-1/2}\!\left(b_\tau + \frac{\alpha}{2}\right)^{-(n/2+a_\tau)}\prod_{l=1}^k \delta_l^{m/2}\prod_{i=1}^m |U_i|^{1/2}, \tag{5}
$$

$$
U_i = [\Delta + \theta_i'\theta_i]^{-1},
$$

$$
R = \lambda I_k + m\Delta - \Delta\!\left(\sum_{i=1}^m U_i\right)\!\Delta,
$$

$$
\alpha = y'y - \sum_{i=1}^m y_i'\theta_i U_i\theta_i'y_i - \left(\sum_{i=1}^m U_i\theta_i'y_i\right)'\!\Delta R^{-1}\Delta\!\left(\sum_{i=1}^m U_i\theta_i'y_i\right).
$$
