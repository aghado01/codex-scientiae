[Page 33]

plus the second-order remainder

$$
\frac{1}{2}\psi''\!\left(\frac{Y - \zeta_\tau^t\tilde{Z} - \sum_{j=1}^{p}\zeta_j(X_j)}{\varsigma}\right)\!\left(-\frac{1}{\varsigma^3}\right)(Z - h^*(X))\left\{\tilde{Z}^t(\mathbf{d}-\tau) + \sum_{j=1}^{p}(g_j - \eta_j)(X_j)\right\}^2,
$$

where $\zeta_\tau$ is an intermediate point between $\mathbf{d}$ and $\tau$ and $\zeta_j = \xi_j g_j + (1-\xi_j)\eta_j$, $0 < \xi_j < 1$, $1 \leq j \leq p$, respectively. For any $t = (\mathbf{d}^t, g_1, \ldots, g_p)^t$ and $\varsigma \in V$, denote as $R_n(t,\varsigma) = (R_{n,1}(t,\varsigma), \ldots, R_{n,q}(t,\varsigma))^t$ where

$$
R_n(t, \varsigma) = \mathbb{E}\psi''\!\left(\frac{Y - \zeta_\tau^t\tilde{Z} - \sum_{j=1}^{p}\zeta_j(X_j)}{\varsigma}\right)\!\left(-\frac{1}{\varsigma^3}\right)(Z - h^*(X))\left\{\tilde{Z}^t(\mathbf{d}-\tau) + \sum_{j=1}^{p}(g_j - \eta_j)(X_j)\right\}^2.
$$

Then, we have that for any $\varsigma \in V$,

$$
P W_{\hat{\theta},\varsigma} = P W_{\theta,\varsigma} - B_{\theta,\varsigma}(\hat{\beta} - \beta) + g_{\theta,\varsigma}(\hat{\mu} - \mu) + F_{\theta,\varsigma}(\hat{\beta} - \beta) + e_{\theta,\varsigma}(\hat{\eta}_1, \ldots, \hat{\eta}_p) + \frac{1}{2}R_n(\hat{\theta}, \varsigma) \,,
$$

The independence between the errors and the covariates and the definition of $h^*$ implies that, for any $\varsigma \in V$,

$$
F_{\theta,\varsigma} = \frac{1}{\varsigma^2}\mathbb{E}\psi'\!\left(\frac{\sigma\varepsilon}{\varsigma}\right)\mathbb{E}\!\left\{(Z - h^*(X))h^*(X)^t\right\} = 0 \,,
$$

$$
g_{\theta,\varsigma} = \frac{1}{\varsigma^2}\mathbb{E}\psi'\!\left(\frac{\sigma\varepsilon}{\varsigma}\right)\mathbb{E}\!\left\{Z - h^*(X)\right\} = 0 \,,
$$

$$
e_{\theta,\varsigma}(g_1, \ldots, g_p) = \frac{1}{\varsigma^2}\mathbb{E}\psi'\!\left(\frac{\sigma\varepsilon}{\varsigma}\right)\mathbb{E}\!\left\{(Z - h^*(X))\sum_{j=1}^{p}(g_j - \eta_j)(X_j)\right\} = 0 \,.
$$

On the other hand, (A.12) and (A.14) together with (A.15) entail that $P W_{\theta,\varsigma} = 0$. Hence, we obtain that

$$
P\!\left(W_{\hat{\theta},\hat{\sigma}} - W_{\theta,\sigma}\right) = P\!\left(W_{\hat{\theta},\hat{\sigma}} - W_{\theta,\hat{\sigma}}\right) = -B_{\theta,\hat{\sigma}}(\hat{\beta} - \beta) + \frac{1}{2}R_n(\hat{\theta}, \hat{\sigma}) \,. \tag{A.24}
$$

From the consistency of $\hat{\sigma}$ and the fact that $\psi'$ is a continuous bounded function, it is easy to see that $B_{\theta,\hat{\sigma}} \xrightarrow{p} B_{\theta,\sigma}$. Then, in order to show that H3 holds, it only remains to prove that $R_n(\hat{\theta}, \hat{\sigma}) = o_\mathbb{P}(n^{-1/2})$.

Denote $b_t(Z, X) = \tilde{Z}^t(\mathbf{d}-\tau) + \sum_{j=1}^{p}(g_j - \eta_j)(X_j)$ and $R_{n,m}(t, \varsigma)$ the $m$-th component of $R_n(t, \varsigma)$, $1 \leq m \leq q$. Using that the second derivative of $\rho$ is bounded, we get that

$$
|R_{n,m}(t, \varsigma)| \leq \frac{8}{\sigma^3}\|\psi''\|_\infty\,\mathbb{E}\!\left\{(|Z_m| + |h^*_m(X)|)\,b_t^2(Z, X)\right\}.
$$

Hence, using that N3 entails that $h^*_m$ is bounded, we obtain that $|R_{n,m}(t, \varsigma)| \leq R_{n,m,1}(t, \varsigma) + R_{n,m,2}(t, \varsigma)$ where

$$
R_{n,m,1}(t, \varsigma) = \frac{8}{\sigma^3}\|\psi''\|_\infty\,\mathbb{E}\!\left\{|Z_m|\,b_t^2(Z, X)\right\} = \frac{8}{\sigma^3}\|\psi''\|_\infty\,R^*_{n,m,1}(t, \varsigma) \,,
$$

$$
R_{n,m,2}(t, \varsigma) = \frac{8}{\sigma^3}\|\psi''\|_\infty\|h^*_m\|_\infty\,\mathbb{E}\!\left[b_t^2(Z, X)\right] = \frac{8}{\sigma^3}\|\psi''\|_\infty\|h^*_m\|_\infty\,\pi_\mathbb{P}^2(t, \theta) \,.
$$

Note that the fact that $r_j \geq 1$ implies that $\nu \leq 1/3$, so $(1-\nu)/8 \leq (1-2\nu)/4$. Besides, $\pi_\mathbb{P}(\hat{\theta}, \theta) = O_\mathbb{P}(n^{-(1-\nu)/2+\omega})$ with $\omega < (1-\nu)/8 \leq (1-2\nu)/4$, so $R_{n,m,2}(\hat{\theta}, \hat{\varsigma}) = o_\mathbb{P}(n^{-1/2})$. Therefore, we only have to show that $R_{n,m,1}(\hat{\theta}, \hat{\varsigma}) = o_\mathbb{P}(n^{-1/2})$.
