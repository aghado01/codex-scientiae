[Page 6]

$$
\pi _ { - 1 } ( D ( T h ( x ) ) \otimes \tau _ { \geq 1 } L ^ { q } ( \mathbb { Z } ) ) & \longrightarrow \pi _ { d - 1 } ( E \otimes \tau _ { \geq 1 } L ^ { q } ( \mathbb { Z } ) ) \\ & \downarrow \\ \pi _ { - 1 } ( D ( T h ( x ) ) \otimes L ^ { q } ( \mathbb { Z } ) ) & \longrightarrow \pi _ { d - 1 } ( E \otimes L ^ { q } ( \mathbb { Z } ) )
$$

Now, the element ro( E ) in the top right corner is in the image of the upper horizontal map, by naturality of Thom classes. The proof that ro( E ), and hence tso( E ), vanishes is hence finished once we show that the left lower corner in the above diagram is trivial. To that end, one first computes that D (Th( x )) is equivalent to fib( S x −→ S − 4 / 3); generally the Thom spectrum of a map Σ X → Bgl 1 ( S ), for a pointed space X , identifies with the cofibre of the induced map Σ ∞ X → S , for example the argument in [Lan22, Section A.13] applies verbatim to general suspensions in place of spheres. Consequently, we obtain an exact sequence

$$
\pi _ { 0 } ( L ^ { q } ( \mathbb { Z } ) ) \stackrel { x } { \longrightarrow } \pi _ { 4 } ( L ^ { q } ( \mathbb { Z } ) / 3 ) \longrightarrow \pi _ { - 1 } ( D ( T h ( x ) ) \otimes L ^ { q } ( \mathbb { Z } ) ) \to 0
$$

with first group isomorphic to Z and middle one isomorphic to Z / 3 Z . We claim that the map labelled x in this sequence is surjective. To prove this, we may localise at 3, so that L q ( Z ) may be replaced by KO, see again [LN18, Corollary 5.4] and the following remark. Then the claim follows from the fact that the map S / 3 → KO / 3 induced by the unit of KO induces a bijection on π 4 [Ada66, Thm. 1.7]. 3  

4. Remark. The above proof of Main Theorem works, essentially verbatim, more generally for any non-trivial element ¯ x ∈ π 4 k − 1 ( S ) of odd order n which is in the image of the J homomorphism. Indeed, one first observes that [Bru68, Theorem 4.7 & Remark 4.9], together with the equivalence Top / PL ≃ K ( Z / 2 , 3) [KS77], says that the odd torsion of π 4 k (BTop) maps via the canonical map BTop → Bgl 1 ( S ) isomorphically onto the kernel of Adams’ e invariant. Since e (¯ x ) is non-zero [Ada66, Theorem 1.5 & 1.6] we deduce that the Spivak normal fibration of the Poincare´ complex E constructed from ¯ x does not admit a reduction to a euclidean bundle. To see that tso( E ) = 0, it again suffices to show that the composite

$$
\mathbb { S } \stackrel { x } { \rightarrow } \Omega ^ { 4 k } \mathbb { S } / n \rightarrow \Omega ^ { 4 k } K O / n
$$

is surjective on π 0 . To do this, one can reduce to the case where n = p l for some odd prime p . Then we use that the image of the J -homomorphism maps isomorphically onto π 4 k − 1 ( L K (1) S ) and that the map π 4 k (KO /n ) → π 4 k (KU /n ) is an isomorphism. Doing this, it will suffice to show that the map

$$
\pi _ { 4 k } ( L _ { K ( 1 ) } \mathbb { S } / n ) \to \pi _ { 4 k } ( K U / n ) ,
$$

induced by the unit of KU and the fact that KU /n is K (1)-local, is an isomorphism. This follows from an inspection of the long exact sequence induced from the equivalence L K (1) S ≃ (KU ∧ p ) h Z × p together with the fact that n divides the order of π 4 k − 1 ( L K (1) S ). Concrete examples of elements ¯ x as needed are given by generators of the p -torsion of π 2 p − 3 ( S ) for any odd prime p . The case p = 3 is the one we used above.

3 This statement can equivalently be phrased as saying that x , thought of as a map Σ 4 S / 3 → S / 3 is a v 1 -map in the sense of chromatic homotopy theory, i.e. induces an isomorphism in K -theory.
