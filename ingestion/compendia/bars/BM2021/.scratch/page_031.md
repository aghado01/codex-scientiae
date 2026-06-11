[Page 31]

Using that $K = \sum_{j=1}^{p} O(n^{\nu_j}) = O(n^\nu)$ and $\delta = 2\max_{1 \leq j \leq p}\|h^*_{mj} - h_{n,m,j}\|_\infty = O(n^{-(1-\nu)/2})$, we get that, for $n$ large enough,

$$
\mathbb{P}\!\left(\sqrt{n}|T_1| > \varepsilon \cap \|\hat{\tau} - \tau\| + \sum_{j=1}^{p}\|\hat{\eta}_j - g_{j,c_{0,j}}\|_\infty < \varepsilon_0\right) \leq \frac{1}{\varepsilon}\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{E}_n^{(j)}} \leq \frac{1}{\varepsilon}C_1 p^{1/2} n^{-(1-2\nu)/2}\!\left(1 + \frac{C_2}{A_1} p^{1/2} n^{-(1-\nu)/2}\right),
$$

which converges to 0 since $r_j \geq 1$, i.e., $\nu < 1/2$. Hence, noting that $\|\hat{\tau} - \tau\| + \sum_{s=1}^{p}\|\hat{\eta}_s - g_{j,c_{0,j}}\|_\infty \xrightarrow{p} 0$, we obtain that $T_1 = o_\mathbb{P}(n^{-1/2})$.

To conclude the proof of (A.22) it remains to show that $T_2 = o_\mathbb{P}(n^{-1/2})$. The Fisher-consistency given in Lemma A.1 entails that $P V_{\theta,\varsigma}^{(j)}[h^*_{mj} - h_{n,m,j}] = 0$ for any $\varsigma > 0$, thus $T_2 = P(V_{\hat{\theta},\hat{\sigma}}^{(j)} - V_{\theta,\hat{\sigma}}^{(j)})[h^*_{mj} - h_{n,m,j}]$. Denote as $\zeta_\tau$ and $\zeta_j(x_j)$ intermediate values between $\tau$ and $\hat{\tau}$ and $\eta_j(x_j)$ and $\hat{\eta}_j(x_j)$, respectively. Then, using a first order Taylor's approximation and recalling that $\tilde{Z} = (1, Z^t)^t$, $|T_2|$ can be bounded by

$$
\begin{aligned}
|T_2| &= \left|\mathbb{E}\psi'\!\left(\frac{Y - \zeta_\tau^t\tilde{Z} - \sum_{s=1}^{p}\zeta_s(X_s)}{\hat{\sigma}}\right)\frac{1}{\hat{\sigma}^2}\left[(\tau - \hat{\tau})^t\tilde{Z} + \sum_{s=1}^{p}(\eta_s - \hat{\eta}_s)(X_s)\right](h^*_{mj} - h_{n,m,j})\right| \\
&\leq \frac{4}{\sigma^2}\|\psi'\|_\infty\|h^*_{mj} - h_{n,m,j}\|_\infty\; \mathbb{E}\!\left|(\tau - \hat{\tau})^t\tilde{Z} + \sum_{s=1}^{p}(\eta_s - \hat{\eta}_s)(X_s)\right| \\
&\leq \frac{4}{\sigma^2}\|\psi'\|_\infty\|h^*_{mj} - h_{n,m,j}\|_\infty\; \pi_\mathbb{P}(\hat{\theta}, \theta) \,.
\end{aligned}
$$

Taking into account that $\pi_\mathbb{P}(\hat{\theta}, \theta) = O_\mathbb{P}(n^{-(1-\nu)/2+\omega})$, $\omega < (1-2\nu)/2$, see assumption N2, and $\|h^*_{mj} - h_{n,m,j}\|_\infty = O(n^{-(1-\nu_j)/2})$, we conclude that $|T_2| = O_\mathbb{P}(n^{-(2-\nu-\nu_j)/2+\omega}) = O_\mathbb{P}(n^{-1/2})$ as desired.

*(ii)* We have to show that H2 holds. We will only show that H2(b), since H2(a) follows in a similar way using the class of functions $\mathcal{G}_{n,j,\delta,C_0}$, which is bounded if for some $C > 0$, $P(\|Z\| < C) = 1$. Instead, if $Z$ is not bounded, one has to consider the covering number of the family of functions $\mathcal{G}_{n,j,\delta,C_0}$ with respect to $L_2(P_n)$ and to use similar arguments to those described in van der Vaart and Wellner (1996), together with the strong law of large numbers and the fact that $\mathbb{E}\|Z\|^2 < \infty$, to derive H2(a).

