[Page 8]

$$
\sigma = S(\mu, \beta, \eta_1, \dots, \eta_p) = \underset{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, g_1 \in \mathcal{G},\dots, g_p \in \mathcal{G}}{\arg\min} S(a, b, g_1, \dots, g_p),
$$

meaning that $\mathbb{E}\rho_0(\varepsilon) = b$.

**Proposition 3.1.** Assume that the function $\rho_0$ satisfies C1. Then, under C2 to C4, we have that $\hat{\sigma} \xrightarrow{a.s.} \sigma$. Denote as $\theta = (\mu, \beta^t, \eta_1, \ldots, \eta_p)^t$ and $\hat{\theta} = (\hat{\mu}, \hat{\beta}^t, \hat{\eta}_1, \ldots, \hat{\eta}_p)^t$. Consistency results for the estimators of $\eta_j$, $1 \leq j \leq p$, will be derived in Theorem 3.2 with respect to the uniform distance in the space of continuous functions. For that reason, given $\theta_\ell = (a_\ell, b_\ell^t, g_{\ell,1}, \ldots, g_{\ell,p})^t \in \mathbb{R} \times \mathbb{R}^q \times C([0,1]) \times \cdots \times C([0,1])$, $\ell = 1, 2$, we define the metric $\pi(\theta_1, \theta_2) = |a_1 - a_2| + \|b_1 - b_2\| + \sum_{j=1}^{p} \|g_{1,j} - g_{2,j}\|_\infty$. Given a loss function $\rho : \mathbb{R} \to \mathbb{R}$, we define the function $L : \mathbb{R}^{q+1} \times \mathcal{G}^p \times (0, +\infty) \to \mathbb{R}$ as

$$
L(a, b, g_1, \dots, g_p, \varsigma) = \mathbb{E}\rho\!\left(\frac{Y - a - b^t Z - \sum_{j=1}^{p} g_j(X_j)}{\varsigma}\right).
\tag{11}
$$

**Theorem 3.2.** Let $\rho_1$ be a function satisfying C1 and such that $L(\theta, \sigma) = b_{\rho_1} < 1$, where the function $L$ is defined in (11) taking $\rho = \rho_1$. Assume that $\mathbb{E}\|Z\|^2 < \infty$ and that assumptions C2 to C6 hold. Furthermore, assume that C7 is fulfilled with $c < 1 - b_{\rho_1}$. Then, we have that $\pi(\hat{\theta}, \theta) \xrightarrow{a.s.} 0$.

### 3.1. Rates of Convergence

As it is usual in semiparametric models, convergence rates for the MM-estimators defined in Section 2.2 will be obtained when considering the mean square distance between the prediction differences, denoted $\pi_P$. More precisely, for $\theta_1 = (a_1, b_1^t, g_{1,1}, \ldots, g_{1,p})^t$ and $\theta_2 = (a_2, b_2^t, g_{2,1}, \ldots, g_{2,p})^t$, the prediction distance $\pi_P$ is defined as

$$
\pi_P^2(\theta_1, \theta_2) = \mathbb{E}\!\left[\left(a_1 - a_2 + (b_1 - b_2)^t Z + \sum_{j=1}^{p}(g_{1,j} - g_{2,j})(X_j)\right)^2\right].
$$

Furthermore, denote $S_j$, $1 \leq j \leq p$, the linear spaces spanned by the centered B-splines bases of order $\ell_j$ and size $k_j$. We omit the dependence on the knots to avoid burden notation. Note that since $\sum_{s=1}^{k_j} B_s^{(j)}(x) = 0$ for all $x$, the linear spaces have dimension $k_j - 1$, so

$$
S_j = \left\{\sum_{s=1}^{k_j-1} c_s B_s^{(j)}(x) : c \in \mathbb{R}^{k_j-1}\right\}, \quad 1 \leq j \leq p.
\tag{12}
$$

**C8** There exists a neighborhood $V$ of $\sigma$ with closure $\bar{V}$ strictly included in $(0, +\infty)$, and constants $\delta_0$ and $C_0$ such that $L(t, \varsigma) - L(\theta, \varsigma) \geq C_0 \pi_P^2(t, \theta)$ for any $t = (a, b^t, g_1, \ldots, g_p)^t \in \mathbb{R} \times \mathbb{R}^q \times S_1 \times \cdots \times S_p$ such that $|a - \mu| + \|b - \beta\| + \sum_{j=1}^{p} \|g_j - \eta_j\|_\infty < \delta_0$ and any $\varsigma \in V$.

Theorem 3.3 provides convergence rates with respect to the distance $\pi_P$. Its proof is relegated to the supplementary file. From now on, we denote as $\lambda = \min_{1 \leq j \leq p}(r_j \nu_j)$ and $\nu = \max_{1 \leq j \leq p} \nu_j$, where $\nu_j$ and $r_j$ are given in assumptions C3 and C4.

**Theorem 3.3.** Assume that $\rho_1$ satisfies C1, $\psi_1$ is continuously differentiable with bounded derivative and that C2 to C6 and C8 hold. Furthermore, assume that $\mathbb{E}\|Z\|^2 < \infty$ and that C7 holds with $c < 1 - b_{\rho_1}$, where $b_{\rho_1} = L(\theta, \sigma) < 1$. Let $\hat{\theta} = (\hat{\mu}, \hat{\beta}^t, \hat{\eta}_1, \ldots, \hat{\eta}_p)^t$ be the estimators defined through (6) and (7).

Then, for any sequence of positive numbers $\{\gamma_n\}_{n \in \mathbb{N}}$ such that $\gamma_n = O(n^\lambda)$ and $\gamma_n \sqrt{\log(\gamma_n)} = O(n^{(1-\nu)/2})$, we have that $\gamma_n \pi_P(\hat{\theta}, \theta) = O_P(1)$. Hence, when $\nu_j = 1/(1 + 2r_j)$ in C4, the estimators converge at rate $\gamma_n = n^{(1-\nu)/2 - \omega}$ for $\omega > 0$ arbitrarily small. In particular, when the same smoothness degree $r$ is assumed for all additive components, i.e., $r_j = r$, for all $1 \leq j \leq p$ and $\nu_j = 1/(1 + 2r)$, a convergence rate $n^{r/(1+2r) - \omega}$ is obtained, leading to a rate arbitrarily close to the optimal one, in terms of the prediction distance.

Under additional assumptions, Corollary 3.4 below provides rates of consistency for the estimators of the regression parameter and the parameter $\mu$, as well as convergence rates for the additive components estimators with respect to the $L_2(P)$ norm, when the estimators and regression functions are centered with respect to their expected values. Its proof is given in the supplementary file.
