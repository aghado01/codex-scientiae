# Manifest: Page 041

## REPAIR_MATH
- RAW: ```
P ^ { \prime \prime } \oplus P _ { 0 } ( M ^ { \prime } ) \cong P _ { 1 } ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) ) .
```
  FIX: ```
$$
P ^ { \prime \prime } \oplus P _ { 0 } ( M ^ { \prime } ) \cong P _ { 1 } ^ { \prime } \oplus P _ { 0 } ( \Omega ( V _ { I } ) ) .
$$
```
- RAW: ```
P _ { 0 } ( M ^ { \prime } ) \text { is a direct summand of } P _ { 0 } ( \Omega ( V _ { I } ) ) . \quad \square
```
  FIX: ```
$$
P _ { 0 } ( M ^ { \prime } ) \text { is a direct summand of } P _ { 0 } ( \Omega ( V _ { I } ) ) . \quad \square
$$
```
- RAW: ```
c r t _ { 1 } ^ { \prime } ( M ) \coloneqq \{ I \in c r t _ { 0 } ( M ) \ | \ s c ( \uparrow I ) \subseteq \sup p ( \text {top} \, P _ { 1 } ( M ) ) , \, \text {sk} ( \downarrow I ) \subseteq \sup p ( \text {soc} \, Q ^ { 1 } ( M ) ) \} .
```
  FIX: ```
$$
c r t _ { 1 } ^ { \prime } ( M ) \coloneqq \{ I \in c r t _ { 0 } ( M ) \ | \ s c ( \uparrow I ) \subseteq \sup p ( \text {top} \, P _ { 1 } ( M ) ) , \, \text {sk} ( \downarrow I ) \subseteq \sup p ( \text {soc} \, Q ^ { 1 } ( M ) ) \} .
$$
```
- RAW: ```
I \in c r t _ { 1 } ^ { \prime } ( M ) .
```
  FIX: ```
$$
I \in c r t _ { 1 } ^ { \prime } ( M ) .
$$
```
- RAW: ```
z p ( M ) \coloneqq \{ ( a , b ) \in \sup p ( \text {top} \, M ) \times \sup p ( \text {soc} \, M ) \ | \ a \leq b , M _ { b , a } = 0 \} .
```
  FIX: ```
$$
z p ( M ) \coloneqq \{ ( a , b ) \in \sup p ( \text {top} \, M ) \times \sup p ( \text {soc} \, M ) \ | \ a \leq b , M _ { b , a } = 0 \} .
$$
```
- RAW: ```
\ c r t _ { z p } ( M ) & \coloneqq \{ I \in \mathbb { I } \ | \ M _ { b , a } \neq 0 \text { for all } ( a , b ) \in \text { sc} ( I ) \times \text { sk} ( I ) \text { with } a \leq b \} \\ & = \{ I \in \mathbb { I } \ | \ ( \text {sc} ( I ) \times \text { sk} ( I ) ) \cap z p ( M ) = \emptyset \} .
```
  FIX: ```
$$
\ c r t _ { z p } ( M ) & \coloneqq \{ I \in \mathbb { I } \ | \ M _ { b , a } \neq 0 \text { for all } ( a , b ) \in \text { sc} ( I ) \times \text { sk} ( I ) \text { with } a \leq b \} \\ & = \{ I \in \mathbb { I } \ | \ ( \text {sc} ( I ) \times \text { sk} ( I ) ) \cap z p ( M ) = \emptyset \} .
$$
```
- RAW: ```
\ c r t _ { i , z p } ( M ) \coloneqq c r t _ { i } ( M ) \cap c r t _ { z p } ( M ) , \ c r t _ { 1 , z p } ^ { \prime } ( M ) \coloneqq c r t _ { 1 } ^ { \prime } ( M ) \cap c r t _ { z p } ( M ) .
```
  FIX: ```
$$
\ c r t _ { i , z p } ( M ) \coloneqq c r t _ { i } ( M ) \cap c r t _ { z p } ( M ) , \ c r t _ { 1 , z p } ^ { \prime } ( M ) \coloneqq c r t _ { 1 } ^ { \prime } ( M ) \cap c r t _ { z p } ( M ) .
$$
```


