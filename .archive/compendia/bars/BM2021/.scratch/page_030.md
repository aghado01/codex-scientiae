[Page 30]

Analogous arguments to those considered in the proof of Lemma S.2.2 in the supplementary file, together with the fact that $\|h^*_{mj} - h\|_\infty < \delta$, allow to bound the bracketing number of the classes $\mathcal{E}_{n,m,h,\delta,C_0}^{(j)}$ and $\mathcal{F}_{n,m,\delta,C_0}^{(j)}$ and to conclude that for some generic constant $C$ independent of $n$ and $\delta$:

$$
J_{[1]}(A_1\delta,\; \mathcal{E}_{n,m,h,\delta,C_0}^{(j)},\; L_2(P)) \leq C\delta\sqrt{K + p + q + 2} \,, \tag{A.19}
$$

$$
J_{[1]}(C_{mj}\delta,\; \mathcal{F}_{n,m,\delta,C}^{(j)},\; L_2(P)) \leq C\delta\sqrt{\log\!\left(\tfrac{1}{\delta}\right)}\sqrt{K + p + q + 2} \,,
$$

where $K = \sum_{j=1}^{p}(k_j - 1)$, $A_1 = (2/\sigma)\|\psi\|_\infty$, $C_{mj} = 8\|\psi'\|_\infty\|h^*_{mj}\|_\infty/\sigma^2$. A similar bound holds for $\mathcal{G}_{n,j,\delta,C_0}$ since $\mathbb{E}\|Z\|^2 < \infty$.

To prove Theorem 4.1, we will verify the conditions of the following lemma, which we give without proof since it is a slight modification of Theorem 3 in Zhang et al. (2010). Note that H3(ii) corresponds to assumption (B3) in Zhang et al. (2010).

**Lemma A.7.** *Let $\theta = (\mu, \beta^t, \eta_1, \ldots, \eta_p)^t$ and $\hat{\theta} = (\hat{\mu}, \hat{\beta}^t, \hat{\eta}_1, \ldots, \hat{\eta}_p)^t$ a consistent estimator of $\theta$. Assume that (A.15) holds and that*

- *H1: $P_n V_{\hat{\theta},\hat{\sigma}}^{(0)} = o_\mathbb{P}(n^{-1/2})$ and $P_n V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] = o_\mathbb{P}(n^{-1/2})$, for $1 \leq m \leq q$ and $1 \leq j \leq p$,*
- *H2(a): $(P_n - P)\left\{V_{\hat{\theta},\hat{\sigma}}^{(0)} - V_{\theta,\sigma}^{(0)}\right\} = o_\mathbb{P}(n^{-1/2})$,*
- *H2(b): $(P_n - P)\left\{V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] - V_{\theta,\sigma}^{(j)}[h^*_{mj}]\right\} = o_\mathbb{P}(n^{-1/2})$, for $1 \leq m \leq q$ and $1 \leq j \leq p$,*
- *H3: $P\left\{W_{\hat{\theta},\hat{\sigma}} - W_{\theta,\sigma}\right\} = -B_{\theta,\sigma}(\hat{\beta} - \beta) + o_\mathbb{P}(n^{-1/2})$*

*hold. Then, if N3 holds, $B_{\theta,\hat{\sigma}} \xrightarrow{p} B_{\theta,\sigma}$ and $B_{\theta,\sigma}$ is non-singular, we have that $n^{1/2}(\hat{\beta} - \beta) = n^{1/2} B_{\theta,\sigma}^{-1} P_n W_{\theta,\sigma} + o_\mathbb{P}(1)$. Hence, if $D_{\theta,\sigma} = \mathbb{E}[W_{\theta,\sigma} W_{\theta,\sigma}^t]$, we have that $n^{1/2}(\hat{\beta} - \beta) \xrightarrow{D} N(0, B_{\theta,\sigma}^{-1} D_{\theta,\sigma} B_{\theta,\sigma}^{-t})$.*

**Proof of Theorem 4.1.** In order to show that Lemma A.7 can be applied, the proof will be carried out in several steps.

