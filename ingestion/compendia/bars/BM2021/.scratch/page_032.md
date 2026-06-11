[Page 32]

For the sake of simplicity, denote $\mathcal{F}^{(j)} = \mathcal{F}_{n,m,\delta,C_0}^{(j)}$. Let $f(y, \tilde{z}, x)$ be a function in $\mathcal{F}^{(j)}$, that is,

$$
f(y, \tilde{z}, x) = \left[-\frac{1}{\varsigma}\psi\!\left(\frac{y - \mathbf{d}^t\tilde{z} - \sum_{\ell=1}^{p} g_{\ell,c_\ell}(x_\ell)}{\varsigma}\right) + \frac{1}{\sigma}\psi\!\left(\frac{y - \tau^t\tilde{z} - \sum_{\ell=1}^{p}\eta_\ell(x_\ell)}{\sigma}\right)\right] h^*_{mj}(x_j) \,,
$$

for some $a \in \mathbb{R}$, $b \in \mathbb{R}^q$, $\mathbf{d} = (a, b^t)^t$, $\varsigma \in V$ and $g_{\ell,c_\ell} \in \mathcal{S}_\ell$, for $1 \leq \ell \leq p$, such that $\pi(t_{c_1,\ldots,c_p}, \theta_n) < \varepsilon_0$ and $\pi_\mathbb{P}(t_{c_1,\ldots,c_p}, \theta_n) < \delta$. Then $\|f\|_\infty \leq B_j = (4/\sigma)\|\psi\|_\infty\|h^*_{mj}\|_\infty$. On the other hand, using a Taylor's expansion of order one and denoting $\zeta_\tau$, $\zeta_\ell(x_\ell) = \xi_\ell g_{\ell,c_\ell}(x_\ell) + (1-\xi_\ell)\eta_\ell(x_\ell)$, $0 < \xi_\ell < 1$, as intermediate points between $(a, b^t)^t$ and $(\mu, \beta^t)^t$, and $g_{\ell,c_\ell}(x_\ell)$ and $\eta_\ell(x_\ell)$ for $1 \leq \ell \leq p$, respectively, we get that

$$
f(y, z, x) = \frac{1}{\varsigma^2}\psi'\!\left(\frac{y - \zeta_\tau^t\tilde{z} - \sum_{\ell=1}^{p}\zeta_\ell(x_\ell)}{\varsigma}\right)\!\left[(a-\mu) + (b-\beta)^t z + \sum_{\ell=1}^{p}(g_{\ell,c_\ell} - \eta_\ell)(x_\ell)\right] h^*_{mj}(x_j) \,.
$$

Hence, from the bound

$$
|f(y, z, x)| \leq \frac{4}{\sigma^2}\|\psi'\|_\infty\|h^*_{mj}\|_\infty\left|(a-\mu) + (b-\beta)^t z + \sum_{\ell=1}^{p}(g_{\ell,c_\ell}-\eta_\ell)(x_\ell)\right|,
$$

and the fact that $\pi_\mathbb{P}(\theta, t_{c_1,\ldots,c_p}) \leq \pi_\mathbb{P}(\theta_n, t_{c_1,\ldots,c_p}) + \pi_\mathbb{P}(\theta, \theta_n) \leq 2\delta$, we conclude that

$$
Pf^2 \leq \frac{16}{\sigma^4}\|\psi'\|_\infty^2\|h^*_{mj}\|_\infty^2\;\mathbb{E}\!\left((a-\mu) + (b-\beta)^t Z + \sum_{\ell=1}^{p}(g_{\ell,c_\ell}-\eta_\ell)(X_\ell)\right)^2 = \frac{16}{\sigma^4}\|\psi'\|_\infty^2\|h^*_{mj}\|_\infty^2\pi_\mathbb{P}^2(\theta, t_{c_1,\ldots,c_p}) \leq C_{mj}^2\delta^2 \,,
$$

with $C_{mj}^2 = 64\|\psi'\|_\infty^2\|h^*_{mj}\|_\infty^2/\sigma^4$ as defined in (A.20). Using again Lemma 3.4.2 of van der Vaart and Wellner (1996) we get that

$$
\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{F}^{(j)}} \lesssim J_{[]}\!\left(C_{mj}\delta, \mathcal{F}^{(j)}, L_2(P)\right)\!\left(1 + \frac{J_{[]}\!\left(C_{mj}\delta, \mathcal{F}^{(j)}, L_2(P)\right)}{C_{mj}^2\delta^2\sqrt{n}} B_j\right),
$$

which together with (A.20) leads, for $n$ large enough, to

$$
\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{F}^{(j)}} \leq 2C\delta\sqrt{\log\!\left(\tfrac{1}{\delta}\right)} K^{1/2} + \frac{4C^2 B_j}{C_{mj}^2}\log\!\left(\tfrac{1}{\delta}\right) K\, n^{-1/2} \,.
$$

Denote as $\mathcal{B}_n = \{\pi(\hat{\theta}, \theta_n) < \varepsilon_0 \cap \pi_\mathbb{P}(\hat{\theta}, \theta_n) < \delta\}$. Then $\mathbb{P}(\mathcal{B}_n) \to 1$. Using that $\delta = n^{-\alpha(1-\nu)/2}$, $K = \sum_{\ell=1}^{p} O(n^{\nu_\ell}) = O(n^\nu)$ and the Markov inequality, we get the bound

$$
\mathbb{P}\!\left(\sqrt{n}|S_{1,n,m,j}| > \varepsilon,\; \mathcal{B}_n\right) \leq \frac{1}{\varepsilon}\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{F}^{(j)}} \leq \frac{C^*}{\varepsilon}\left(n^{-\frac{1-3\nu}{8}} + n^{-\frac{1-2\nu}{2}}\right)\log(n) \,,
$$

which converges to 0, since the fact that $r_\ell \geq 1$ for all $\ell$ implies that $\nu < 3/7$. Hence, using that $\mathbb{P}(\mathcal{B}_n) \to 1$, we obtain that $S_{1,n,m,j} = o_\mathbb{P}(n^{-1/2})$, so H2(b) holds.

*(iii)* We will now show that H3 is fulfilled. Recall that $\tau = (\mu, \beta^t)^t$ and $\mathbf{d} = (a, b^t)^t$. Using a Taylor expansion of order two around $\theta = (\tau^t, \eta_1, \ldots, \eta_p)^t$, we get

$$
\begin{aligned}
W_{t,\varsigma} = W_{\theta,\varsigma} &+ \frac{1}{\varsigma^2}\psi'\!\left(\frac{Y - \tau^t\tilde{Z} - \sum_{j=1}^{p}\eta_j(X_j)}{\varsigma}\right)(Z - h^*(X))(Z - h^*(X))^t(b - \beta) \\
&+ \frac{1}{\varsigma^2}\psi'\!\left(\frac{Y - \tau^t\tilde{Z} - \sum_{j=1}^{p}\eta_j(X_j)}{\varsigma}\right)(Z - h^*(X))\!\left\{(a-\mu) + h^*(X)^t(\mathbf{d}-\tau)\right\} \\
&+ \frac{1}{\varsigma^2}\psi'\!\left(\frac{Y - \tau^t\tilde{Z} - \sum_{j=1}^{p}\eta_j(X_j)}{\varsigma}\right)(Z - h^*(X))\sum_{j=1}^{p}(g_j - \eta_j)(X_j) \,.
\end{aligned}
$$