## REPAIR_PROSE
- RAW: ```
Then again by the Krull–Schmidt theorem, ( 3.49 ) shows that
```
  FIX: ```
Then again by the Krull–Schmidt theorem, (3.49) shows that
```
- RAW: ```
For the general finite poset case, ( 3.45 ) is modified as follows, which become more coarse than the 2D-grid case.
```
  FIX: ```
For the general finite poset case, (3.45) is modified as follows, which become more coarse than the 2D-grid case.
```
- RAW: ```
Notation 3.49. Let M ∈ mod A . We set the first rough critical set of intervals of M to be
```
  FIX: ```
Notation 3.49. Let \( M \in \operatorname{mod} A \). We set the first rough critical set of intervals of \( M \) to be
```
- RAW: ```
Then we immediately obtain the following by Proposition 3.48 .
```
  FIX: ```
Then we immediately obtain the following by Proposition 3.48.
```
- RAW: ```
Proposition 3.50. Let M ∈ mod A and I ∈ I . If V I is a direct summand of M , then
```
  FIX: ```
Proposition 3.50. Let \( M \in \operatorname{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then
```
- RAW: ```
Proposition 3.51. Let M ∈ mod A and I ∈ I . If V I is a direct summand of M , then M b,a ̸ = 0 for any ( a,b ) ∈ sc( I ) × sk( I ) with a ≤ b .
```
  FIX: ```
Proposition 3.51. Let \( M \in \operatorname{mod} A \) and \( I \in \mathbb{I} \). If \( V_I \) is a direct summand of \( M \), then \( M_{b,a} \neq 0 \) for any \( ( a,b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \).
```
- RAW: ```
Proof If M b,a = 0 for some ( a, b ) ∈ sc( I ) × sk( I ) with a ≤ b , then d M ( V I ) = 0 by Theorem 3.27 . Or more directly, for any pair ( a, b ) ∈ sc( I ) × sk( I ) with a ≤ b , we have ( V I ) b,a ̸ = 0 as it is the identity map k → k . Hence if V I is a direct summand of M , say M = L ⊕ N with L ∼ = V I , then since L b,a ̸ = 0 , we have M b,a = L b,a ⊕ N b,a ̸ = 0 . □
```
  FIX: ```
*Proof.* If \( M_{b,a} = 0 \) for some \( ( a, b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \), then \( d_M ( V_I ) = 0 \) by Theorem 3.27. Or more directly, for any pair \( ( a, b ) \in \operatorname{sc}( I ) \times \operatorname{sk}( I ) \) with \( a \leq b \), we have \( ( V_I )_{b,a} \neq 0 \) as it is the identity map \( k \to k \). Hence if \( V_I \) is a direct summand of \( M \), say \( M = L \oplus N \) with \( L \cong V_I \), then since \( L_{b,a} \neq 0 \), we have \( M_{b,a} = L_{b,a} \oplus N_{b,a} \neq 0 \). \(\square\)
```
- RAW: ```
We remark that the statement above also follows from ( Asashiba et al. 2024 , Theorem 5.23) applied for the total compression system.
```
  FIX: ```
We remark that the statement above also follows from (Asashiba et al. 2024, Theorem 5.23) applied for the total compression system.
```
- RAW: ```
Notation 3.52. Let M ∈ mod A . We introduce a new invariant zp( M ) of M , called the set of zero pairs of M as follows:
```
  FIX: ```
Notation 3.52. Let \( M \in \operatorname{mod} A \). We introduce a new invariant \( \operatorname{zp}( M ) \) of \( M \), called the set of zero pairs of \( M \) as follows:
```
- RAW: ```
We set the zp critical set of intervals of M to be
```
  FIX: ```
We set the zp critical set of intervals of \( M \) to be
```
- RAW: ```
For each i ≥ 0 , we also set
```
  FIX: ```
For each \( i \geq 0 \), we also set
```
