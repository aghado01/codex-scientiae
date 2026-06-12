[Page 26]

$$
\frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \mu - \beta^t Z_i - \sum_{j=1}^{p} \tilde{\eta}_j(X_{ij})}{\sigma + \delta}\right) \to b_1 \,.
$$

Let $\delta_1 > 0$ be such that $b_1 + \delta_1 < b$. Then, there exists $n_0 \in \mathbb{N}$ such that for $n \geq n_0$,

$$
\frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \mu - \beta^t Z_i - \sum_{j=1}^{p} \tilde{\eta}_j(X_{ij})}{\sigma + \delta}\right) < b_1 + \delta_1 < b \,.
$$

Recall that

$$
\frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \mu - \beta^t Z_i - \sum_{j=1}^{p} \tilde{\eta}_j(X_{ij})}{s_n(\mu, \beta, \tilde{\eta}_1, \ldots, \tilde{\eta}_p)}\right) = b \,. \tag{A.5}
$$

Thus, (A.5) and the fact that $\rho$ is non-decreasing imply that $s_n(\mu, \beta, \tilde{\eta}_1, \ldots, \tilde{\eta}_p) < \sigma + \delta$. Taking into account that $\tilde{\eta}_1 \in \mathcal{S}_1, \ldots, \tilde{\eta}_p \in \mathcal{S}_p$ and that $\hat{\sigma} = \min_{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p} s_n(a, b, g_1, \ldots, g_p)$, we obtain that for $n \geq n_0$, $\sigma \leq s_n(\mu, \beta, \tilde{\eta}_1, \ldots, \tilde{\eta}_p) < \sigma + \delta$.

We have now to prove that for some $n_1 \in \mathbb{N}$ and for any $n \geq n_1$, we have that $\hat{\sigma} \geq \sigma - \delta$. Lemma 3 in Salibián-Barrera (2006) and assumptions C1(a) and C2 imply that

$$
L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma - \delta) > L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma) = b \,.
$$

Let $\delta_2 > 0$ be such that $L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma - \delta) = b + \delta_2$. Using that (A.3) holds, $n/(n - q - K) \to 1$ and $\rho$ is bounded, we obtain that for some $n_1 \in \mathbb{N}$ and any $n \geq n_1$,

$$
\sup_{\substack{\varsigma > 0,\, a \in \mathbb{R},\, b \in \mathbb{R}^q \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} \left| \frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - a - b^t Z_i - \sum_{j=1}^{p} g_j(X_{ij})}{\varsigma}\right) - L(a, b, g_1, \ldots, g_p, \varsigma) \right| < \delta_2 \,.
$$

Hence,

$$
\left| \frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \hat{\mu} - \hat{\beta}^t Z_i - \sum_{j=1}^{p} \hat{\eta}_j(X_{ij})}{\hat{\sigma}}\right) - L(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma}) \right| < \delta_2 \,,
$$

leading to

$$
L(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma}) < \frac{1}{n - q - K} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - \hat{\mu} - \hat{\beta}^t Z_i - \sum_{j=1}^{p} \hat{\eta}_j(X_{ij})}{\hat{\sigma}}\right) + \delta_2 = b + \delta_2 \,. \tag{A.6}
$$

The Fisher-consistency derived in Lemma A.1 entails that $L(\mu, \beta, \eta_1, \ldots, \eta_p, \hat{\sigma}) \leq L(\hat{\mu}, \hat{\beta}, \hat{\eta}_1, \ldots, \hat{\eta}_p, \hat{\sigma})$, which together with (A.6) leads to $L(\mu, \beta, \eta_1, \ldots, \eta_p, \hat{\sigma}) < b + \delta_2 = L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma - \delta)$, so $\hat{\sigma} \geq \sigma - \delta$ for any $n \geq n_1$, concluding the proof. $\blacksquare$

The proof of the following Lemma can be found in the supplementary file.

**Lemma A.4.** *Assume that $\rho$ satisfies C1 and let $V = [\sigma_1, \sigma_2]$ with $0 < \sigma_1 < \sigma_2$ some neighborhood of the error scale $\sigma$. Then, the function $L(a, b, g_1, \ldots, g_p, \varsigma)$ satisfies the following equicontinuity condition: for any $\nu > 0$ there exists $\delta > 0$ such that for any $\varsigma_1, \varsigma_2 \in V$,*

$$
|\varsigma_1 - \varsigma_2| < \delta \;\Rightarrow\; \sup_{\substack{a \in \mathbb{R},\, b \in \mathbb{R}^q \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} |L(a, b, g_1, \ldots, g_p, \varsigma_1) - L(a, b, g_1, \ldots, g_p, \varsigma_2)| < \nu \,.
$$

In order to derive Theorem 3.2, we introduce some additional notation. Taking into account the smoothness of $\eta_j$ stated in C3, we will use the following norm for the space $\mathcal{H}_r$:

$$
\|\eta\|_{\mathcal{H}_r} = \max_{1 \leq j \leq r} \|\eta^{(j)}\| + \sup_{\substack{z_1 \neq z_2 \\ z_1, z_2 \in (0,1)}} \frac{|\eta^{(r)}(z_1) - \eta^{(r)}(z_2)|}{|z_1 - z_2|} \,.
$$

From now on, the unit ball in $\mathcal{H}_r$ is denoted as $V_1^{(r)} = \{\eta \in \mathcal{H}_r : \|\eta\|_{\mathcal{H}_r} \leq 1\}$. Besides, denote $B_q = \{b \in \mathbb{R}^q : \|b\| \leq 1\}$ the unit ball in $\mathbb{R}^q$. The following result is needed to derive Proposition A.6 below, which is a key point in the proof of Theorem 3.2; its proof is relegated to the supplementary file, since it follows similar steps to those considered in Boente et al. (2020b).