Fix $1 \leq m \leq q$ and $1 \leq j \leq p$ and define $S_{1,n,m,j} = (P_n - P)\left\{V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] - V_{\theta,\hat{\sigma}}^{(j)}[h^*_{mj}]\right\}$ and $S_{2,n,m,j} = (P_n - P)\left\{V_{\theta,\hat{\sigma}}^{(j)}[h^*_{mj}] - V_{\theta,\sigma}^{(j)}[h^*_{mj}]\right\}$. To prove that H2(b) holds, note that $(P_n - P)\left\{V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] - V_{\theta,\sigma}^{(j)}[h^*_{mj}]\right\} = S_{1,n,m,j} + S_{2,n,m,j}$. Let $\mathcal{F}_{mj}$ be the family of functions $\mathcal{F}_{mj} = \{f(\varepsilon, x) = V_{\theta,\varsigma}^{(j)}[h^*_{mj}] = -\varsigma^{-1}\psi(\sigma\varepsilon/\varsigma)h^*_{mj}(x_j) : \varsigma \in V\}$. Recall that a class $\mathcal{F}$ of functions is Donsker when $\int_0^\infty \sqrt{N_{[]}(\delta, \mathcal{F}, L_2(P))}\,d\delta < \infty$, see van der Vaart and Wellner (1996). Using that $\psi$ has a bounded derivative, $h^*_{mj}$ is bounded (see assumption N3), $V \subset [\sigma/2, 3\sigma/2]$ and Theorem 2.7.11 in van der Vaart and Wellner (1996), we obtain easily that $\int_0^\infty \sqrt{N_{[]}(\delta, \mathcal{F}_{mj}, L_2(P))}\,d\delta < \infty$. Thus, $\mathcal{F}_{mj}$ is Donsker, which together with the fact that $\hat{\sigma} \xrightarrow{p} \sigma$ leads to $\sqrt{n}\,S_{2,n,m,j} = o_\mathbb{P}(1)$. Hence, to conclude the proof of H2(b), we have to show that $\sqrt{n}\,S_{1,n,m,j} = o_\mathbb{P}(1)$.

For $1 \leq j \leq p$, as in (i), let $c_{0,j} \in \mathbb{R}^{k_j - 1}$ be such that $g_{j,c_{0,j}} = \tilde{\eta}_j$ where $\tilde{\eta}_j \in \mathcal{S}_j$ is the spline approximation to $\eta_j$, that is, $\|\eta_j - \tilde{\eta}_j\|_\infty = O(n^{-\nu_j r_j}) = O(n^{-(1-\nu_j)/2})$. Then, for $n$ large enough $\sum_{j=1}^{p}\|\eta_j - \tilde{\eta}_j\|_\infty < \varepsilon_0/2$.

Take $\delta = \delta_n = n^{-\alpha(1-\nu)/2}$ with $\alpha = 3/4$. Then $\pi_\mathbb{P}(\theta_n, \theta) < \delta/2$ for $n \geq n_0$ with $\theta_n = \theta_{c_{0,1},\ldots,c_{0,p}} = (\tau^t, g_{1,c_{0,1}}, \ldots, g_{p,c_{0,p}})^t$. Furthermore, using that $n^{\alpha(1-\nu)/2}\pi_\mathbb{P}(\hat{\theta}, \theta) = O_\mathbb{P}(1)$ and $\omega < (1-\nu)/8$, we conclude that $n^{\alpha(1-\nu)/2}\pi_\mathbb{P}(\hat{\theta}, \theta) \xrightarrow{p} 0$. Hence, for $n$ large enough $\pi_\mathbb{P}(\hat{\theta}, \theta_n) < \delta$ with probability converging to 1.

Taking into account that $\pi(\hat{\theta}, \theta) \xrightarrow{p} 0$, we have that with probability converging to 1, $\pi(\hat{\theta}, \theta) < \varepsilon_0/2$, which entails that $\pi(\hat{\theta}, \theta_n) < \varepsilon_0$. Let us consider the probability set where $\pi(\hat{\theta}, \theta_n) < \varepsilon_0$. Then, for $n \geq n_0$, $V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] - V_{\theta,\hat{\sigma}}^{(j)}[h^*_{mj}] \in \mathcal{F}_{n,m,\delta,C_0}^{(j)}$, where $\mathcal{F}_{n,m,\delta,C_0}^{(j)}$ is defined in (A.17).
