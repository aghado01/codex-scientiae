[Page 7]

- for $\lambda > \lambda_c$, all bars in $D_+$ have lifetimes at most $\varepsilon$.

Then for any $\lambda_- < \lambda_c < \lambda_+$, there exists a constant $\Delta > 0$ such that

$$
\liminf _ { N \to \infty } \mathbb { P } ( P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta ) = 1 .
$$

In particular, persistent entropy separates the two phases with an asymptotically non-vanishing gap.

Proof. We treat the two phases separately.

Ordered phase ($\lambda > \lambda_c$). By assumption (B), all bars in the limiting diagram $D_+$ have lifetimes at most $\varepsilon$. Since $D_+$ has finite total persistence, its normalized lifetime distribution is concentrated on uniformly small weights. Consequently, the persistent entropy of $D_+$ is small; in the limiting case in which all lifetimes vanish one has $PE(D_+) = 0$, and more generally $PE(D_+) \leq c(\varepsilon)$ for some function $c(\varepsilon) \to 0$ as $\varepsilon \to 0$. By assumption (A) and continuity of persistent entropy on the relevant class of diagrams,

$$
P E ( D _ { N } ( \lambda _ { + } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { + } ) .
$$

Disordered phase ($\lambda < \lambda_c$). By assumption (B), the limiting diagram $D_-$ contains at least one bar with lifetime $\ell^\star \geq \delta$. Let $L_-$ denote the total persistence of $D_-$. The normalized weight of this bar satisfies

$$
p _ { ^ { * } } = \frac { \ell _ { ^ { * } } } { L _ { - } } \geq \frac { \delta } { L _ { - } } > 0 . \\
$$

Therefore, the persistent entropy of D − admits the positive lower bound

$$
P E ( D _ { - } ) \geq - p _ { * } \log p _ { * } > 0 .
$$

Again by assumption (A) and continuity of persistent entropy,

$$
P E ( D _ { N } ( \lambda _ { - } ) ) \xrightarrow { \mathbb { P } } P E ( D _ { - } ) .
$$

Conclusion. Combining the two limits, there exists $\Delta > 0$ such that, with probability tending to one as $N \to \infty$,

$$
P E ( D _ { N } ( \lambda _ { - } ) ) - P E ( D _ { N } ( \lambda _ { + } ) ) \geq \Delta .
$$

This proves that persistent entropy separates the two phases with an asymptotically non-vanishing gap.

**Remark 1.**

Metric structure. Persistence diagrams do not carry a natural inner-product structure; all arguments are formulated in the metric setting induced by standard diagram distances. The inclusion of the diagonal with infinite multiplicity is essential for the definition of these metrics.

**Remark 2. Continuity of persistent entropy.** Persistent entropy is not uniformly continuous on the space of all persistence diagrams under the bottleneck distance, due to the instability induced by arbitrarily many near-diagonal bars. The theorem relies only on continuity along the convergent sequence of diagrams, which is ensured under mild regularity assumptions or by explicit truncation of small lifetimes.
