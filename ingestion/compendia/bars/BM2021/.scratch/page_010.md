[Page 10]

**Remark 4.1.** Condition N1 prevents any element of $Z$ from being a.s. perfectly predictable by $X$ since, in this case, the model would be fully nonparametric. Moreover, it is a standard requirement in robust regression to obtain $\sqrt{n}$ estimators of the linear components. Assumption N1 together with N3 entail that $Z$ should not be perfectly predictable by a linear combination of the components of $X$. Note that the additive structure required in assumption N3 is satisfied if, for instance, $Z$ and $X$ are independent, in which case $h_{mj}^* \equiv 0$, or if each covariate $Z_m$ of $Z$ depends only on one covariate $X_j$ of $X$. The smoothness requirement in assumption N3 was also a condition in assumption (A8) in Ma and Yang (2011). Finally, it should be noticed that the rates of convergence required in N2 may be obtained from Theorem 3.3.

From now on, without loss of generality by eventually modifying $\mu$, we will assume that the parameter $\phi_m$ in N3 equals 0, so we have that $h_m^*(x) = \sum_{j=1}^{p} h_{mj}^*(x_j)$.

**Theorem 4.1.** Assume that $\rho_1$ satisfies C1 and that $\psi_1 = \rho_1'$ is twice continuously differentiable with bounded derivative and that C2 to C5 and N1 to N3 hold. Then, $\sqrt{n}(\hat{\beta} - \beta) \xrightarrow{D} N(0, \Sigma(\theta, \sigma))$, where

$$
\Sigma(\theta, \sigma) = \sigma^2 \frac{\mathbb{E}[\psi^2(\varepsilon)]}{\{\mathbb{E}[\psi'(\varepsilon)]\}^2} A^{-1}.
$$

Note that $\Sigma(\theta, \sigma)$ depends on the loss function only through the expression $\mathbb{E}[\psi^2(\varepsilon)]\{\mathbb{E}[\psi'(\varepsilon)]\}^{-2}$. Thus, under the partially linear additive model (2), the efficiency of the robust regression estimator $\hat{\beta}$ is the same as in location models.

### 4.1. An Estimator of $\Sigma(\theta, \sigma)$

In any analysis, computing the standard errors of the considered estimators is an important task. Clearly, as in other settings, a possible estimator of $\Sigma(\theta, \sigma)$ can be obtained taking its empirical counterpart and replacing the unknown quantities by appropriate estimators. More precisely, let $\hat{\mu}$, $\hat{\beta}$, $\hat{\eta}_j$ and $\hat{\sigma}$ be the estimators defined in (6), (7) and (5), respectively. As in linear regression models, the term $v = \mathbb{E}[\psi^2(\varepsilon)]\{\mathbb{E}[\psi'(\varepsilon)]\}^{-2}$ can be easily estimated by

$$
\hat{v} = \frac{1}{n}\sum_{i=1}^{n}\psi^2(\hat{\varepsilon}_i)\left\{\frac{1}{n}\sum_{i=1}^{n}\psi'(\hat{\varepsilon}_i)\right\}^{-2},
$$

where

$$
\hat{\varepsilon}_i = \frac{Y_i - \hat{\mu} - \hat{\beta}^t Z_i - \sum_{j=1}^{p}\hat{\eta}_j(X_{ij})}{\hat{\sigma}},
\tag{14}
$$

while an estimator of the matrix $A$ can be constructed as

$$
\hat{A} = \frac{1}{n}\sum_{i=1}^{n}\{Z_i - \hat{h}^*(X_i)\}\{Z_i - \hat{h}^*(X_i)\}^t,
\tag{15}
$$

for a proper estimator $\hat{h}^*(x)$ of $h^*(x)$, leading to the plug-in estimator of $\Sigma$ given by

$$
\hat{\Sigma} = \hat{\sigma}^2\,\hat{v}\,\hat{A}^{-1}.
\tag{16}
$$

Some facts need to be highlighted regarding the estimator $\hat{A}$ defined in (15). Note that $\hat{A}$ is an average of the covariate residuals $r_{i,Z} = Z_i - \hat{h}^*(X_i)$, so that large values of them may distort its value. A similar behavior arises in linear regression models and has been discussed in Section 5.6 in Maronna et al. (2019). In our setting, the problem is increased since high-leverage observations may also affect the estimators $\hat{h}^*$ of $h^*$ if not chosen appropriately, in which case all values of $r_{i,Z}$ will be distorted. In particular, the covariate residuals related to the outliers will be smaller than expected, producing larger estimated asymptotic variances for each component of $\hat{\beta}$.

In order to control this effect, one may combine the ideas in Yohai et al. (1991) with a more stable estimator of $A$. To be more precise, let $w(t) = \psi(t)/t$ if $t \neq 0$ and $w(0) = \psi'(0)$ be the weight function related to the score function $\psi$ and denote, for brevity, $w_i = w(\hat{\varepsilon}_i)$, where $\hat{\varepsilon}_i$ are defined in (14). Then, given an estimator $\hat{h}^*$ of $h^*$, an estimator of $A$ may be constructed as

$$
\hat{A} = \left(\sum_{i=1}^{n} w_i\right)^{-1} \sum_{i=1}^{n} w_i \{Z_i - \hat{h}^*(X_i)\}\{Z_i - \hat{h}^*(X_i)\}^t.
\tag{17}
$$

The independence between the covariates and the errors ensures that, under appropriate convergence conditions for $\hat{h}^*$, $\hat{A} \xrightarrow{p} A$. Besides, if $\hat{h}^*$ is a resistant estimator, an observation with high-leverage will still have a large residual $Z_i - \hat{h}^*(X_i)$. The effect of a bad leverage point will be downweighted by the weights $w_i$, which may be 0 for large values of the residuals if, for instance, the bisquare loss function is chosen, controlling in this way the damaging effect on the estimated asymptotic variances. In contrast, if the $i$-th observation is such that $Z_i$ is a good leverage point, that is, one with a small residual $\hat{\varepsilon}_i$, the enlargement effect of $Z_i - \hat{h}^*(X_i)$ will be beneficial on $\hat{A}$, reducing the asymptotic variances.

Following Markatou and He (1994), another estimator of the asymptotic covariance matrix can be implemented besides the one defined in (16) with $\hat{A}$ given in (17). Indeed, taking into account that, from the proof of Theorem 4.1, $\Sigma(\theta, \sigma) = B^{-1} D (B^{-1})^t$, where
