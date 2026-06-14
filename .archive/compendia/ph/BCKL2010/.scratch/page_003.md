[Page 3]

We now summarize this paper. In Section 2 we will lay down the topological preliminaries needed to state our main results. In Section 3, we go over the preliminaries needed for nonparametric regression on a Riemannian manifold. Section 4 states the main results where sharp sup-norm minimax bounds consisting of constant and rate, and sharp sup-norm estimators are presented. The connection to bounding the persistent homology estimators thus ensues. Following this in Section 5, a brief discussion of the implementation is given. Proofs to the main results are collected in Section 6. An Appendix that contains some technical material is included for completeness.

## 2. Topological Preliminaries

Let us assume that M is a d − dimensional compact Riemannian manifold and suppose f : M → R is some smooth function. Consider the sublevel set, or, lower excursion set,

$$
( 2 . 1 ) & \quad \mathbb { M } _ { f \leq r } \colon = \{ x \in \mathbb { M } \ | \ f ( x ) \leq r \} = f ^ { - 1 } ( ( - \infty , r ] ) . \\ \intertext { l } \mathbb { I } _ { i } \ a o f i n t o o t \ t o \ n o t o \ t h o t \ f o r \ o n t o i n \ o l o c a o \ o f \ a m o o t h \ f o n t i o n
$$

It is of interest to note that for certain classes of smooth functions, the topology of M can be approached by studying the geometry of the function.

To be more precise, for some smooth f : M → R , consider a point p ∈ M where in local coordinates the derivatives, ∂f/∂x j vanishes. Then that point is called a critical point, and the evaluation f ( p ) is called a critical value. A critical point p ∈ M is called non-degenerate if the Hessian ( ∂ 2 f/∂ i ∂ j ) is nonsingular. Such functions are called Morse
