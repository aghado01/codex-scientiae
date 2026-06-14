[Page 5]

## 4 Algorithm

We discuss the details of computing $\mathbb{ZZ}$-GRIL in this section. We begin by proving that generalized rank over a finite subposet in $\mathbb{ZZ} \times \mathbb{Z}$ can also be computed by computing the number of full bars in the zigzag filtration along the “boundary” of the subposet. To be precise, we introduce the following concepts now. Let $P$ be any finite connected poset. We say a point $q \in P$ covers a point $p \in P$, denoted $p \prec q$ or $q \succ p$, if $p \leq q$ and there is no $r \in P$, $r \neq p, q$, so that $p \leq r \leq q$. A covering path $p \sim q$ between $p$ and $q$ is either a set of points $\{p = p_0 \prec p_1 \prec \dots \prec p_\ell = q\}$ or $\{p = p_0 \succ p_1 \succ \dots \succ p_\ell = q\}$. We define some special points in $P$. The set of minima in $P$ are the points $P_{\min} = \{p \in P \mid \not\exists r \neq p \in P \text{ where } r \leq p\}$. Similarly, define the set of maxima $P_{\max}$. For any two points $p, q \in P$, let $p \vee q$ and $p \wedge q$ denote their least upper bound (lub) and largest lower bound (llb) in $P$ if they exist.



Now consider a finite subposet $I \subseteq \mathbb{ZZ} \times \mathbb{Z}$ whose counterpart $I^{\mathbb{Z}^2}$ with $\mathbb{Z}^2$ ordering becomes an interval. Since $I^{\mathbb{Z}^2} \subset \mathbb{Z}^2$, its points can be sorted with increasing $x$-coordinates in $\mathbb{Z}^2$. Let $I^{\mathbb{Z}^2}_{\min} = \{p_0, \dots, p_s\}$ and $I^{\mathbb{Z}^2}_{\max} = \{q_0, \dots, q_t\}$ be the set of minima and maxima respectively sorted according to their $x$-coordinates. The lower fence and upper fence of $I^{\mathbb{Z}^2}$ are defined as the paths

$$
\begin{aligned}
L _ { I } ^ { \mathbb { Z } ^ { 2 } } & \colon = p _ { 0 } \sim ( p _ { 0 } \vee p _ { 1 } ) \sim p _ { 1 } \sim ( p _ { 1 } \vee p _ { 2 } ) \sim p _ { 2 } \sim \cdots \sim p _ { s } \\ U _ { I } ^ { \mathbb { Z } ^ { 2 } } & \colon = q _ { 0 } \sim ( q _ { 0 } \wedge q _ { 1 } ) \sim q _ { 1 } \sim ( q _ { 1 } \wedge q _ { 2 } ) \sim q _ { 2 } \sim \cdots \sim q _ { t } .
\end{aligned}
$$

Consider the boundary $B_I^{\mathbb{Z}^2}$ comprising $L_I^{\mathbb{Z}^2}$, $U_I^{\mathbb{Z}^2}$, the paths $p_0 \sim q_0$ and $p_s \sim q_t$ going through the top left and bottom right corner points of $I^{\mathbb{Z}^2}$ respectively. Consider the subposet $I \subseteq \mathbb{ZZ} \times \mathbb{Z}$ and observe that $I_{\min}, I_{\max} \subseteq B_I^{\mathbb{Z}^2}$ because all other points have one point below and another above in the $y$-direction. Let $\partial_L I$, $\partial_U I$, and $\partial I$ be minimal paths in $B_I^{\mathbb{Z}^2}$ connecting all minima in $I_{\min}$, all maxima in $I_{\max}$, and all minima, maxima together respectively. Drawing an analogy to Dey et al. (2024) we call $\partial I$ a boundary cap which is drawn orange in Figure 4.

Next, we appeal to certain results in category theory to claim a result analogous to Dey et al. (2024) that helps computing the generalized ranks with zigzag persistence modules.

Definition 4.1. A connected subposet $P' \subseteq P$ is called initial if for every $p \in P \setminus P'$, the downset $\downarrow p = \{q \in P \mid q \neq p \text{ \& } q \leq p\}$ intersects $P'$ in a connected poset. Similarly, $P'$ is called terminal if for every $p \in P \setminus P'$, the upset $\uparrow p = \{q \in P \mid q \neq p \text{ \& } q \geq p\}$ intersects $P'$ in a connected poset.



Definition 4.2. We call a functor $F \colon P' \to P$ for $P' \subseteq P$ initial if $P'$ is initial. Similarly, we call $F \colon P \to P'$ terminal if $P'$ is terminal.

Treating $I$ as a category with points in $I$ as objects and relations as morphisms, we get $\partial_L I$ and $\partial_U I$ as subcategories. Then, we get functors $F_L \colon \partial_L I \to I$ induced by inclusion and $F_U \colon I \to \partial_U I$ induced by projection.

Proposition 4.3. $F_L \colon \partial_L I \to I$ is an initial functor and $F_U \colon I \to \partial_U I$ is a terminal functor.

Proof. It is sufficient to prove that $\partial_L I$ is initial for $F_L$ and $\partial_U I$ is terminal for $F_U$. We only show that $\partial_L I$ is initial and the proof for $\partial_U I$ being terminal is similar.

Let $p \in I \setminus \partial_L I$ be any point. Let $p^-$ and $p^+$ be two points (if exist) where $p^- \prec p$ and $p^+ \succ p$ in $\mathbb{Z}^2$ with $p^-_x < p_x < p^+_x$. By definition of the quasi zigzag poset, either $p^- > p$ and $p^+ > p$, or $p^- < p$ and $p^+ < p$ in the poset $\mathbb{ZZ} \times \mathbb{Z}$.

In the first case, the downset $\downarrow p$ consists of all points $p' \neq p$ that are vertically below $p$, that is, $p'_x = p_x$ and $p'_y < p_y$. This means $\downarrow p$ intersects $\partial_L I$ in a connected poset $p'_0 < \dots < p'_k$ where each $p'_i$ has the same $x$-coordinate as $p$.


In the second case, the downset $\downarrow p$ consists of three sets of points $Y_{p^-}$, $Y_p$, and $Y_{p^+}$ that are vertically below $p^-$, $p$, and $p^+$ respectively. Each of $Y_{p^-}$, $Y_p$ and $Y_{p^+}$ intersects $\partial_L I$ in a connected poset. They can be disconnected as a whole only if there is a point $q \in \partial_L I$ so that $p^-_x < q_x < p_x$ or $p_x < q_x < p^+_x$. But, neither is possible because $p^-$ and $p^+$ are points in $I$ covered by $p$.

The following result connecting initial (terminal) functor to the limit (colimit) is well known, [Chapter 8] Riehl (2014).

Proposition 4.4. Let $M \colon I \to \mathsf{vec}$ be a persistence module and $F_L \colon \partial_L I \to I$ and $F_U \colon I \to \partial_U I$ be initial and terminal functors. Then, there is an isomorphism $\phi \colon \lim M \to \lim M|_{\partial_L I}$ from the limit of $M$ to the limit of the restricted module $M|_{\partial_L I}$. Similarly, we have an isomorphism for colimits, $\psi \colon \operatorname{colim} M|_{\partial_U I} \to \operatorname{colim} M$.

Proposition 4.5. $\partial (\partial_L I) = \partial_L I$ and $\partial (\partial_U I) = \partial_U I$.

Proof. The proof is immediate from the definitions.
