# Manifest: Page 036

## REPAIR_MATH
- RAW: ```
and M 4 ′ , 4 to be [ 1 0 ] and [ 1 0 0 ] , respectively, then
```
  FIX: ```
and \( M_{4', 4} \) to be \( \begin{bmatrix} 1 \\ 0 \end{bmatrix} \) and \( \begin{bmatrix} 1 & 0 & 0 \end{bmatrix} \), respectively, then
```
- RAW: ```
-







1 0 0


0 0 0






-


0 1 0


0 0 0







1 0 0

1 0 0










.

(

) =





1 0 0





0 0 0


0 0 0







0 0 1





0 0 0


0 0 1





0 0 1






0 0 0


1 0 0

-



0 1 0







0 1 0


-


```
  FIX: ```
```
- RAW: ```
Hence d M ′ ( V I ) = 1 , which coincides with the answer obtained from the decomposition M ′ ∼ = V I ⊕ V [1 , 4] ⊕ V [ { 2 , 1 ′ } , 4 ′ ] . These decompositions can be easily seen by drawing the structure quivers of M,M ′ :
```
  FIX: ```
Hence \( d_{M'}(V_I) = 1 \), which coincides with the answer obtained from the decomposition \( M' \cong V_I \oplus V_{[1, 4]} \oplus V_{[\{2, 1'\}, 4']} \). These decompositions can be easily seen by drawing the structure quivers of \( M, M' \):
```
- RAW: ```
1 ′ x 2 ′ x 3 ′ x 4 ′ 1 ′ y 2 ′ y 3 ′ y 2 x 3 x 4 x 2 y 3 y 4 y 1 2 z 3 z 4 z ,
```
  FIX: ```
```
- RAW: ```
where M is given by solid arrows, and M ′ is given by both solid and broken arrows, bases of M ( i ) are denoted by i or i a ( a ∈ { x,y,z } ) for all i ∈ P .
```
  FIX: ```
where \( M \) is given by solid arrows, and \( M' \) is given by both solid and broken arrows, bases of \( M(i) \) are denoted by \( i \) or \( i_a \) (\( a \in \{x, y, z\} \)) for all \( i \in P \).
```
- RAW: ```
Given a module M ∈ mod A , we reduce the number of intervals I ∈ I to compute the multiplicity d M ( V I ) by removing some intervals I such that V I cannot be a direct summand of M , namely I with d M ( V I ) = 0 , by an easy criterion.
```
  FIX: ```
Given a module \( M \in \operatorname{mod} A \), we reduce the number of intervals \( I \in \mathcal{I} \) to compute the multiplicity \( d_M(V_I) \) by removing some intervals \( I \) such that \( V_I \) cannot be a direct summand of \( M \), namely \( I \) with \( d_M(V_I) = 0 \), by an easy criterion.
```
- RAW: ```
We set the support of M to be
```
  FIX: ```
We set the support of \( M \) to be
```
- RAW: ```
\sup P M \colon = \{ x \in P \, | \, M ( x ) \neq 0 \} .
```
  FIX: ```
$$
\operatorname{supp}_P M \coloneqq \{ x \in P \mid M(x) \neq 0 \}.
$$
```
- RAW: ```
We denote by rad M the radical of M , which is, by definition, the intersection of all maximal submodules of M , and set top M : = M/ rad M , called the top of M . Dually, we set soc M to be the sum of all simple submodules of M , called the socle of M . Recall that an epimorphism P → M with P projective is a projective cover of M if and only if it induces an isomorphism top P → top M . Dually, a monomorphism M → Q with Q injective is an injective hull of M if and only if it restricts to an isomorphism soc M → soc Q . It is easy to see that if N is a direct summand of M , then top N (resp. soc N ) is a direct summand of top M (resp. soc M ). Hence
```
  FIX: ```
We denote by \( \operatorname{rad} M \) the radical of \( M \), which is, by definition, the intersection of all maximal submodules of \( M \), and set \( \operatorname{top} M \coloneqq M / \operatorname{rad} M \), called the top of \( M \). Dually, we set \( \operatorname{soc} M \) to be the sum of all simple submodules of \( M \), called the socle of \( M \). Recall that an epimorphism \( P \to M \) with \( P \) projective is a projective cover of \( M \) if and only if it induces an isomorphism \( \operatorname{top} P \to \operatorname{top} M \). Dually, a monomorphism \( M \to Q \) with \( Q \) injective is an injective hull of \( M \) if and only if it restricts to an isomorphism \( \operatorname{soc} M \to \operatorname{soc} Q \). It is easy to see that if \( N \) is a direct summand of \( M \), then \( \operatorname{top} N \) (resp. \( \operatorname{soc} N \)) is a direct summand of \( \operatorname{top} M \) (resp. \( \operatorname{soc} M \)). Hence
```
- RAW: ```
\sup ( \text {top} N ) \subseteq \sup ( \text {top} M ) \ \text { and } \ \sup ( \text {soc} N ) \subseteq \sup ( \text {soc} M ) .
```
  FIX: ```
$$
\operatorname{supp}(\operatorname{top} N) \subseteq \operatorname{supp}(\operatorname{top} M) \quad \text{and} \quad \operatorname{supp}(\operatorname{soc} N) \subseteq \operatorname{supp}(\operatorname{soc} M).
$$
```
