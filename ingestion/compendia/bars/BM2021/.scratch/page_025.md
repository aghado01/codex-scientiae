[Page 25]

To derive the consistency of the MM-estimators and the S-scale the following Lemma will be helpful. It shows that $L_n(a, b, g_1, \ldots, g_p, \varsigma)$ converges to $L(a, b, g_1, \ldots, g_p, \varsigma)$ with probability one, uniformly over $a \in \mathbb{R}$, $\varsigma > 0$, $b \in \mathbb{R}^q$ and $\mathcal{S}_1 \times \cdots \times \mathcal{S}_p$, and its proof uses arguments similar to those appearing in the proof of Lemma S.1.2 in Boente et al. (2020b). We include it in the supplementary file for the sake of completeness.

**Lemma A.3.** *Let $\rho$ be a function satisfying C1. Then, under C4,*

*(a)*
$$
\sup_{\substack{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, \varsigma > 0 \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} \left| L_n(a, b, g_1, \ldots, g_p, \varsigma) - L(a, b, g_1, \ldots, g_p, \varsigma) \right| \xrightarrow{a.s.} 0 \,.
$$

*(b) Furthermore, if we denote $K = \sum_{j=1}^{p}(k_j - 1)$, we have that*
$$
\sup_{\substack{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, \varsigma > 0 \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} \left| \frac{1}{n - q - K} \sum_{i=1}^{n} \left[\rho\!\left(\frac{Y_i - a - b^t Z_i - \sum_{j=1}^{p} g_j(X_{ji})}{\varsigma}\right) - L(a, b, g_1, \ldots, g_p, \varsigma)\right] \right| \xrightarrow{a.s.} 0 \,.
$$

**Proof of Proposition 3.1.** To avoid burden notation, we will use $\rho$ instead of $\rho_0$ and $\hat{\mu}$, $\hat{\beta}$ and $\hat{\eta}_j$, for $j = 1, \ldots, p$, instead of $\hat{\mu}_{\mathrm{ini}}$, $\hat{\beta}_{\mathrm{ini}}$ and $\hat{\eta}_{j,\mathrm{ini}}$, respectively. To derive the desired result, given $\delta > 0$, it is enough to prove that, except for a null probability set, there exists $n_0 \geq 1$ such that for $n \geq n_0$, $|\hat{\sigma} - \sigma| \leq \delta$. Lemma A.3 entails there exists a null probability set $\mathcal{N}_1$ such that, for any $\omega \notin \mathcal{N}_1$,

$$
\sup_{\substack{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, \varsigma > 0 \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} \left| \frac{1}{n - q - K} \sum_{i=1}^{n} \left[\rho\!\left(\frac{Y_i - a - b^t Z_i - \sum_{j=1}^{p} g_j(X_{ij})}{\varsigma}\right) - L(a, b, g_1, \ldots, g_p, \varsigma)\right] \right| \to 0 \,. \tag{A.3}
$$

On the other hand, given that $n/(n - q - K) \to 1$, the boundedness of $\rho$, the strong law of large numbers and assumption C1(a) imply that

$$
\frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{\sigma\varepsilon_i}{\sigma + \delta}\right) \xrightarrow{a.s.} \mathbb{E}\rho\!\left(\frac{\sigma\varepsilon}{\sigma + \delta}\right) < \mathbb{E}\rho(\varepsilon) = b \,.
$$

Hence, except for null probability set $\mathcal{N}_2$,

$$
A_n(\delta) = \frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{\sigma\varepsilon_i}{\sigma + \delta}\right) \to \mathbb{E}\rho\!\left(\frac{\sigma\varepsilon}{\sigma + \delta}\right) = b_1 < \mathbb{E}\rho(\varepsilon) = b \,.
$$

Fix $\omega \notin \mathcal{N}_1 \cup \mathcal{N}_2$. For each $j = 1, \ldots, p$, using C3 and Corollary 6.21 in Schumaker (1981), we obtain that there exists a spline of order $\ell_j$, $\tilde{\eta}_j(x) = \sum_{s=1}^{k_j} \lambda_s^{(j)} B_s^{(j)}(x)$, such that $\|\eta_j - \tilde{\eta}_j\|_\infty = O(n^{-\nu_j r_j})$. The fact that $\int_0^1 \eta_j(x)\,dx = 0$ entails that $\int_0^1 \tilde{\eta}_j(x)\,dx = O(n^{-\nu_j r_j})$. Denote as the centered spline

$$
\tilde{\eta}_j(x) - \int_0^1 \tilde{\eta}_j(x)\,dx = \sum_{s=1}^{k_j - 1} c_s^{(j)} B_s^{(j)}(x) \,,
$$

with $c_s^{(j)} = \lambda_s^{(j)} - \lambda_{k_j}^{(j)}$, so $\tilde{\eta}_j \in \mathcal{S}_j$ and $\|\tilde{\eta}_j - \eta_j\|_\infty = O(n^{-\nu_j r_j})$. Using a Taylor's expansion of order one and denoting as $\xi_i$ an intermediate point, we obtain that

$$
\frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \mu - \beta^t Z_i - \sum_{j=1}^{p} \tilde{\eta}_j(X_{ij})}{\sigma + \delta}\right)
= \frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{\sigma\varepsilon_i + \sum_{j=1}^{p}(\eta_j - \tilde{\eta}_j)(X_{ij})}{\sigma + \delta}\right)
= A_n(\delta) + R_n \,, \tag{A.4}
$$

where $R_n = \frac{1}{(\sigma + \delta)(n - q - K)} \sum_{i=1}^{n} \psi(\xi_i) \sum_{j=1}^{p} (\eta_j - \tilde{\eta}_j)(X_{ij})$ and $A_n(\delta) \to b_1$, since $\omega \notin \mathcal{N}_2$. Using that $n/(n - q - K) \to 1$ and the bound

$$
|R_n| \leq \frac{\|\psi\|_\infty}{(\sigma + \delta)(n - q - K)} \sum_{j=1}^{p} \|\tilde{\eta}_j - \eta_j\|_\infty = \frac{1}{n - q - K} \sum_{j=1}^{p} O\!\left(n^{-\nu_j r_j}\right),
$$

we obtain that $|R_n| \to 0$. Therefore, from (A.4) we conclude that
