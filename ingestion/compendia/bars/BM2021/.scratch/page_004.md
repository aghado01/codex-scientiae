[Page 4]

For given values $a \in \mathbb{R}$, $b \in \mathbb{R}^q$ and $\lambda^{(j)} \in \mathbb{R}^{k_j}$, the classical least squares estimator is obtained minimizing $\sum_{i=1}^{n} \bigl(Y_i - a - b^t Z_i - \sum_{j=1}^{p} \sum_{s=1}^{k_j} \lambda_s^{(j)} \tilde{B}_s^{(j)}(X_{ij})\bigr)^2$. However, the design matrix for this problem is ill conditioned, even when $p = 1$. Effectively, taking into account that $\sum_{s=1}^{k_j} \tilde{B}_s^{(j)}(x) = 0$ for all $x \in I_j$, we may rewrite the approximation as

$$
\sum_{s=1}^{k_j} \lambda_s^{(j)} \tilde{B}_s^{(j)}(x) = \sum_{s=1}^{k_j - 1} \left(\lambda_s^{(j)} - \lambda_{k_j}^{(j)}\right) \tilde{B}_s^{(j)}(x)
$$

From now on, we denote $K = \sum_{j=1}^{p} k_j - p$ the effective dimension of the considered space used to approximate the nonparametric additive components. Furthermore, define $c^{(j)} = (c_1^{(j)}, \ldots, c_{k_j-1}^{(j)})^t \in \mathbb{R}^{k_j - 1}$ with $c_s^{(j)} = \lambda_s^{(j)} - \lambda_{k_j}^{(j)}$ and, for $1 \leq i \leq n$, the residuals as

$$
r_i(a, b, c) = r_i(a, b, c^{(1)}, \dots, c^{(p)}) = Y_i - a - b^T Z_i - \sum_{j=1}^{p} \sum_{s=1}^{k_j - 1} c_s^{(j)} \tilde{B}_s^{(j)}(X_{ij}) = Y_i - a - b^T Z_i - c^T V_i,
\tag{3}
$$

where $c = (c^{(1)t}, \ldots, c^{(p)t})^t \in \mathbb{R}^K$, $V_i = (V^{(1)}(X_{i1})^t, \ldots, V^{(p)}(X_{ip})^t)^t$ and $V^{(j)}(t) = (\tilde{B}_1^{(j)}(t), \ldots, \tilde{B}_{k_j-1}^{(j)}(t))^t$, for $1 \leq j \leq p$. With this parametrization the design matrix is now well conditioned.

### 2.2. The Robust MM-Estimators

In what follows the loss functions $\rho_0$ and $\rho_1$ to be considered below will be bounded $\rho$-functions as defined in Maronna et al. (2019), so $\|\rho_0\|_\infty = \|\rho_1\|_\infty = 1$ (see assumption C1(a)). A widely used family of bounded $\rho$-functions is the Tukey's bisquare function which is of the form $\rho_{t,c}(t) = \rho_t(t/c)$ where $\rho_t(t) = \min\{1 - (1 - t^2)^3, 1\}$, that is, $\rho_{t,c}(t) = \min\{1 - (1 - (t/c)^2)^3, 1\}$. The tuning constant $c > 0$ balances the robustness and efficiency properties of the associated estimators.

To define the robust estimators, as in linear regression, we first compute an S-estimator using $\rho_0$. This preliminary estimator will allow to compute the initial scale estimator. For that purpose, let $s_n(a, b, c)$ be the M-scale estimator of the residuals related to $\rho_0$, that is, $s_n(a, b, c)$ is the solution on $s$ of the implicit equation

$$
\frac{1}{n - q - K}\sum_{i=1}^{n} \rho_0\!\left(\frac{r_i(a, b, c)}{s_n(a, b, c)}\right) = b,
\tag{4}
$$

where $0 < b < 1$. Since $\|\rho_0\|_\infty = 1$, the breakdown point of the M-scale estimator is $\min(b, 1-b)$. For that reason, $b = 1/2$ is chosen to obtain a 50% breakdown point for the scale estimator. Furthermore, to guarantee Fisher–consistency, we need that $b = E(\rho_0(\varepsilon))$. As mentioned in Maronna et al. (2019), typically the function $\rho_0$ depends on a tuning constant $c_0$, that is, $\rho_0(t) = \rho(t/c_0)$ with $\rho$ a $\rho$-function and $c_0 > 0$. In linear regression models, the constant $c_0$ is numerically selected by the user to guarantee Fisher–consistency at a given distribution for a chosen breakdown point. For instance, when $\rho_0$ is the bisquare function, we may choose the tuning constant $c_0 = 1.54764$ to ensure Fisher–consistency when $\varepsilon \sim N(0, 1)$ and breakdown point $b = 1/2$. As described in Maronna et al. (2019), we divide by $n - q - K$ instead of by $n$ in (4) to reduce the effect of a large dimension $K$ relative to the sample size.

The initial S-estimators are defined as the minimizers of $s_n(a, b, c)$, that is, $\hat{\eta}_{j,\mathrm{ini}}(x) = \sum_{s=1}^{k_j-1} \hat{c}_s^{(j)}{}_{\mathrm{ini}} \tilde{B}_s^{(j)}(x)$ where $\hat{c}_{\mathrm{ini}} = (\hat{c}^{(1)t}_{\mathrm{ini}}, \ldots, \hat{c}^{(p)t}_{\mathrm{ini}})^t$ and $(\hat{\mu}_{\mathrm{ini}}, \hat{\beta}_{\mathrm{ini}}, \hat{c}_{\mathrm{ini}}) = \arg\min_{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, c \in \mathbb{R}^K} s_n(a, b, c)$. The residual scale estimator equals

$$
\hat{\sigma} = s_n(\hat{\mu}_{\mathrm{ini}}, \hat{\beta}_{\mathrm{ini}}, \hat{c}_{\mathrm{ini}}).
\tag{5}
$$

As in linear regression, the initial S-estimators may be obtained combining subsampling and iterative reweighted least squares as described in Sections 5.7.1 to 5.7.3 of Maronna et al. (2019). To define the final M-estimator, consider a $\rho$-function $\rho_1$ satisfying $\rho_1 \leq \rho_0$ and $\sup_t \rho_1(t) = \sup_t \rho_0(t)$.
