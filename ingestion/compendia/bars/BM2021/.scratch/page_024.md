[Page 24]

## Appendix A. Proofs

From now on, for any measure $Q$ and class of functions $\mathcal{F}$, $N(\varepsilon, \mathcal{F}, L_s(Q))$ and $N_{[]}(\varepsilon, \mathcal{F}, L_s(Q))$ will denote the covering and bracketing numbers of the class $\mathcal{F}$ with respect to the distance in $L_s(Q)$, as defined, for instance, in van der Vaart and Wellner (1996). Furthermore, $\|\mathbb{G}_n\|_{\mathcal{F}}$ stands for $\|\mathbb{G}_n\|_{\mathcal{F}} = \sup_{f \in \mathcal{F}} \sqrt{n}|(P_n - P)f|$, where $P_n$ stands for the empirical probability measure of $(Y_i, Z_i^t, X_i^t)^t$, $1 \leq i \leq n$, and $P$ is the probability measure corresponding to $(Y, Z^t, X^t)^t$.

### A.1. Proofs of Proposition 3.1 and Theorem 3.2

Lemmas A.1 to A.5 will be needed to prove Proposition 3.1 and Theorem 3.2. In particular, Lemma A.1, whose proof can be found in the supplementary file, regards the Fisher-consistency of the proposed estimators. Fisher consistency guarantees that we are estimating the target quantities and is a first step to obtain consistency results.

**Lemma A.1.** *Given a $\rho$-function $\rho$ satisfying C1(a), let $L : \mathbb{R}^{q+1} \times \mathcal{G}^p \times (0, +\infty) \to \mathbb{R}$ be the function defined in (11). Then, under C2, we have that for any $\varsigma > 0$*

- *(i) $L(\mu, \beta, \eta_1, \ldots, \eta_p, \varsigma) \leq L(a, b, g_1, \ldots, g_p, \varsigma)$, for any $a \in \mathbb{R}$, $b \in \mathbb{R}^q$, $g_1 \in \mathcal{G}, \ldots, g_p \in \mathcal{G}$.*
- *(ii) If in addition C6 holds, $(\mu, \beta, \eta_1, \ldots, \eta_p)$ is the unique minimizer of $L(a, b, g_1, \ldots, g_p, \varsigma)$.*

Let us state some notation that will be helpful in the sequel. Given a loss function $\rho : \mathbb{R} \to \mathbb{R}$, we define the function $L_n : \mathbb{R}^{q+1} \times \mathcal{G}^p \times (0, +\infty) \to \mathbb{R}$ as

$$
L_n(a, b, g_1, \ldots, g_p, \varsigma) = \frac{1}{n} \sum_{i=1}^{n} \rho\!\left(\frac{Y_i - a - b^t Z_i - \sum_{j=1}^{p} g_j(X_{ji})}{\varsigma}\right).
$$

Note that $L_n$ is the sample version of the function $L$ defined in (11).

Recall that $\mathcal{S}_j$, $1 \leq j \leq p$, denotes the linear space spanned by the centered B-splines bases of order $\ell_j$ and size $k_j$ as defined in (12). From now on, for $g_j(x) = \sum_{s=1}^{k_j - 1} c_s^{(j)} B_s^{(j)}(x) \in \mathcal{S}_j$, $1 \leq j \leq p$, and identifying the functions with their coefficients, we denote indistinctly $s_n(a, b, g_1, \ldots, g_p) = s_n(a, b, c^{(1)}, \ldots, c^{(p)})$ as defined in (4) and $r_i(a, b, g_1, \ldots, g_p) = r_i(a, b, c^{(1)}, \ldots, c^{(p)})$ as defined in (3) with $c^{(j)} = (c_1^{(j)}, \ldots, c_{k_j-1}^{(j)})^t$. To derive uniform results, Lemma A.2 below provides a bound to the covering number of the class of functions

$$
\mathcal{F}_n = \left\{ f(y, z, \mathbf{x}) = \rho\!\left(\frac{y - a - \mathbf{b}^t z - \sum_{j=1}^{p} \mathbf{c}^{(j)t} V^{(j)}(\mathbf{x}_j)}{\varsigma}\right) : a \in \mathbb{R},\, \mathbf{b} \in \mathbb{R}^q,\, \mathbf{c}^{(j)} \in \mathbb{R}^{k_j - 1},\, \varsigma > 0 \right\}, \tag{A.1}
$$

where $V^{(j)}(t) = (B_1^{(j)}(t), \ldots, B_{k_j-1}^{(j)}(t))^t$ was defined in Section 2.1. Lemma A.2 is a direct consequence of Lemma S.2.1 in Boente et al. (2020a) noting that the number of parameters involved is $q + K + 1 = q + \sum_{j=1}^{p}(k_j - 1) + 1$ and that the class $\mathcal{F}_n$ has envelope 1; for that reason, its proof is omitted.

**Lemma A.2.** *Let $\rho$ be a function satisfying C1(a) and $\mathcal{F}_n$ the class of functions given in (A.1). Then, for any $0 < \varepsilon < 1$, there exists some constant $C > 1$ independent of $n$ and $\varepsilon$, such that*

$$
N(2\varepsilon, \mathcal{F}_n, L_1(\mathbb{Q})) \leq \left[C q_n (16e)^{q_n}\right]^{2(q_n - 1)},
$$

*where $q_n = 2\!\left(q + \sum_{j=1}^{p} k_j - p + 4\right) - 1$.*
