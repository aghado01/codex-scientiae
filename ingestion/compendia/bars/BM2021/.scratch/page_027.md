[Page 27]

**Lemma A.5.** *Assume that $\rho$ satisfies C1 and that $L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma) = b_\rho < 1$. Let $(\tilde{\mu}, \tilde{\beta}, \tilde{\eta}_1, \ldots, \tilde{\eta}_p) \in \mathbb{R} \times \mathbb{R}^q \times \mathcal{S}_1 \times \cdots \times \mathcal{S}_p$ be such that $L(\tilde{\mu}, \tilde{\beta}, \tilde{\eta}_1, \ldots, \tilde{\eta}_p, \sigma) \xrightarrow{a.s.} L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma)$. Assume that $\mathbb{E}\|Z\|^2 < \infty$ and that C3 and C7 hold with $c < 1 - b_\rho$. Then, there exists $M$ such that*

$$
\mathbb{P}\!\left(\bigcup_{m \in \mathbb{N}} \bigcap_{n \geq m} \left\{|\hat{\mu} - \mu| + \|\hat{\beta} - \beta\| + \sum_{j=1}^{p} \|\hat{\eta}_j - \eta_j\|_{\mathcal{H}_1} \leq M\right\}\right) = 1 \,.
$$

**Proposition A.6.** *Let $(Y_i, Z_i^t, X_i^t)^t$ be i.i.d. observations satisfying (2). Assume that C1 to C5 hold and that for any $M > 0$ and $\delta > 0$,*

$$
\inf_{t \in \mathcal{A}_\delta} L(t, \sigma) > L(\theta, \sigma) \,, \tag{A.7}
$$

*where $\mathcal{A}_\delta = \{t = (a, b^t, g_1, \ldots, g_p)^t : a \in \mathbb{R},\, b \in \mathbb{R}^q,\, g_j \in \mathcal{G} \cap \mathcal{H}_{r_j},\, |a - \mu| + \|b - \beta\| + \sum_{j=1}^{p} \|g_j - \eta_j\|_{\mathcal{H}_1} \leq M,\, \pi(\theta, t) \geq \delta\}$. Then, if in addition $\mathbb{E}\|Z\|^2 < \infty$, we have that $\pi(\hat{\theta}, \theta) \xrightarrow{a.s.} 0$.*

Note that Proposition A.6 gives a general consistency result under (A.7). In fact, Theorem 3.2 supplies sufficient conditions in order to ensure that (A.7) is satisfied.

**Proof of Proposition A.6.** Let $V_{a,b,g_1,\ldots,g_p,\varsigma} = \rho\!\left((y - a - b^t z - \sum_{j=1}^p g_j(x_j))/\varsigma\right)$. As above, $P$ denotes the probability measure of $(Y, Z^t, X^t)^t$ and $P_n$ its corresponding empirical measure. Then, $L_n(a, b, g_1, \ldots, g_p, \varsigma) = P_n V_{a,b,g_1,\ldots,g_p,\varsigma}$ and $L(a, b, g_1, \ldots, g_p, \varsigma) = P V_{a,b,g_1,\ldots,g_p,\varsigma}$. Let $V$ be a neighborhood of $\sigma$. Assumption C5 entails that, except for a null set $\mathcal{N}_V$, there exists $n_0 \in \mathbb{N}$ such that for any $n \geq n_0$, $\hat{\sigma} \in V$.

Lemma A.3 implies that

$$
A_n = \sup_{\substack{\varsigma > 0,\, a \in \mathbb{R},\, b \in \mathbb{R}^q \\ g_1 \in \mathcal{S}_1,\, \ldots,\, g_p \in \mathcal{S}_p}} \left|L_n(a, b, g_1, \ldots, g_p, \varsigma) - L(a, b, g_1, \ldots, g_p, \varsigma)\right| \xrightarrow{a.s.} 0 \,. \tag{A.8}
$$

On the other hand, from Lemma A.1 we have

