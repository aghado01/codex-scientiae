[Page 7]

## 3. Consistency Results

This section aims to obtain results concerning the consistency and the convergence rates of the estimators defined in Section 2 under assumptions C1 to C7 below. As in Guo et al. (2013), without loss of generality, we will assume $I_j = [0, 1]$ for $j = 1, \ldots, p$. In assumption C1 below the function $\rho$ will correspond to either $\rho_0$ or $\rho_1$ according to the result to be derived. From now on $C^r(0, 1)$ will stand for the space of functions continuously differentiable up to order $r$, $\|\cdot\|$ refers to the Euclidean norm in $\mathbb{R}^q$ and for any continuous function $v : \mathbb{R} \to \mathbb{R}$, $\|v\|_\infty = \sup_t |v(t)|$. We will denote as $\mathcal{G}$ the class of functions $\mathcal{G} = \{g : [0, 1] \to \mathbb{R} \text{ such that } \int_0^1 g(x)\,dx = 0\}$ and, for any $r \geq 1$, we define

$$
\mathcal{H}_r = \left\{\eta \in C^r[0,1] : \|\eta^{(\ell)}\|_\infty < \infty,\; 0 \leq \ell \leq r \text{ and } \sup_{z_1 \neq z_2} \frac{|\eta^{(r)}(z_1) - \eta^{(r)}(z_2)|}{|z_1 - z_2|} < \infty\right\}.
$$

**C1** (a) The function $\rho : \mathbb{R} \to [0; +\infty)$ is bounded, continuous, even, non–decreasing in $[0, +\infty)$ and such that $\rho(0) = 0$. Furthermore, $\lim_{t \to +\infty} \rho(t) \neq 0$ and if $0 \leq u < v$ with $\rho(v) < \sup_t \rho(t)$ then $\rho(u) < \rho(v)$. Without loss of generality, since $\rho$ is bounded, we assume that $\sup_t \rho(t) = 1$. (b) $\rho$ is continuously differentiable with bounded derivative $\psi$. Moreover, the function $\zeta : \mathbb{R} \to \mathbb{R}$ defined as $\zeta(t) = t\psi(t)$, $t \in \mathbb{R}$, is bounded.

**C2** The random variable $\varepsilon$ has a density function $f_0(t)$ that is even, monotone non-decreasing in $|t|$, and strictly decreasing for $|t|$ in a neighborhood of 0.

**C3** For $1 \leq j \leq p$, the true function $\eta_j \in \mathcal{H}_{r_j}$ where $r_j \geq 1$. Furthermore, the splines order used to estimate $\eta_j$ satisfy $\ell_j \geq r_j + 2$.

**C4** The basis dimension $k_j$ is assumed to be of order $O(n^{\nu_j})$ with $1/(2r_j + 2) < \nu_j < 1/(2r_j)$, where $r_j$ is given in C3. Moreover, the ratio between the maximum and minimum spacings of the knots is uniformly bounded.

**C5** $\hat{\sigma}$ is a strongly consistent estimator of $\sigma$.

**C6** For almost any $x_0 \in \mathbb{R}^p$, $P(b^t Z = a \mid X = x_0) < 1$, for any $a \in \mathbb{R}$, $b \in \mathbb{R}^q$, $(b, a) \neq 0$.

**C7** There exists $0 < c < 1$ such that $P\bigl(b^t Z + \sum_{j=1}^{p} g_j(X_j) = a\bigr) < c$ for any $a \in \mathbb{R}$, $b \in \mathbb{R}^q$, $g_j \in \mathcal{G}$, $(a, b, g_1, \ldots, g_p) \neq 0$.

**Remark 3.1.** Conditions C1 and C2 are standard conditions for the errors and for the loss function, respectively. The first one is a condition assumed in the context of robustness to ensure Fisher-consistency. In this sense, C6 is also a requirement for Fisher-consistency and it is the conditional counterpart of the usual assumption in linear regression models to guarantee Fisher-consistency. Under the partially linear additive model we are considering, Fisher-consistency will be derived in Lemma A.1 in the Appendix. Note that if, for almost any $x_0 \in \mathbb{R}^p$, the distribution of $Z$ given $X = x_0$ has a density, then $P(b^t Z = a \mid X = x_0) = 0$, for any $a \in \mathbb{R}$, $b \in \mathbb{R}^q$, $(b, a) \neq 0$, implying that C6 and C7 hold. Furthermore, it is worth mentioning that C6 holds whenever $P(b^t Z + \sum_{j=1}^{p} g_j(X_j) = a) = 0$ in C7.

Condition C3 regards the smoothness of the additive nonparametric components and $r_j$ corresponds to the smoothness degree of the $j$-additive true functions $\eta_j$. The regularity of the additive components stated in C3 is related to the order of the B-splines used to approximate them, meaning that if for instance cubic splines are used, our results will be valid for twice continuously differentiable functions. As mentioned in He et al. (2002), if we think that $\eta_j$ is less smooth, quadratic splines can be considered.

The condition about the knots spacing given in C4 is a standard one when using B-spline approximations.

Strong consistency of the preliminary scale estimator is required in C5 to allow for other choices of the robust scale estimators, besides the one introduced in Section 2.2. Proposition 3.1 below states that the S-scale defined through (5) is indeed strongly consistent as required in C5.

**Proposition 3.1** derives strong consistency results for the residual scale estimator $\hat{\sigma}$ defined through (5). To derive this result we define the population counterpart of $\hat{\sigma}$. More precisely, given $a \in \mathbb{R}$, $b \in \mathbb{R}^q$ and $g_j \in \mathcal{G}$, $1 \leq j \leq p$, $S(a, b, g_1, \ldots, g_p)$ stands for the M-scale functional corresponding to the residuals $r(a, b, g_1, \ldots, g_p) = Y - a - b^t Z - \sum_{j=1}^{p} g_j(X_j)$, that is, $S(a, b, g_1, \ldots, g_p)$ satisfies

$$
\mathbb{E}\rho_0\!\left(\frac{r(a, b, g_1, \dots, g_p)}{S(a, b, g_1, \dots, g_p)}\right) = b.
$$

Henceforth, the scale estimators are calibrated so that
