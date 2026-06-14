[Page 49]

Before giving the main theorem, we need the following notation.

Notation 4.15. Let \( M \in \operatorname{mod} k[P] \) . If \( M \cong L^n \oplus N \) with \( n \ge 0 \) such that N has no direct summand isomorphic to L , then we set \( \bar{d}_M(L) := n \) . In particular, if L is indecomposable, then \( \bar{d}_M(L) \) coincides with \( d_M(L) \) . Moreover, by the Krull– Schmidt theorem, we easily see that if \( L = \bigoplus_{i \in [m]} L_i \) for some \( m \ge 1 \) with each \( L_i \) indecomposable, then \( \bar{d}_M(L) = \min_{i \in [m]} d_M(L_i) \) .

We are now in a position to state our main result in this section.

Theorem 4.16. Let \( \zeta : Z \to P \) be an order-preserving map with \( Z \) a poset, and \( R : \operatorname{mod} k[P] \to \operatorname{mod} k[Z] \) the restriction functor induced by \( \zeta \). Take an interval \( I \) of \( P \). If \( \zeta \) essentially covers \( I \), then for any \( M \in \operatorname{mod} A \), we have

$$
d _ { M } ( V _ { I } ) = \bar { d } _ { R ( M ) } ( R ( V _ { I } ) ) .
$$

Proof Assume that \( \zeta \) essentially covers \( I \). Then there exists \( g := \left[\begin{smallmatrix} g_1 & 0 \\ g_3 & g_2 \end{smallmatrix}\right] \) in \( k[P] \) such that for any M ∈ mod A we have a formula

$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M ( g _ { 1 } ) & 0 \\ M ( g _ { 3 } ) & M ( g _ { 2 } ) \end{bmatrix} - \text {rank} \begin{bmatrix} M ( g _ { 1 } ) & 0 \\ 0 & M ( g _ { 2 } ) \end{bmatrix} ,
$$

and \( \zeta \) covers \( g \), say \( \zeta(g') = g \) for some \( g' \) in \( k[Z] \). Let \( g_{vu} \) (resp. \( g'_{vu} \)) be the \( (v, u) \)-entry of \( g \) (resp. \( g' \)). Then

$$
M ( g _ { v u } ) = M ( \zeta ( g _ { v u } ^ { \prime } ) ) = R ( M ) ( g _ { v u } ^ { \prime } ) .
$$

Thus we have \( M(g_i) = R(M)(g'_i) \) for all \( i = 1, 2, 3 \). Hence

$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \begin{matrix} R ( M ) ( g _ { 1 } ^ { \prime } ) & 0 \\ R ( M ) ( g _ { 3 } ^ { \prime } ) & R ( M ) ( g _ { 2 } ^ { \prime } ) \end{matrix} \right ] - \text {rank} \left [ \begin{matrix} R ( M ) ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & R ( M ) ( g _ { 2 } ^ { \prime } ) \end{matrix} \right ] .
$$

Set here \( r := d_M(V_I) \), \( s := \bar{d}_{R(M)}(R(V_I)) \). Then it is enough to show that \( r = s \). By the former, we have \( M \cong V_I^r \oplus N \) for some module N in \( \operatorname{mod} k[P] \), which shows that \( R(M) \cong R(V_I)^r \oplus R(N) \). Hence we have \( r \le s \). On the other hand, by the latter we have an isomorphism \( R(M) \cong R(V_I)^s \oplus L \) for some module L in \( \operatorname{mod} k[Z] \). Then by Lemma 4.14 , we have the following equalities:

$$
\text {rank} \begin{bmatrix} R ( M ) ( g _ { 1 } ^ { \prime } ) & 0 \\ R ( M ) ( g _ { 3 } ^ { \prime } ) & R ( M ) ( g _ { 2 } ^ { \prime } ) \end{bmatrix} = s \text {rank} \begin{bmatrix} R ( V _ { I } ) ( g _ { 1 } ^ { \prime } ) & 0 \\ R ( V _ { I } ) ( g _ { 3 } ^ { \prime } ) & R ( V _ { I } ) ( g _ { 2 } ^ { \prime } ) \end{bmatrix} + \text {rank} \begin{bmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ L ( g _ { 3 } ^ { \prime } ) & L ( g _ { 2 } ^ { \prime } ) \end{bmatrix} , \\
$$

and

$$
\text {rank} \begin{bmatrix} R ( M ) ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & R ( M ) ( g _ { 2 } ^ { \prime } ) \end{bmatrix} = s \text {rank} \begin{bmatrix} R ( V _ { I } ) ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & R ( V _ { I } ) ( g _ { 2 } ^ { \prime } ) \end{bmatrix} + \text {rank} \begin{bmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & L ( g _ { 2 } ^ { \prime } ) \end{bmatrix} . \tag{4.57}
$$

Note that the formula ( 4.57 ) holds also for \( M = V_I \) . Thus we have

$$
d _ { V _ { I } } ( V _ { I } ) = \text {rank} \left [ \begin{matrix} R ( V _ { I } ) ( g _ { 1 } ^ { \prime } ) & 0 \\ R ( V _ { I } ) ( g _ { 3 } ^ { \prime } ) & R ( V _ { I } ) ( g _ { 2 } ^ { \prime } ) \end{matrix} \right ] - \text {rank} \left [ \begin{matrix} R ( V _ { I } ) ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & R ( V _ { I } ) ( g _ { 2 } ^ { \prime } ) \end{matrix} \right ] .
$$

By the equalities ( 4.57 ), ( 4.58 ), ( 4.59 ), and ( 4.60 ), we see that

$$
r = d _ { M } ( V _ { I } ) = s \cdot d _ { V _ { I } } ( V _ { I } ) + \text {rank} \left [ \begin{smallmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ L ( g _ { 3 } ^ { \prime } ) & L ( g _ { 2 } ^ { \prime } ) \end{smallmatrix} \right ] - \text {rank} \left [ \begin{smallmatrix} L ( g _ { 1 } ^ { \prime } ) & 0 \\ 0 & L ( g _ { 2 } ^ { \prime } ) \end{smallmatrix} \right ]
$$