$$
L(\mu, \beta, \eta_1, \ldots, \eta_p, \sigma) = \min_{a \in \mathbb{R},\, b \in \mathbb{R}^q,\, g_1 \in \mathcal{G},\, \ldots,\, g_p \in \mathcal{G}} L(a, b, g_1, \ldots, g_p, \sigma) \,,
$$

so we get that

$$
0 \leq L(\hat{\theta}, \sigma) - L(\theta, \sigma) = \sum_{s=1}^{3} A_{n,s} \,, \tag{A.9}
$$

with $A_{n,1} = L(\hat{\theta}, \hat{\sigma}) - L_n(\hat{\theta}, \hat{\sigma})$, $A_{n,2} = L_n(\hat{\theta}, \hat{\sigma}) - L(\theta, \sigma)$ and $A_{n,3} = L(\hat{\theta}, \sigma) - L(\hat{\theta}, \hat{\sigma})$. Note that $|A_{n,1}| \leq A_n$, hence $A_{n,1} = o_{a.s.}(1)$. On the other hand, Lemma A.4 and C5 imply that $A_{n,3} = o_{a.s.}(1)$.

It remains to see that $A_{n,2} = o_{a.s.}(1)$. As in the proof of Proposition 3.1, Corollary 6.21 in Schumaker (1981) entails that, for $1 \leq j \leq p$, there exists a centered spline $\tilde{\eta}_j$ such that $\tilde{\eta}_j \in \mathcal{S}_j$ and $\|\tilde{\eta}_j - \eta_j\|_\infty = O(n^{-\nu_j r_j})$. Denote $\theta_n = (\mu, \beta^t, \tilde{\eta}_1, \ldots, \tilde{\eta}_p)^t$.

Note that $S_{n,1} \leq A_n$, so that from (A.8) we get that $S_{n,1} \to 0$. On the other hand, writing $S_{n,2} = S_{n,2}^{(1)} + S_{n,2}^{(2)}$ where $S_{n,2}^{(1)} = L(\theta_n, \hat{\sigma}) - L(\theta_n, \sigma)$ and $S_{n,2}^{(2)} = L(\theta_n, \sigma) - L(\theta, \sigma)$, using that $\rho$ is a bounded continuous function, together with the fact that $\|\tilde{\eta}_j - \eta_j\|_\infty \to 0$ for all $j = 1, \ldots, p$ and the dominated convergence theorem, we have that $S_{n,2}^{(2)} = o_{a.s.}(1)$. Besides, from Lemma A.4 and the strong consistency of $\hat{\sigma}$, we conclude that $S_{n,2}^{(1)} = o_{a.s.}(1)$ leading to $S_{n,2} = o_{a.s.}(1)$. Using that $\hat{\theta}$ minimizes $L_n$ over $\mathbb{R} \times \mathbb{R}^q \times \mathcal{S}_1 \times \cdots \times \mathcal{S}_p$, we obtain that

$$
A_{n,2} = L_n(\hat{\theta}, \hat{\sigma}) - L(\theta, \sigma) \leq L_n(\theta_n, \hat{\sigma}) - L(\theta, \sigma) = S_{n,1} + S_{n,2} \,. \tag{A.10}
$$

Hence, from (A.9) and (A.10) and using that $A_{n,s} = o_{a.s.}(1)$ for $s = 1, 3$ and that $S_{n,s} = o_{a.s.}(1)$ for $s = 1, 2$, we obtain that $0 \leq L(\hat{\theta}, \sigma) - L(\theta, \sigma) = \sum_{s=1}^{3} A_{n,s} \leq A_{n,1} + S_{n,1} + S_{n,2} + A_{n,3} = o_{a.s.}(1)$, so $L(\hat{\theta}, \sigma) \xrightarrow{a.s.} L(\theta, \sigma)$. Note that Lemma A.5 implies that there exists $M$ such that

$$
\mathbb{P}\!\left(\bigcup_{m \in \mathbb{N}} \bigcap_{n \geq m} \left\{|\hat{\mu} - \mu| + \|\hat{\beta} - \beta\| + \sum_{j=1}^{p} \|\hat{\eta}_j - \eta_j\|_{\mathcal{H}_1} \leq M\right\}\right) = 1 \,.
$$
