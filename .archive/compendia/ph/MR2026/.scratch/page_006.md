[Page 6]

This expresses the concentration of the random persistence diagram around a deterministic limiting diagram as system size increases.

Persistent entropy as a random variable. Persistent entropy is a real-valued functional

$$
P E \colon \mathcal { D } \longrightarrow \mathbb { R } _ { \geq 0 } ,
$$

defined from the multiset of persistence lifetimes $\ell_i = d_i - b_i$ of the off-diagonal points in the diagram via normalized weights

$$
p _ { i } = \frac { \ell _ { i } } { \sum _ { j } \ell _ { j } } , \quad P E ( D ) = - \sum p _ { i } \log p _ { i } ,
$$

whenever the total persistence $L = \sum_j \ell_j$ is finite and nonzero. Persistent entropy is not uniformly continuous on the space of all persistence diagrams under the bottleneck distance, due to the possible creation or annihilation of many near-diagonal bars at arbitrarily small metric cost. However, it is continuous on subclasses of diagrams with uniformly controlled small-scale structure, for instance, diagrams with finite total persistence and negligible contribution from arbitrarily short bars, or under explicit lifetime truncation. Throughout, we assume that the random diagrams $D_N(\lambda)$ lie with high probability in such a class, so that convergence in probability of diagrams imply convergence in probability of persistent entropy.

Interpretation. Within this framework, phase transitions are detected by identifying qualitative changes in the limiting persistence diagram as the control parameter crosses a critical value. The theorem below formalizes the fact that, whenever such changes involve the appearance or disappearance of macroscopic persistent features, persistent entropy must reflect this transition.

### 4.2 Main theorem

Let $\lambda \in \mathbb{R}$ be a control parameter (e.g. coupling strength or noise level). For each system size $N$ and parameter $\lambda$, assume we can construct a random persistence diagram $D_N(\lambda)$ from observational data (e.g. point clouds, weighted graphs, or embeddings) using a fixed filtration and a fixed homological degree $k$. Let $\lambda_c$ be a critical value separating two phases.

Theorem 1 (Persistent entropy detects phase transitions) . Assume the following conditions hold.

(A) Diagram convergence. There exist deterministic persistence diagrams $D_-$ and $D_+$ such that for every $\lambda < \lambda_c$,

$$
D _ { N } ( \lambda ) \xrightarrow { \mathbb { P } } D _ { - } ,
$$

and for every $\lambda > \lambda_c$,

$$
D _ { N } ( \lambda ) \xrightarrow { \mathbb { P } } D _ { + } ,
$$

with respect to a standard diagram metric. Moreover, the diagrams $D_N(\lambda)$, $D_-$, and $D_+$ lie in a class on which persistent entropy is continuous, and both $D_-$ and $D_+$ have finite total persistence.

(B) Macroscopic feature separation. There exist constants $\delta > 0$ and $\varepsilon > 0$ such that:

- for $\lambda < \lambda_c$, the limiting diagram $D_-$ contains at least one bar with lifetime at least $\delta$;
