[Page 5]

For $1 \leq j \leq p$, the robust estimator of the additive function $\eta_j$ is then given by

$$
(\hat{\mu}, \hat{\beta}, \hat{c}) = \arg\min_{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, c \in \mathbb{R}^K} \sum_{i=1}^{n} \rho_1\!\left(\frac{r_i(a, b, c)}{\hat{\sigma}}\right),
\tag{6}
$$

$$
\hat{\eta}_j(x) = \sum_{s=1}^{k_j - 1} \hat{c}_s^{(j)} \tilde{B}_s^{(j)}(x),
\tag{7}
$$

where $\hat{c} = (\hat{c}^{(1)t}, \ldots, \hat{c}^{(p)t})^t$ and $\hat{c}^{(j)} = (\hat{c}_1^{(j)}, \ldots, \hat{c}_{k_j-1}^{(j)})^t$. Finally, the estimator of the multivariate regression function is defined as $\hat{m}(z, x) = \hat{\mu} + \hat{\beta}^t z + \sum_{j=1}^{p} \hat{\eta}_j(x_j)$, for any $z \in \mathbb{R}^q$ and $x = (x_1, \ldots, x_p)^t$.

Summarizing, our estimators may be implemented as follows.

**Step 1.** For $j = 1, \ldots, p$:

- (a) Fix the spline order $\ell_j$, the number of interior knots $N_{n,j}$ and their location $T_j$.
- (b) Construct the B-spline basis functions $\{B_s^{(j)} : 1 \leq s \leq k_j\}$ corresponding to the knots $T_j$, where $k_j = N_{n,j} + \ell_j$.
- (c) Define the centered basis $\tilde{B}_s^{(j)}(x) = B_s^{(j)}(x) - \int_{I_j} B_s^{(j)}(x)\,dx$, $s = 1, \ldots, k_j$.
- (d) Keep only the first $k_j - 1$ elements of the basis, that is, $\{\tilde{B}_s^{(j)}(x) : 1 \leq s \leq k_j - 1\}$, and define $V^{(j)}(t) = (\tilde{B}_1^{(j)}(t), \ldots, \tilde{B}_{k_j-1}^{(j)}(t))^t$.

**Step 2.**

- (a) Let $V_i = (V^{(1)}(X_{i1})^t, \ldots, V^{(p)}(X_{ip})^t)^t$.
- (b) Define the vector $W_i = (Z_i^t, V_i^t)^t$ and $r_i(a, b, c) = Y_i - a - b^t Z_i - c^t V_i$.

**Step 3.** Choose a bounded $\rho$-function $\rho_0$.

- (a) Compute the M-scale of the residuals $r_i(a, b, c)$, $1 \leq i \leq n$, related to $\rho_0$, as defined in (4) and denote it $s_n(a, b, c)$.
- (b) Minimize the scale $s_n(a, b, c)$ to obtain the scale estimator $\hat{\sigma}$ as its minimum value.

**Step 4.** Choose $\rho_1$ such that $\rho_1 \leq \rho_0$ and $\sup_t \rho_1(t) = \sup_t \rho_0(t)$. Using $\rho_1$, compute an M-estimator $(\hat{\mu}, \hat{\beta}, \hat{c})$ with preliminary scale estimator $\hat{\sigma}$, as defined in (6). The estimators of the additive components are then obtained using the coefficients $\hat{c}$ through (7).

With respect to the numerical implementation of our proposal, once the centered B-spline $\{\tilde{B}_s^{(j)}(x)\}_{s=1}^{k_j-1}$ are obtained in Step 1, for $j = 1, \ldots, p$, and the pseudo-covariates $V_i$ are computed as described in Step 2, the estimators in Step 4 may be easily obtained using the function `lmrob` of the library `robustbase` in R which returns the estimated coefficients $\hat{\mu}$, $\hat{\beta}$ and $\hat{c}$ as well as the scale estimator $\hat{\sigma}$ from Step 3.

As mentioned above, once the centered B-spline bases are constructed, our proposal is obtained using MM-regression estimators. For that reason, if the basis dimensions $k_j$, $1 \leq j \leq p$, are known and fixed, our proposal leads to estimators of $\beta$ resistant to high-leverage outliers and with high breakdown point, see Yohai (1987) and Maronna et al. (2019). However, in practice, the number of elements of the basis $k_j$ is chosen from the data, for instance, using a robust BIC criterion as the one described in Section 2.3. The breakdown point of the proposed B-spline MM-estimator when the dimension is data-driven is beyond the scope of the paper and this interesting topic may be object of future work.

### 2.3. Selection of $k_j$

To implement the proposed B-spline MM-estimators, the selection of the knot sequence to be used when estimating the $j$-th additive component is an important topic. Clearly, knot selection is more relevant when estimating $\eta_j$ than for the estimators of $\beta$. As mentioned by Stone (1985), the number of knots is more crucial than their location and for that reason we discuss below an approach to select the number of interior knots $N_{n,j}$ or, equivalently, the basis dimension $k_j$, using a robust BIC criterion. Regarding the knots location, equally spaced knots or quantile knots are two possible choices. Uniform knots are usually used when the function $\eta_j$ does not exhibit dramatic changes in its derivatives. In contrast, non–uniform knots are desirable when the function has very different local behaviors in different regions. A commonly used approach in this last situation is to consider quantile knots, that is, the quantiles of the observed explanatory variables $X_{ij}$, $1 \leq i \leq n$, with uniform percentile ranks.

The number of elements of the basis $k_j$ which approximates each additive function may be determined by a model selection criterion. However, it is well known that, to ensure robustness properties of the final estimator, a robust criterion is needed. As in He et al. (2002), a robust BIC criterion may be defined as follows

$$
\mathrm{RBIC}(k) = \log\!\left(\hat{\sigma}^2 \sum_{i=1}^{n} \rho_1\!\left(\frac{r_i}{\tilde{\sigma}}\right)\right) + \frac{\log(n)}{2n}\sum_{j=1}^{p} k_j,
\tag{8}
$$
