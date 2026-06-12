[Page 9]

The following additional assumptions are needed in Corollary 3.4.

**C9** There exists a constant $C > 0$ such that for any $\theta_1 = (a_1, b_1^t, g_{1,1}, \ldots, g_{1,p})^t$ and $\theta_2 = (a_2, b_2^t, g_{2,1}, \ldots, g_{2,p})^t$, $\theta_1, \theta_2 \in \mathbb{R} \times \mathbb{R}^q \times S_1 \times \cdots \times S_p$:

$$
\pi_P^2(\theta_1, \theta_2) \geq C\left\{(a_1 - a_2)^2 + \|b_1 - b_2\|^2 + \mathbb{E}\left[\sum_{j=1}^{p}\bigl(g_{1,j}(X_j) - g_{2,j}(X_j)\bigr)^2\right]\right\}.
$$

**C10** For all $1 \leq j \leq p$, the random variable $X_j$ has a density $f_j$ bounded away from $0$ and infinity on $I_j$.

To state Corollary 3.4, define $\hat{\eta}_j^* = \hat{\eta}_j - \mathbb{E}_j(\hat{\eta}_j)$, where the expectation is taken with respect to $X_j$ conditioned on the sample, and $\eta_j^* = \eta_j - \mathbb{E}_j(\eta_j)$. To avoid confusions in the notation, for any function $g : [0, 1] \to \mathbb{R}$, $\mathbb{E}_j(g)$ stands for $\mathbb{E}(g(X_j))$. With this notation, the additive components and their estimators centered with respect to their expected values can be written as $\eta_j^* = \eta_j - \mathbb{E}_j(\eta_j)$ and $\hat{\eta}_j^* = \hat{\eta}_j - \mathbb{E}_j(\hat{\eta}_j)$, respectively.

**Corollary 3.4.** Assume that $\mathbb{E}\|Z\|^2 < \infty$, that the function $\rho_1$ satisfies C1, $\psi_1$ is continuously differentiable with bounded derivative and that C2 to C6, C8 and C9 hold. Furthermore, assume that assumption C7 holds with $c < 1 - b_{\rho_1}$ and $b_{\rho_1} = L(\theta, \sigma) < 1$. Let $\hat{\theta} = (\hat{\mu}, \hat{\beta}^t, \hat{\eta}_1, \ldots, \hat{\eta}_p)^t$ be the estimators defined through (6) and (7). Then,

(a) $\gamma_n\bigl(|\hat{\mu} - \mu| + \|\hat{\beta} - \beta\|\bigr) = O_P(1)$.

(b) If, in addition, C10 holds, we have that $\gamma_n^2 \mathbb{E}_j\|\hat{\eta}_j^* - \eta_j^*\|^2 = O_P(1)$.

(c) If, in addition, assumption C10 holds, $\nu_j = 1/(1 + 2r_j)$ and $\gamma_n = n^{(1-\nu)/2 - \omega}$ for $0 < \omega < (1 - 2\nu)/2$ arbitrarily small, we have that $n^\alpha \|\hat{\eta}_j^* - \eta_j^*\|_\infty = O_P(1)$, for $1 \leq j \leq p$, where $\alpha = (1 - 2\nu)/2 - \omega$.

Moreover, when the same smoothness degree $r$ is assumed for all additive components, i.e., $r_j = r$, for all $1 \leq j \leq p$ and $\nu_j = 1/(1 + 2r)$, a convergence rate $n^{r/(1+2r) - \omega}$ is obtained in (a) and (b).

**Remark 3.2.** Analogous arguments to those considered in Lemma S.2.3 in Boente et al. (2020a) allow to show that if the matrix $\mathbb{E}[\tilde{Z}\tilde{Z}^t]$ is non-singular, where $\tilde{Z} = (1, Z^t)^t \in \mathbb{R}^{q+1}$, and $P(Z = \mathbb{E}(Z \mid X)) < 1$, then assumption C9 holds. It should be noticed that, under assumptions C9 and C10, similar arguments to those considered in Theorem 3.3 combined with those considered in Shen and Wong (1994) when they analyze Case 3 in page 596, may allow to derive that $\gamma_n \|\hat{\eta}_j^* - \eta_j^*\|_{L_2(P)} = O_P(1)$, where $\gamma_n = n^{(1-\nu)/2}$, leading to the optimal rate of convergence $n^{r/(1+2r)}$ if $r_j = r$, for all $1 \leq j \leq p$ and $\nu_j = 1/(1+2r)$. However, in Theorem 3.3, we have tried to avoid additional assumptions regarding the distribution of the covariates and for that reason a lower rate is obtained in Corollary 3.4.

## 4. Asymptotic Normality of the Regression Estimators

In this section, we attempt to derive the asymptotic distribution of the estimators for the regression parameter $\beta$ under mild assumptions. For that purpose, define $h^*(X) = (h_1^*(X), \ldots, h_q^*(X))^t$ as

$$
h^*(X) = \mathbb{E}(Z \mid X),
$$

and $A = \mathbb{E}\bigl[Z - h^*(X)\bigr]\bigl[Z - h^*(X)\bigr]^t$. Note that if $Z$ and $X$ are independent, $h^*(X) = \mathbb{E}(Z)$, so that $A$ is the covariance matrix of $Z$.

To obtain the asymptotic distribution of $\hat{\beta}$, we will need the following additional assumptions.

**N1** The matrix $A$ is non-singular.

**N2** For $1 \leq j \leq p$, $\nu_j = 1/(2r_j + 1)$ with $r_j \geq 1$. Let $\hat{\theta} = (\hat{\mu}, \hat{\beta}^t, \hat{\eta}_1, \ldots, \hat{\eta}_p)^t$ be the estimators defined through (6) and (7) and $\gamma_n = n^{(1-\nu)/2 - \omega}$ where $\nu = \max_{1 \leq j \leq p} \nu_j$ and $0 \leq \omega < (1 - \nu)/8$. One of the following conditions holds:

(a) $r_j > 1$, for all $1 \leq j \leq p$, $\mathbb{E}\|Z\|^6 < \infty$, $\pi(\hat{\theta}, \theta) \xrightarrow{p} 0$, $\gamma_n \pi_P(\hat{\theta}, \theta) = O_P(1)$ and $0 \leq \omega < (1 - 3\nu)/6$.

(b) For some $1 \leq j_0 \leq p$, $r_{j_0} = 1$, $\mathbb{E}\|Z\|^{10} < \infty$, $\pi(\hat{\theta}, \theta) \xrightarrow{p} 0$, $\gamma_n \pi_P(\hat{\theta}, \theta) = O_P(1)$ and $0 \leq \omega < 1/21$.

**N3** For each $1 \leq m \leq q$, the function $h_m^*(x)$ is an additive function in $x$, that is, it can be written as

$$
h_m^*(x) = \phi_m + \sum_{j=1}^{p} h_{mj}^*(x_j),
$$

where $h_{mj}^* \in \mathcal{H}_{r_j} \cap \mathcal{G}$, for $1 \leq j \leq p$.
