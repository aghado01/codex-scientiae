[Page 48]

we have

$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M ( g _ { 1 } ) & 0 \\ M ( g _ { 3 } ) & M ( g _ { 2 } ) \end{bmatrix} - \text {rank} \begin{bmatrix} M ( g _ { 1 } ) & 0 \\ 0 & M ( g _ { 2 } ) \end{bmatrix} .
$$

For example, if \( c : \mathrm{sc}( \Uparrow I ) \to \mathrm{sc}( I ) \) and \( d : \mathrm{sk}( \Downarrow I ) \to \mathrm{sk}( I ) \) are choice maps, and \( ( b,a ) \in \mathrm{sk}( I ) \times \mathrm{sc}( I ) \) is a pair with \( b \ge a \), then \( g ( c , d , ( b,a ) ) \) is a multiplicity matrix for \( I \). See \( \tilde{g} \) in Example 6.5 for another type of multiplicity matrix.

Definition 4.12. Let \( \zeta : Z \to P \) be an order-preserving map with \( Z \) a poset, and \( I \) an interval of \( P \). Then we say that \( \zeta \) essentially covers \( I \) (or \( \zeta \) is an essential cover of \( I \)) if \( \zeta \) covers a multiplicity matrix for \( I \).

Remark 4.13. In Definition 4.12, we allow the cases where any matrices among \( g_1, g_2, g_3 \) are empty matrices. We also note to the reader that the formula (4.56) is a natural generalization of the well-known rank formula appearing in the one-parameter persistence case. In more detail, suppose \( P := A_n \) and the interval \( I := [s,t] \) (\( s,t \in [n] \)). If we set \( g_1 := p_{t+1, s} \), \( g_2 := p_{t, s-1} \), and \( g_3 := p_{t, s} \), then for any \( M \in \mathrm{mod}\,k[P] \) the right-hand side of (4.56) yields

$$
\begin{aligned}
$$
\begin{aligned}
\text {right-hand side of } & ( 4 . 5 ) \text { yields} \\ & \quad \text {rank} \left [ \frac { M _ { t + 1 , s } } { M _ { t , s } } \Big | _ { M _ { t , s - 1 } } \right ] - \text { rank } M _ { t + 1 , s } - \text { rank } M _ { t , s - 1 } \\ & \quad \equiv \text { rank} \left [ \frac { 0 } { M _ { t , s } } \Big | _ { \ M _ { t , s - 1 } } \right ] - \text { rank } M _ { t + 1 , s } - \text { rank } M _ { t , s - 1 } \\ & \quad \equiv \text { rank} \left [ \frac { 0 } { M _ { t , s } } \Big | _ { 0 } \Big | - M _ { t + 1 , s - 1 } \right ] - \text { rank } M _ { t + 1 , s } - \text { rank } M _ { t , s - 1 } \\ & = \text { rank } M _ { t , s } + \text { rank } M _ { t + 1 , s - 1 } - \text { rank } M _ { t + 1 , s } - \text { rank } M _ { t , s - 1 } \\ & = d _ { M } ( V _ { I } ) , \\
\end{aligned}
$$
\end{aligned}
$$

where the equality (a) follows by the elementary row operation that adds the product of \( -M_{t+1,t} \) and the second row block to the first row block, and the equality (b) follows by the elementary column operation that adds the product of the first column block and \( -M_{s,s-1} \) to the second column. The last equality is known as the formula of the persistent Betti numbers and the multiplicity in persistent homology (see (Edelsbrunner and Harer 2010, Chapter VII)).

We cite the following statement from (Asashiba et al. 2024, Lemma 6.8).

Lemma 4.14. Let \( B \) be a linear category, \( W \) a \( B \)-module, and \( g \) a morphism in \( B \). Assume that we have a direct sum decomposition \( W \cong W_1 \oplus W_2 \) of \( B \)-modules. Then we have an equivalence \( W(g) \cong W_1(g) \oplus W_2(g) \) of linear maps. In particular, the equality

$$
\ r a n k W ( g ) = r a n k W _ { 1 } ( g ) + r a n k W _ { 2 } ( g )
$$

holds.
