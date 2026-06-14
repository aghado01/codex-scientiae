# Manifest: Page 008

## REPAIR_PROSE
- RAW: ```
oneparameter
```
  FIX: ```
one-parameter
```

## REPAIR_MATH
- RAW: ```
for every p ≤ q in I it holds that M ( p ≤ q ) ◦ π p = π q and i q ◦ M ( p ≤ q ) = i p . This implies that i p ◦ π p = i q ◦ π q for all p,q ∈ I . This map ψ M | I := i p ◦ π p
```
  FIX: ```
for every \( p \leq q \) in \( I \) it holds that \( M ( p \leq q ) \circ \pi_p = \pi_q \) and \( i_q \circ M ( p \leq q ) = i_p \). This implies that \( i_p \circ \pi_p = i_q \circ \pi_q \) for all \( p,q \in I \). This map \( \psi_{ M | I } := i_p \circ \pi_p \)
```
- RAW: ```
an interval I of a persistence module M is defined as rank( M | I ) := rank( ψ M | I ) , where ψ M | I is the canonical limit-to-colimit map i p ◦ π p for any p ∈ I .
```
  FIX: ```
an interval \( I \) of a persistence module \( M \) is defined as \( \text{rank}( M | I ) := \text{rank}( \psi_{ M | I } ) \), where \( \psi_{ M | I } \) is the canonical limit-to-colimit map \( i_p \circ \pi_p \) for any \( p \in I \).
```
- RAW: ```
the generalized rank of M over an interval I equals the number of intervals in the direct sum decomposition of M that contain I and hence
```
  FIX: ```
the generalized rank of \( M \) over an interval \( I \) equals the number of intervals in the direct sum decomposition of \( M \) that contain \( I \) and hence
```
- RAW: ```
Let Int( P ) be the set of intervals of the poset P .
```
  FIX: ```
Let \( \text{Int}( P ) \) be the set of intervals of the poset \( P \).
```
- RAW: ```
\ r k \colon \text {Int} ( P ) \to \mathbb { N } _ { 0 } , \ \ I \mapsto \text {rank} ( M | _ { I } ) = \text {rank} ( \psi _ { M | _ { I } } ) .
```
  FIX: ```
$$
\ r k \colon \text {Int} ( P ) \to \mathbb { N } _ { 0 } , \ \ I \mapsto \text {rank} ( M | _ { I } ) = \text {rank} ( \psi _ { M | _ { I } } ) .
$$
```
- RAW: ```
an interval I counts the number of intervals J in the direct sum decomposition of the zigzag module containing I .
```
  FIX: ```
an interval \( I \) counts the number of intervals \( J \) in the direct sum decomposition of the zigzag module containing \( I \).
```
- RAW: ```
For two intervals I ⊂ J of P , it holds that rk( I ) ≥ rk( J ) .
```
  FIX: ```
For two intervals \( I \subset J \) of \( P \), it holds that \( \text{rk}( I ) \geq \text{rk}( J ) \).
```
- RAW: ```
the limit of M | J is also a cone of M | I and the colimit of M | J is a cocone of M | I . Hence, by the universal properties of limits and colimits there exist unique morphisms g : lim ←− M | J → lim ←− M | I and f : lim −→ M | I → lim −→ M | J such that for all a ∈ I , all z ∈ M a and all y ∈ lim ←− M | J it holds π J a ( y ) = π I a ◦ g ( y ) and i J a ( z ) = f ◦ i I a ( z ) . Hence, for the canonical limit-to-colimit-maps ψ M | I and ψ M | J it holds
```
  FIX: ```
the limit of \( M | J \) is also a cone of \( M | I \) and the colimit of \( M | J \) is a cocone of \( M | I \). Hence, by the universal properties of limits and colimits there exist unique morphisms \( g : \lim_{\leftarrow} M | J \to \lim_{\leftarrow} M | I \) and \( f : \lim_{\rightarrow} M | I \to \lim_{\rightarrow} M | J \) such that for all \( a \in I \), all \( z \in M_a \) and all \( y \in \lim_{\leftarrow} M | J \) it holds \( \pi_a^J ( y ) = \pi_a^I \circ g ( y ) \) and \( i_a^J ( z ) = f \circ i_a^I ( z ) \). Hence, for the canonical limit-to-colimit-maps \( \psi_{ M | I } \) and \( \psi_{ M | J } \) it holds
```
- RAW: ```
\psi _ { M | _ { J } } ( y ) = i _ { a } ^ { J } \circ \pi _ { a } ^ { J } ( y ) = f \circ i _ { a } ^ { I } \circ \pi _ { a } ^ { I } \circ g ( y ) = f \circ \psi _ { M | _ { I } } \circ g ( y )
```
  FIX: ```
$$
\psi _ { M | _ { J } } ( y ) = i _ { a } ^ { J } \circ \pi _ { a } ^ { J } ( y ) = f \circ i _ { a } ^ { I } \circ \pi _ { a } ^ { I } \circ g ( y ) = f \circ \psi _ { M | _ { I } } \circ g ( y )
$$
```
- RAW: ```
and hence, ψ M | J factors through ψ M | I and so rank( ψ M | I ) ≥ rank( ψ M | J ) . □
```
  FIX: ```
and hence, \( \psi_{ M | J } \) factors through \( \psi_{ M | I } \) and so \( \text{rank}( \psi_{ M | I } ) \geq \text{rank}( \psi_{ M | J } ) \). \square
```
- RAW: ```
diagrams valued in Vec . For this, we first need to establish the following notation: for p,q ∈ P , v p ∈ M p and v q ∈ M q we write v p ∼ v q if p and q are comparable and either M ( p ≤ q )( v p ) = v q or M ( q ≤ p )( v q ) = v p , whichever case is applicable.
```
  FIX: ```
diagrams valued in \( \text{Vec} \). For this, we first need to establish the following notation: for \( p,q \in P \), \( v_p \in M_p \) and \( v_q \in M_q \) we write \( v_p \sim v_q \) if \( p \) and \( q \) are comparable and either \( M ( p \leq q )( v_p ) = v_q \) or \( M ( q \leq p )( v_q ) = v_p \), whichever case is applicable.
```
- RAW: ```
Let M : P → Vec be a persistence module.
```
  FIX: ```
Let \( M : P \to \text{Vec} \) be a persistence module.
```
- RAW: ```
The limit of M is (isomorphic to) the pair ( L, ( π p ) p ∈ P ) where
```
  FIX: ```
The limit of \( M \) is (isomorphic to) the pair \( ( L, ( \pi_p )_{p \in P} ) \) where
```
- RAW: ```
L \coloneqq \begin{cases} ( v _ { p } ) _ { p \in P } \in \prod _ { p \in P } M _ { p } \colon \forall p \leq q \in P , v _ { p } \sim v _ { q } \end{cases} \Big \}
```
  FIX: ```
$$
L \coloneqq \begin{cases} ( v _ { p } ) _ { p \in P } \in \prod _ { p \in P } M _ { p } \colon \forall p \leq q \in P , v _ { p } \sim v _ { q } \end{cases} \Big \}
$$
```
- RAW: ```
and for each p ∈ P , π p : L → M p is the canonical projection. We call an element of L a section of M .
```
  FIX: ```
and for each \( p \in P \), \( \pi_p : L \to M_p \) is the canonical projection. We call an element of \( L \) a section of \( M \).
```
