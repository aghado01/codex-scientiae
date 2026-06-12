[Page 28]

Hence, from the assumption that, for any $\delta > 0$, $\inf_{t \in \mathcal{A}_\delta} L(a, b, g_1, \ldots, g_p, \sigma) > L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma)$ and the fact that $L(\hat{\theta}, \sigma) \xrightarrow{a.s.} L(\theta, \sigma)$, we immediately obtain that $\pi(\hat{\theta}, \theta) \xrightarrow{a.s.} 0$. We now can proceed with the proof of Theorem 3.2.

**Proof of Theorem 3.2.** It is enough to show that (A.7) holds. Recall the definition of $\mathcal{A}_\delta$ from Proposition A.6, where $\theta = (\mu, \beta^t, \eta_1, \ldots, \eta_p)^t$. As in Lemma A.5, let $t_k = (a_k, b_k^t, g_{1,k}, \ldots, g_{p,k})^t \in \mathcal{A}_\delta$ be such that $L(t_k, \sigma) \to \inf_{t \in \mathcal{A}_\delta} L(t, \sigma)$ and denote $\nu_k = |a_k - \mu| + \|b_k - \beta\| + \sum_{j=1}^{p} \|g_{j,k} - \eta_j\|_{\mathcal{H}_1}$. Using that $t_k \in \mathcal{A}_\delta$, we get that the sequences $\{g_{j,k} - \eta_j\}_{k \geq 1}$ and their first derivatives are uniformly bounded. Hence, the compactness of $\{(a, b) \in \mathbb{R} \times \mathbb{R}^q : |a - \mu| + \|b - \beta\| \leq M\}$ and the Arzelà-Ascoli Theorem imply that there exists a subsequence $k_\ell$ such that $d_{k_\ell} = a_{k_\ell} - \mu \to d$, $e_{k_\ell} = b_{k_\ell} - \beta \to e$ for some $d \in \mathbb{R}$ and $e \in \mathbb{R}^q$, while $f_{j,\ell} = g_{j,k_\ell} - \eta_j$, for $1 \leq j \leq p$, converge uniformly to some continuous functions $f_1, \ldots, f_p$, respectively. Denote $\bar{a} = d + \mu$, $\bar{b} = e + \beta$, $\bar{g}_j = f_j + \eta_j$, $1 \leq j \leq p$, the uniform limits of $a_{k_\ell}$, $b_{k_\ell}$ and $g_{j,k_\ell}$, $1 \leq j \leq p$, respectively. Denote $\bar{t} = (\bar{a}, \bar{b}^t, \bar{g}_1, \ldots, \bar{g}_p)^t$ and $\bar{t}_{k_\ell} = (a_{k_\ell}, b_{k_\ell}^t, g_{1,k_\ell}, \ldots, g_{p,k_\ell})^t$. Then, we have that $\pi(\bar{t}, \bar{t}_{k_\ell}) = |a_{k_\ell} - \bar{a}| + \|b_{k_\ell} - \bar{b}\| + \sum_{j=1}^{p} \|g_{j,k_\ell} - \bar{g}_j\|_\infty \to 0$. The fact that $\rho_1$ is a bounded continuous function and the Bounded Convergence Theorem imply that $L(\bar{t}_{k_\ell}, \sigma) \to L(\bar{t}, \sigma)$ which leads to $\inf_{t \in \mathcal{A}_\delta} L(t, \sigma) = L(\bar{t}, \sigma)$. Furthermore, $\pi(\bar{t}, \theta) \geq \delta$ since $\pi(\bar{t}_{k_\ell}, \theta) \geq \delta$, $\pi(\bar{t}, \bar{t}_{k_\ell}) \to 0$ and $\pi(\bar{t}, \theta) \geq \pi(\bar{t}_{k_\ell}, \theta) - \pi(\bar{t}, \bar{t}_{k_\ell})$; hence from Lemma A.1 we get that $L(\bar{t}, \sigma) > L(\theta, \sigma)$, concluding the proof. $\blacksquare$

### A.2. Proof of Theorem 4.1

Throughout this section, we denote $\rho = \rho_1$ and $\psi = \psi_1 = \rho_1'$. As in the proof of Proposition A.6, $P_n$ stands for the empirical probability measure of the observations $(Y_i, Z_i^t, X_i^t)^t$ and $P$ for the underlying probability measure. Furthermore, for any $t = (a, b^t, g_1, \ldots, g_p)^t \in \mathbb{R}^{q+1} \times \mathcal{G} \times \cdots \times \mathcal{G}$, let us consider the function $V_{t,\varsigma}$ defined as

$$
V_{t,\varsigma}(y, z, x) = \rho\!\left(\frac{y - a - b^t z - \sum_{j=1}^{p} g_j(x_j)}{\varsigma}\right).
$$

Then, $L_n(a, b, g_1, \ldots, g_p, \varsigma) = P_n V_{t,\varsigma}$ and $L(a, b, g_1, \ldots, g_p, \varsigma) = P V_{t,\varsigma}$. Moreover, denote as $V_{t,\varsigma}^{(\mu)}$ and $V_{t,\varsigma}^{(0)} = (V_{1,t,\varsigma}^{(0)}, \ldots, V_{q,t,\varsigma}^{(0)})^t$ the functions

$$
V_{t,\varsigma}^{(\mu)}(y, z, x) = -\frac{1}{\varsigma}\psi\!\left(\frac{y - a - b^t z - \sum_{j=1}^{p} g_j(x_j)}{\varsigma}\right),
$$

$$
V_{t,\varsigma}^{(0)}(y, z, x) = -\frac{1}{\varsigma}\psi\!\left(\frac{y - a - b^t z - \sum_{j=1}^{p} g_j(x_j)}{\varsigma}\right) z \,.
$$

Note that $V_{t,\varsigma}^{(\mu)}$ and $V_{t,\varsigma}^{(0)}$ are the partial derivatives of $V_{t,\varsigma}$ with respect to $a$ and $b$, respectively. Therefore, using that $L_n(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma}) \leq L_n(a, b, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma})$ for any $(a, b^t)^t \in \mathbb{R}^{q+1}$, we obtain that

$$
P_n V_{\hat{\theta},\hat{\sigma}}^{(\mu)} = 0 \quad \text{and} \quad P_n V_{\hat{\theta},\hat{\sigma}}^{(0)} = 0 \,. \tag{A.11}
$$

Besides, using that $\mathbb{E}\psi(a\varepsilon) = 0$ for any $a > 0$ and the independence between the errors and covariates, we get that for any $\varsigma > 0$,

$$
P V_{\theta,\sigma}^{(\mu)} = 0 \quad \text{and} \quad P V_{\theta,\sigma}^{(0)} = 0 \,.
$$

Similarly, if $\mathcal{G}_0$ stands for the class of measurable functions over $[0, 1]$, we consider the operator $V_{t,\varsigma}^{(j)}$ defined as

$$
V_{t,\varsigma}^{(j)}[h](y, z, x) = -\frac{1}{\varsigma}\psi\!\left(\frac{y - a - b^t z - \sum_{\ell=1}^{p} g_\ell(x_\ell)}{\varsigma}\right) h(x_j) \quad \text{for any } h \in \mathcal{G}_0 \,.
$$

As above, $V_{t,\varsigma}^{(j)}[h]$ is the directional derivative of $V_{t,\varsigma}$, that is,

$$
V_{t,\varsigma}^{(j)}[h] = \frac{\partial\, V_{a,b,g_1,\ldots,g_{j-1},g_j+sh,g_{j+1},\ldots,g_p,\varsigma}}{\partial s}\bigg|_{s=0} \,.
$$
