[Page 3]

Next, we introduce the concept of intervals A finite poset $P$ is connected if for every pair $p,q \in P$ there is a sequence of points $p = r_1, \dots, r_t = q$ in $P$ so that $r_i \leq r_{i+1}$ or $r_{i+1} \leq r_i$ for all $i \in \{ 1, \dots, t - 1 \}$. An interval $I \subseteq P$ is a connected subposet that is convex w.r.t. poset order, i.e., if $p,q \in I$ and $p \leq r \leq q$, then $r \in I$. Figure 2 depicts an interval in $\mathbb{Z}^2$.

Our framework relies on the generalized rank Kim & Mémoli (2021) of a persistence module over a subposet $I \subseteq P$, which can be computed for $2$-parameter persistence modules with the algorithm Dey et al. (2024). The generalized rank of the module restricted to $I$ measures the multiplicity of the homological features (# of independent homological classes) that have support over the entire poset $I$. For example, in Figure 1, the generalized rank, for $H_0$, over the entire poset (light green) is 1 as one component survives throughout, while the generalized rank over the bottom row (light blue) is 3 and that over the bottom right square (light yellow) is 2.

Definition 2.2 (Generalized rank). Let $M \colon P \to \text{vec}$ be a persistence module, where $P$ is a finite connected poset. Let $M |_I$ denote the restriction of $M$ to a subposet $I$ of $P$. Then, the generalized rank of $M$ over $I$ is defined as the rank of the canonical linear map from $\lim M |_I$ to $\text{colim} M |_I$

$$
r k ^ { M } ( I ) \coloneqq \text {rank} \left ( \lim M | _ { I } \to \text {colim} M | _ { I } \right ) .
$$

We refer the reader to MacLane (1971) for the definitions of limit, colimit, and the construction of the canonical limit-to-colimit map.

A key property of generalized rank is its monotonicity: $\text{rk}^M ( I ) \leq \text{rk}^M ( J )$ for all $J \subseteq I$, where $I$ and $J$ are subposets in $P$. We use this to define $\mathbb{Z}\mathbb{Z}$-GRIL.

To extract the topological information from a quasi zigzag persistence module, we cover the quasi zigzag poset with a specific type of subposets called worms. A worm has a notion of a center and a width. Definition 3.3 gives precise definitions of these terms. We expand each of these worms, i.e., increase the widths while keeping the centers fixed. The monotonicity of the generalized rank ensures that the rank can only decrease by this expansion. In Figure 1(right) a subposet (rectangle) is expanded maximally to decrease the generalized rank from 3 to 1. The width for which the rank drops below a chosen threshold is taken as the $\mathbb{Z}\mathbb{Z}$-GRIL value. Definition 3.4 makes this concept precise. The set of $\mathbb{Z}\mathbb{Z}$-GRIL values at the chosen centers makes a vector that captures the topological information in the quasi zigzag persistence module.

## 3 ZZ-GRIL

In this section, we introduce concepts and definitions required for $\mathbb{Z}\mathbb{Z}$-GRIL. Then, we define $\mathbb{Z}\mathbb{Z}$-GRIL and discuss its theoretical properties.

Definition 3.1 (Zigzag poset). Zigzag poset $\mathbb{Z}\mathbb{Z}$ is defined as a subposet of $\mathbb{Z}^{\text{op}} \times \mathbb{Z}$ given by

$$
\mathbb { Z } \mathbb { Z } \coloneqq \{ ( i , j ) \colon i \in \mathbb { Z } , j \in \{ i , i - 1 \} \} ,
$$

where $\mathbb{Z}^{\text{op}}$ denotes the opposite poset of $\mathbb{Z}$.

Consider the poset $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ with the product order, i.e., $(z_1, z_2) \leq (w_1, w_2)$ if $z_1 \leq w_1$ in $\mathbb{Z}\mathbb{Z}$ and $z_2 \leq w_2$ in $\mathbb{Z}$. Note that $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ is equivalent to $\mathbb{Z}^2$ as sets. Thus, every subposet $I \subseteq \mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ can be thought as a subposet $I_{\mathbb{Z}^2} \subseteq \mathbb{Z}^2$ that is endowed with $\mathbb{Z}^2$ ordering. Observe that an interval in $\mathbb{Z}^2$ may not remain an interval in $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ and vice-versa.

We define a quasi zigzag bi-filtration as a collection of simplicial complexes $\{ K_p \}_{p \in \mathbb{Z}\mathbb{Z} \times \mathbb{Z}}$, where $K_p \subseteq K_q$ for all comparable $p \leq q$. Let $\text{vec}$ denote the category of finite dimensional vector spaces.

Definition 3.2 (Quasi zigzag persistence module). A persistence module $M \colon \mathbb{Z}\mathbb{Z} \times \mathbb{Z} \to \text{vec}$ is called a quasi zigzag persistence module.

We now define a special type of subposet in $\mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ which in $\mathbb{Z}^2$ is an $\ell$-worm introduced by Xin et al. (2023) for $\ell = 2$. Definition 3.3 (Worm). Let $p \in \mathbb{Z}\mathbb{Z} \times \mathbb{Z}$ and $\delta \in \mathbb{Z}$ be given. Let $p_\delta$ denote the $\delta$-square centered at $p$, i.e., $p_\delta \coloneqq \{ z \in \mathbb{Z}\mathbb{Z} \times \mathbb{Z} \colon \| p - z \|_\infty \leq \delta \}$. Then, a worm centered at $p$ with width $\delta$ is defined as the union of the two $\delta$-squares $q_\delta$ centered at points $q = p \pm (\delta, -\delta)$ on the off-diagonal line segment along with $p_\delta$. We denote the worm as $p^2_\delta$. The superscript denotes the number of $\delta$-squares in the union apart from $p_\delta$.

.