*(i)* We begin by deriving H1. Recall that according to (A.11), $P_n V_{\hat{\theta},\hat{\sigma}}^{(0)} = 0$, so we only need to verify

$$
P_n V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj}] = o_\mathbb{P}(n^{-1/2}) \quad \text{for all } 1 \leq m \leq q \text{ and } 1 \leq j \leq p \,. \tag{A.21}
$$

As in the proof of Proposition 3.1, first consider, for $1 \leq j \leq p$, $\tilde{\eta}_j \in \mathcal{S}_j$ such that $\|\tilde{\eta}_j - \eta_j\|_\infty = O(n^{-\nu_j r_j}) = O(n^{-(1-\nu_j)/2})$. Let $c_{0,j} \in \mathbb{R}^{k_j - 1}$ be such that $\tilde{\eta}_j = g_{j,c_{0,j}}$ and $\theta_n = \theta_{c_{0,1},\ldots,c_{0,p}} = (\tau^t, g_{1,c_{0,1}}, \ldots, g_{p,c_{0,p}})^t$. Then, using that $\|\hat{\eta}_j - g_{j,c_{0,j}}\|_\infty \xrightarrow{p} 0$. Let $1 \leq m \leq q$ and $1 \leq j \leq p$. Using that N3 and C4 hold, as in Proposition 3.1, from Schumaker (1981), we get that there exists $h_{n,m,j} \in \mathcal{S}_j$ such that $\|h^*_{mj} - h_{n,m,j}\|_\infty = O(n^{-r_j/(1+2r_j)}) = O(n^{-(1-\nu_j)/2})$. Hence, using (A.13), we conclude that to derive (A.21) it is enough to show that

$$
P_n V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj} - h_{n,m,j}] = o_\mathbb{P}(n^{-1/2}) \,. \tag{A.22}
$$

The term $P_n V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj} - h_{n,m,j}]$ can be written as $T_1 + T_2$ where $T_1 = (P_n - P)V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj} - h_{n,m,j}]$ and $T_2 = P V_{\hat{\theta},\hat{\sigma}}^{(j)}[h^*_{mj} - h_{n,m,j}]$. Let us consider the family of functions defined with $h = h_{n,m,j} \in \mathcal{S}_j$, $c_{0,j}$ such that $\tilde{\eta}_j = g_{j,c_{0,j}}$ and $\delta = \delta_n = 2\max_{1 \leq j \leq p}\|h^*_{mj} - h_{n,m,j}\|_\infty$. To avoid burden notation, let $\mathcal{E}_n^{(j)} = \mathcal{E}_{n,m,h_{n,m,j},\delta,C_0}^{(j)}$. For any $f \in \mathcal{E}_n^{(j)}$, $\|f\|_\infty \leq (2/\sigma)\|\psi\|_\infty\|h^*_{mj} - h\|_\infty \leq M(\delta)$, where $M(\delta) = (2/\sigma)\|\psi\|_\infty\delta = A_1\delta$. Furthermore,

$$
Pf^2 = \mathbb{E}\!\left[-\frac{1}{\varsigma}\psi\!\left(\frac{Y - a - b^t Z - \sum_{s=1}^{p} g_{j,c}(X_j)}{\varsigma}\right)(h^*_{mj}(X_j) - h(X_j))\right]^2 \leq \frac{4}{\sigma^2}\|\psi\|_\infty^2\|h^*_{mj} - h\|_\infty^2 \leq M^2(\delta) \,.
$$

Hence, Lemma 3.4.2 in van der Vaart and Wellner (1996) entails that

$$
\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{E}_n^{(j)}} \lesssim J_{[1]}(M(\delta), \mathcal{E}_n^{(j)}, L_2(P))\!\left(1 + \frac{J_{[1]}(M(\delta), \mathcal{E}_n^{(j)}, L_2(P))}{M(\delta)\sqrt{n}}\right),
$$

which together with (A.19) leads to

$$
\mathbb{E}^*\|\mathbb{G}_n\|_{\mathcal{E}_n^{(j)}} \leq C\delta\left(K + p + q + 2\right)^{1/2}\!\left(1 + \frac{C(K + p + q + 2)^{1/2}}{A_1\sqrt{n}}\right).
$$
