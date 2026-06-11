[Page 11]

$$
B = -\frac{1}{\sigma^2}\mathbb{E}\bigl\{\psi'(\varepsilon)(Z - h^*(X))(Z - h^*(X))^t\bigr\} \quad \text{and} \quad D = \frac{1}{\sigma^2}\mathbb{E}\bigl\{\psi^2(\varepsilon)(Z - h^*(X))(Z - h^*(X))^t\bigr\},
$$

we may consider estimating $\Sigma$ by $\hat{B}^{-1}\hat{D}(\hat{B}^{-1})^t$, where

$$
\hat{B} = -\frac{1}{n\hat{\sigma}^2}\sum_{i=1}^{n}\psi'(\hat{\varepsilon}_i)\{Z_i - \hat{h}^*(X_i)\}\{Z_i - \hat{h}^*(X_i)\}^t,
$$

$$
\hat{D} = \frac{1}{n\hat{\sigma}^2}\sum_{i=1}^{n}\psi^2(\hat{\varepsilon}_i)\{Z_i - \hat{h}^*(X_i)\}\{Z_i - \hat{h}^*(X_i)\}^t.
$$

Note that, when considering the bisquare function, this estimator automatically down-weights the effect of bad leverage covariates, since in such case both $\psi'(\hat{\varepsilon}_i)$ and $\psi^2(\hat{\varepsilon}_i)$ will be 0 for large values of the residuals.

Taking into account N3, one may estimate $h^*(x)$ using additive B-splines, that is, for each $1 \leq m \leq q$ and $1 \leq j \leq p$, the elements of $S_j$ defined in (12) may be used to provide an appropriate estimator. Hence, noting that $h^*(x)$ minimizes $\mathbb{E}\|Z - h^*(X)\|^2$ over the space of $q$-dimensional measurable functions and that $h_{mj}^* \in \mathcal{H}_{r_j} \cap \mathcal{G}$, the initial attempt is to consider the quantity

$$
\Upsilon(a, \xi) = \sum_{i=1}^{n} \|Z_i - h^*_{a,\xi}(X_i)\|^2,
$$

where $\xi = (\xi_1^t, \ldots, \xi_q^t)^t$, $h^*_{a,\xi}(x) = (h^*_{a_1,\xi_1}(x), \ldots, h^*_{a_q,\xi_q}(x))^t$ with $\xi_m = (\xi_{(m,1)}^t, \ldots, \xi_{(m,p)}^t)^t$, $\xi_{(m,j)} = (\xi_{(m,j)1}, \ldots, \xi_{(m,j)k_j-1})^t$ and $h^*_{a_m,\xi_m}(x) = a_m + \sum_{j=1}^{p}\sum_{s=1}^{k_j-1}\xi_{(m,j)s} B_s^{(j)}(x_j)$. An estimator $\hat{h}^*(x) = (\hat{h}_1^*(x), \ldots, \hat{h}_q^*(x))^t$ of $h^*(x)$ can be defined as $\hat{h}^*(x) = h^*_{\hat{\phi},\hat{\xi}}(x)$, where the vectors $\hat{\phi}$ and $\hat{\xi}$ minimize $\Upsilon(a, \xi)$ over $a = (a_1, \ldots, a_q)^t$ and $\xi$. However, even when this estimator is appropriate when no outliers arise in the covariates related to the linear component of the model, it will not be resistant when high-leverage points are present. A possible solution to this problem is discussed below and uses also an MM-approach.

A first attempt to solve the lack of robustness of the estimator that minimizes $\Upsilon(a, \xi)$ is to mimic the arguments considered in the construction of $\hat{A}$ and to define $\hat{h}^*$ minimizing a weighted version of $\Upsilon(a, \xi)$ with weights $\{w_i\}_{i=1}^n$. However, even though this proposal will control the effect of bad leverage points providing consistent estimators of $h^*$, good leverage points will still influence the estimation, producing small values of $Z_i - \hat{h}^*(X_i)$ for these observations, in detriment to the other observations that will see their covariate residual $r_{i,Z}$ increased. For that reason, in order to provide a proper estimator of $h^*$, we will further assume that a model relates $Z_m$ with the covariates $X_1, \ldots, X_p$. From now on, we assume that $Z_{im} = \phi_m + \sum_{j=1}^{p} h_{mj}^*(X_{ij}) + \sigma_m u_{im}$, where $u_{im} \sim F_m(\cdot)$ are independent from $X_i$ and independent from each other, for $1 \leq i \leq n$, $\sigma_m > 0$ is the scale parameter and $F_m$ is symmetric around 0 with scale 1. A procedure similar to the one described in Section 2 can be implemented as follows leading to uniform consistent estimators. For that purpose, for $1 \leq m \leq q$, define $r_{i,m}(a, \xi_m) = Z_{i,m} - a - \sum_{j=1}^{p}\sum_{s=1}^{k_j-1}\xi_{(m,j)s} B_s^{(j)}(X_{ij}) = Z_{i,m} - h^*_{a,\xi_m}(X_i)$, where for the sake of simplicity we have assumed that the same bases are used for each component $Z_m$ of $Z$.

For each $1 \leq m \leq q$, we consider a preliminary robust S-estimator $\tilde{\sigma}_m$ computed with loss function $\rho_0$, that is, we define $\tilde{\sigma}_m = s_{n,m}(\tilde{\phi}_m, \tilde{\xi}_m)$ where $s_{n,m}(\tilde{\phi}_m, \tilde{\xi}_m)$ minimizes over $(a, \xi_m)$ the solution $s_{n,m}(a, \xi_m)$ of

$$
\frac{1}{n - K}\sum_{i=1}^{n}\rho_0\!\left(\frac{r_{i,m}(a, \xi_m)}{s_{n,m}(a, \xi_m)}\right) = b.
$$

Let $\rho_1$ be such that $\rho_1 \leq \rho_0$. The M-estimator of $h^*$ is then obtained as $\hat{h}^*(x) = h^*_{\hat{\phi},\hat{\xi}}(x)$, where

$$
(\hat{\phi}, \hat{\xi}) = \arg\min_{a \in \mathbb{R}^q,\, \xi} \sum_{m=1}^{q}\sum_{i=1}^{n}\rho_1\!\left(\frac{r_{i,m}(a_m, \xi_m)}{\tilde{\sigma}_m}\right).
\tag{18}
$$

Note that, for each $m$, $(\hat{\phi}_m, \hat{\xi}_m)$ can be obtained minimizing the quantity $\sum_{i=1}^{n}\rho_1\bigl(r_{i,m}(a_m, \xi_m)/\tilde{\sigma}_m\bigr)$.

## 5. Monte Carlo Study

This section contains the results of a simulation study conducted to compare, under different models and contamination schemes, the performance of the robust MM-estimators defined in Section 2 with two competitors. All computations were carried out in R. The code is available at https://github.com/alemermartinez/rplam. The classical counterpart of the MM-estimator corresponds to a linear regression least squares estimator after the B-splines approximation was performed for each additive component. For the robust MM-estimator, we considered as loss functions $\rho_0$ and $\rho_1$ the Tukey's bisquare function with tuning constants $c_0$ and $c_1$, respectively. More precisely, for the initial S-estimators, we choose $c_0 = 1.54764$
