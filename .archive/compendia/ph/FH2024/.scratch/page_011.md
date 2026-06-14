[Page 11]

Theorem 2.23 Let I ⊂ P be an interval. Then, rank( M | I ) = rank( M ∂I ) .

Remark 2.24 In other words, this theorem allows us to compute the rank over an interval by computing the rank of a zigzag module that is somehow related to the boundary of that interval. As a consequence, it is sufficient to compute ranks of zigzag modules in order to compute generalized ranks over intervals. Hence, any algorithm that computes barcodes of zigzag modules is suitable for the computation of generalized ranks.

Remark 2.25 Note that in the proof of the last theorem we did not use the special construction of Γ ∂I as the concatenation of Γ min and Γ max . In fact, only the properties of lower and upper fences were used. Hence, Theorem 2.23 holds for any path Γ that is composed of a path through a lower fence, any arbitrary path between the lower and the upper fence and a path through an upper fence.

# 3 Spatiotemporal persistence landscapes

# 3.1 Definition

We define the underlying poset of the extended zigzag module, which we denote by ( ZZ × , ≪ ) , as follows: ZZ := as a set and

$$
\[
\[
( a , b ) \ll ( a ^ { \prime } , b ^ { \prime } ) \Leftrightarrow b \leq b ^ { \prime } \text { and } \begin{cases} a = a ^ { \prime } - 1 & \text {for } a = 2 z + 1 \text { for some } z \in \mathbb { Z } , \\ a = a ^ { \prime } + 1 & \text {else.} \end{cases}
\]
\]
$$

We equip the set ZZ × with the maximum metric d m as in 2 , i.e. d m ( x,y ) = max {| x 1 − y 1 | , | x 2 − y 2 |} . Furthermore, we define regions R ε x in the parameter space around a point x ∈ ZZ × as balls around x with radius ε with respect to the maximum norm, so R ε x = { y ∈ ZZ × : y = x + h with h ∈ ZZ × , d m ( h, 0) ≤ ε } . Analogously to [40], but adapted to our case of a discrete poset, we define persistence landscapes.

Definition 3.1 The k -th persistence landscape λ k of a persistence module M : ZZ × → vec considers the maximal radius over which k features persist in every (positive) direction through x in the parameter space

$$
\[
\[
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \colon \, \text {rank} ( M | _ { R _ { x } ^ { \varepsilon } } ) \geq k \} .
\]
\]
$$

The persistence landscape λ of M is the map λ : × ZZ × → , ( k,x )  → λ k ( x ) .

We want to regard landscapes as functions taking values in , not as in the definition in the extended real numbers . To assure this, in the following we exclude infinite indecomposables in our persistence module M .

Remark 3.2 In this work, we restrict our attention to quadratic regions R ε x . However, choosing the region we implicitly chose a weight on the spatial and temporal direction. To be precise, the dimensions in space and time are treated equally. In the case where one is interested in treating them differently one could simply consider rectangular regions instead of quadratic regions. The definitions and algorithms can be adapted to this case in a straight forward way.
