[Page 8]

Remark 2.10 Note that from the definitions of limits and colimits it follows that for every \( p \leq q \) in \( I \) it holds that \( M ( p \leq q ) \circ \pi_p = \pi_q \) and \( i_q \circ M ( p \leq q ) = i_p \). This implies that \( i_p \circ \pi_p = i_q \circ \pi_q \) for all \( p,q \in I \). This map \( \psi_{ M | I } := i_p \circ \pi_p \) is called the canonical limit-to-colimit map.

Definition 2.11 The generalized rank over an interval \( I \) of a persistence module \( M \) is defined as \( \text{rank}( M | I ) := \text{rank}( \psi_{ M | I } ) \), where \( \psi_{ M | I } \) is the canonical limit-to-colimit map \( i_p \circ \pi_p \) for any \( p \in I \).

Remark 2.12 For interval decomposable modules, the generalized rank of \( M \) over an interval \( I \) equals the number of intervals in the direct sum decomposition of \( M \) that contain \( I \) and hence, it is a complete invariant [17].

Definition 2.13 Let \( \text{Int}( P ) \) be the set of intervals of the poset \( P \). The generalized rank invariant is the map

$$
\ r k \colon \text {Int} ( P ) \to \mathbb { N } _ { 0 } , \ \ I \mapsto \text {rank} ( M | _ { I } ) = \text {rank} ( \psi _ { M | _ { I } } ) .
$$

Remark 2.14 When applied to one-parameter persistence modules, the generalized rank invariant coincides with the standard rank invariant. Furthermore, for zigzag modules the generalized rank over an interval \( I \) counts the number of intervals \( J \) in the direct sum decomposition of the zigzag module containing \( I \). In total, the barcode and the generalized rank invariant of the zigzag module contain the same information.

As the original rank invariant, the generalized rank invariant is order-reversing.

Lemma 2.15 For two intervals \( I \subset J \) of \( P \), it holds that \( \text{rk}( I ) \geq \text{rk}( J ) \).

Proof: By construction, the limit of \( M | J \) is also a cone of \( M | I \) and the colimit of \( M | J \) is a cocone of \( M | I \). Hence, by the universal properties of limits and colimits there exist unique morphisms \( g : \lim_{\leftarrow} M | J \to \lim_{\leftarrow} M | I \) and \( f : \lim_{\rightarrow} M | I \to \lim_{\rightarrow} M | J \) such that for all \( a \in I \), all \( z \in M_a \) and all \( y \in \lim_{\leftarrow} M | J \) it holds \( \pi_a^J ( y ) = \pi_a^I \circ g ( y ) \) and \( i_a^J ( z ) = f \circ i_a^I ( z ) \). Hence, for the canonical limit-to-colimit-maps \( \psi_{ M | I } \) and \( \psi_{ M | J } \) it holds

$$
\psi _ { M | _ { J } } ( y ) = i _ { a } ^ { J } \circ \pi _ { a } ^ { J } ( y ) = f \circ i _ { a } ^ { I } \circ \pi _ { a } ^ { I } \circ g ( y ) = f \circ \psi _ { M | _ { I } } \circ g ( y )
$$

and hence, \( \psi_{ M | J } \) factors through \( \psi_{ M | I } \) and so \( \text{rank}( \psi_{ M | I } ) \geq \text{rank}( \psi_{ M | J } ) \). \square

The following proposition shows how the limit and colimit can actually be constructed for diagrams valued in \( \text{Vec} \). For this, we first need to establish the following notation: for \( p,q \in P \), \( v_p \in M_p \) and \( v_q \in M_q \) we write \( v_p \sim v_q \) if \( p \) and \( q \) are comparable and either \( M ( p \leq q )( v_p ) = v_q \) or \( M ( q \leq p )( v_q ) = v_p \), whichever case is applicable. The following proposition appears among others in [9].

Proposition 2.16 Let \( M : P \to \text{Vec} \) be a persistence module. Then:

(i) The limit of \( M \) is (isomorphic to) the pair \( ( L, ( \pi_p )_{p \in P} ) \) where

$$
L \coloneqq \begin{cases} ( v _ { p } ) _ { p \in P } \in \prod _ { p \in P } M _ { p } \colon \forall p \leq q \in P , v _ { p } \sim v _ { q } \end{cases} \Big \}
$$

and for each \( p \in P \), \( \pi_p : L \to M_p \) is the canonical projection. We call an element of \( L \) a section of \( M \).
