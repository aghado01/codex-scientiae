[Page 5]

Proof. It follows from work of Thom [Tho54] that any homology class of degree ≤ 6 is represented by a smooth, in particular by a topological, closed manifold, so Proposition 1 (ii) is valid.  

3. Remark. In the above argument, we have used that for an oriented Poincare´ complex X , ro( X ) = 0 implies that ro( X ) vanishes 2-locally. One may wonder whether the same is true for the total surgery obstructions: If tso( X ) = 0, does it follow that tso( X ) vanishes 2-locally? We do not know the answer to this question currently. Note, however, that the 2-local splitting of L q ( Z ) does not induce a 2-local splitting of S alg ( X ) into S alg ( X ) and a second summand: Indeed, suppose that X is d -dimensional aspherical Poincare´ complex and π 1 ( X ) is a Farrell–Jones group. Then S alg ( X ) = 0 but S alg ( X ) (2) ≃ [ X ⊗ τ ≤ 0 L q ( Z )] (2) = 0. Nevertheless, at least conjecturally, one has tso( X ) = 0 whenever X is aspherical, see [Lu¨c24, Conjecture 9.178].



We come to the main contribution of this paper.

Main Theorem. There exists an oriented Poincare´ complex E with tso( E ) = 0 whose Spivak normal fibration does not admit a reduction to a euclidean bundle.

We consider the following construction. Let ¯ x ∈ π ℓ (Bgl 1 ( S )) be an element of positive degree ℓ and order n . Let M ( Z /n Z ,ℓ ) be the corresponding mod n Moore space in dimension ℓ . By assumption, there is then a map x : M ( Z /n Z ,ℓ ) → Bgl 1 ( S ) whose composite with the tautological map S ℓ → M ( Z /n Z ,ℓ ) is ¯ x . By framed surgeries below the middle dimension, we may construct a map f : M → M ( Z /n Z ,ℓ ) inducing an isomorphism on π ℓ with M a stably framed (smooth) m -manifold for any m > 2 ℓ ; e.g. by framed surgery on an appropriately embedded ℓ -sphere in S ℓ × S m − ℓ . Let k ≥ ℓ +1 be sufficiently large, so that − xf : M → Bgl 1 ( S ) lifts along Baut ∗ ( S k ) → Bgl 1 ( S ) and let π : E → M be the associated pointed spherical fibration over M . By choice of k , the resulting map E → M ( Z /n Z ,ℓ ) is then again an isomorphism on π ℓ . Moreover, E is a Poincare´ complex with Spivak normal fibration classified by the composite

$$
E \stackrel { \pi } { \rightarrow } M \stackrel { x f } { \longrightarrow } \{ - d \} \times B g l _ { 1 } ( \mathbb { S } ) \subseteq P i c ( \mathbb { S } ) ,
$$

where d = m + k is the dimension of E .

Proof of Main Theorem. Let ¯ x ∈ π 4 (Bgl 1 ( S )) ∼ = Z / 24 Z be a generator of the 3-torsion and consider the Poincare´ complex E associated to ¯ x as constructed above. Then, the composite

$$
E \stackrel { \pi } { \rightarrow } M \stackrel { f } { \rightarrow } M ( \mathbb { Z } / 3 \mathbb { Z } , 4 ) \stackrel { x } { \rightarrow } B g l _ { 1 } ( \mathbb { S } )
$$

classifies the Spivak normal fibration of E but does not lift along BTop → Bgl 1 ( S ). Indeed, on π 4 it induces an inclusion Z / 3 Z ⊆ Z / 24 Z , which cannot factor through Z ⊕ Z / 2 ∼ = π 4 (BTop) [Mil88, Lemma 9]. It then remains to show tso( E ) = 0. To that end, note first that E is simply connected. As a consequence of the π π -theorem, we thus find that the map

$$
\Omega ^ { d \overline { \mathcal { S } } ^ { a l g } } ( E ) \rightarrow \Omega ^ { d - 1 } [ E \otimes L ^ { q } ( \mathbb { Z } ) ]
$$

is split injective on homotopy groups. In particular, to verify that tso( E ) = 0, it suffices to show that ro( E ) = 0. To do so, recall that the composite E → M ( Z / 3 Z , 4) → {− d } × Bgl 1 ( S ) is the Spivak normal fibration D E of E . In particular, we obtain a map Th( D E ) → Ω d Th( x ), where Th( − ) is the Thom spectrum functor. Applying Spanier–Whitehead duality
