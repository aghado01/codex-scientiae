[Page 41]

This shows that

$$
$$
P ^ { \prime \prime } \oplus P _ { 0 } ( M ^ { \prime } ) \cong P _ { 1 } ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) ) .
$$
$$

Then again by the Krull–Schmidt theorem, (3.49) shows that

$$
$$
P _ { 0 } ( M ^ { \prime } ) \text { is a direct summand of } P _ { 0 } ( \Omega ( V _ { I } ) ) . \quad \square
$$
$$

For the general finite poset case, (3.45) is modified as follows, which become more coarse than the 2D-grid case.

Notation 3.49. Let \( M \in \operatorname{mod} A \). We set the first rough critical set of intervals of \( M \) to be

$$
$$
c r t _ { 1 } ^ { \prime } ( M ) \coloneqq \{ I \in c r t _ { 0 } ( M ) \ | \ s c ( \uparrow I ) \subseteq \sup p ( \text {top} \, P _ { 1 } ( M ) ) , \, \text {sk} ( \downarrow I ) \subseteq \sup p ( \text {soc} \, Q ^ { 1 } ( M ) ) \} .
$$
$$

Then we immediately obtain the following by Proposition 3.48.

Proposition 3.50. Let \( M \in \operatorname{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then

$$
$$
I \in c r t _ { 1 } ^ { \prime } ( M ) .
$$
$$

Furthermore, Theorem 3.27 gives another easy criterion for an interval module to be a direct summand of a given module as follows.

Proposition 3.51. Let \( M \in \operatorname{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then \( M_{b,a} \neq 0 \) for any \( ( a,b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \).


*Proof.* If \( M_{b,a} = 0 \) for some \( ( a, b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \), then \( d_M ( V_I ) = 0 \) by Theorem 3.27. Or more directly, for any pair \( ( a, b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \), we have \( ( V_I )_{b,a} \neq 0 \) as it is the identity map \( k \to k \). Hence if \( V_I \) is a direct summand of \( M \), say \( M = L \oplus N \) with \( L \cong V_I \), then since \( L_{b,a} \neq 0 \), we have \( M_{b,a} = L_{b,a} \oplus N_{b,a} \neq 0 \). \(\square\)




We remark that the statement above also follows from (Asashiba et al. 2024, Theorem 5.23) applied for the total compression system.

Notation 3.52. Let \( M \in \operatorname{mod} A \). We introduce a new invariant \( \operatorname{zp}( M ) \) of \( M \), called the set of zero pairs of \( M \) as follows:

$$
$$
z p ( M ) \coloneqq \{ ( a , b ) \in \sup p ( \text {top} \, M ) \times \sup p ( \text {soc} \, M ) \ | \ a \leq b , M _ { b , a } = 0 \} .
$$
$$

We set the zp critical set of intervals of \( M \) to be

$$
$$
\ c r t _ { z p } ( M ) & \coloneqq \{ I \in \mathbb { I } \ | \ M _ { b , a } \neq 0 \text { for all } ( a , b ) \in \text { sc} ( I ) \times \text { sk} ( I ) \text { with } a \leq b \} \\ & = \{ I \in \mathbb { I } \ | \ ( \text {sc} ( I ) \times \text { sk} ( I ) ) \cap z p ( M ) = \emptyset \} .
$$
$$


For each \( i \geq 0 \), we also set

$$
$$
\ c r t _ { i , z p } ( M ) \coloneqq c r t _ { i } ( M ) \cap c r t _ { z p } ( M ) , \ c r t _ { 1 , z p } ^ { \prime } ( M ) \coloneqq c r t _ { 1 } ^ { \prime } ( M ) \cap c r t _ { z p } ( M ) .
$$
$$
