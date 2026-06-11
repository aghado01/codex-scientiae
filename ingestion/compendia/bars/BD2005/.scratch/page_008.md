[Page 8]

The mean and variance can vary flexibly with the covariates and relative to each other. The elements of $\beta$ can be positive or negative, large or small, and the elements of $\delta$ can also be large or small. A given basis could contribute substantially to the mean and negligibly to the variance (i.e. $\beta_l$ and $\delta_l$ are both large), or vice versa, so that the mean and variance of the response at a given set of covariates are not constrained to vary together.

### 2.2 Posterior Computation

At each iteration, we obtain a piecewise linear model for which the parameters can be sampled directly from their full conditionals as derived from the priors and the likelihood following standard algebraic routes. Omitting details, we obtain the following full conditional posterior distributions, where a $\mathrm{Gamma}(a, b)$ random variable is parameterized to have expected value $a/b$ and variance $a/b^2$:

$$
\begin{aligned}
\beta \mid b, \delta, \lambda, \tau &\sim N_k\!\left([\lambda I_k + m\Delta]^{-1}\Delta\sum_{i=1}^m b_i,\; \tau^{-1}[\lambda I_k + m\Delta]^{-1}\right) \\
b_i \mid \beta, \delta, \lambda, \tau &\sim N_k\!\left([\theta_i'\theta_i + \Delta]^{-1}[\theta_i'y_i + \Delta\beta],\; \tau^{-1}[\theta_i'\theta_i + \Delta]^{-1}\right), \quad i = 1,\dots,m \\
\tau \mid \beta, b, \delta, \lambda &\sim \mathrm{Gamma}\!\left(a_\tau + \tfrac{(m+1)k + n}{2},\; b_\tau + \tfrac{1}{2}\Bigl[\sum_{i=1}^m (b_i-\beta)'\Delta(b_i-\beta) + \sum_{i=1}^m (y_i-\theta_i b_i)'(y_i-\theta_i b_i) + \lambda\beta'\beta\Bigr]\right) \\
\lambda \mid \beta, b, \delta, \tau &\sim \mathrm{Gamma}\!\left(a_\lambda + \tfrac{k}{2},\; b_\lambda + \tfrac{\beta'\beta}{2}\right) \\
\delta_l \mid \beta, b, \delta_{-l}, \lambda, \tau &\sim \mathrm{Gamma}\!\left(a_\delta + \tfrac{m}{2},\; b_\delta + \tfrac{\tau}{2}\sum_{i=1}^m (b_{il} - \beta_l)^2\right), \quad l = 1,\dots,k
\end{aligned}
$$

The following is a description of the RJMCMC algorithm we employed.

Step 0: Initialize the model to the intercept-only basis function, where $k = 1$.
