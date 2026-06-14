[Page 26]

If −→ ι − 1 λ ( q ) is empty, then the theorem becomes trivial. In particular, there is no isolated invariant set in V 1 corresponding to M q, 2 ; or, in other words, M q, 2 continues to the empty set in V 1 . If −→ ι − 1 λ ( q ) is a singleton, that is Q = { p } , then M Q , 1 = M p, 1 , and therefore, the Morse set M p, 1 corresponding to B p, 1 in V 1 simply continues to M q, 2 corresponding to B q, 2 in V 2 .

The situation becomes interesting when Q has more than one element. We know that it is the aggregated Morse set M Q , 1 in V 1 that continues to M q, 2 in V 2 . Again, they share the Conley index through a common index pair (see Proposition 4.17 ), therefore it is enough to study the contribution of individual Morse sets in M 1 to the Conley index of M Q , 1 within V 1 . In the following section we introduce split diagrams that quantify this contribution.

Example 5.8. The left and the right column in Figure 14 illustrate Proposition 5.6 . For instance, since B 0 ⊒ B 1 ⊑ B 2 , it follows that B 0 and B 2 are also proper block decompositions for V 1 . Therefore, we will study the transition from B 0 to B 1 and from B 1 to B 2 within V 1 .

To illustrate Theorem 5.7 , consider the step ( B 1 , V 1 ) ⊑ ( B 2 , V 2 ) of the zigzag filtration from Example 5.3 and the corresponding indexing map −→ ι 1 : P 1 → P 2 . Let q : = ◦ ∈ P 2 and Q : = −→ ι − 1 1 ( ◦ ) = {◦ , ▼ } ⊂ P 1 . By point (a) , B Q , 1 = { B ◦ , 1 ,B ▼ , 1 } is a block decomposition of set B ◦ , 2 in V 1 . In this case, the invariant part of B ◦ , 2 with respect to V 1 , denoted M Q , 1 , is the same as for B ◦ , 1 , denoted M ◦ , 1 (the highlighted green empty triangle in the second row, the central and right column, respectively). By point (c) , M ◦ , 1 continues to M ◦ , 2 ; in particular, because they share the same isolating block B ◦ , 2 .

As another example consider step ( B 3 , V 3 ) ⊒ ( B 4 , V 4 ) and the map ←− ι 3 : P 4 → P 3 . Let q : = ◦ ∈ P 3 and Q : = ←− ι − 1 3 ( ◦ ) = { □ ,γ,β,α, •} ⊂ P 4 . By (a) , B Q = { B □ , 4 ,B γ, 4 , B β, 4 , B α, 4 , B • , 4 } is a block decomposition of B ◦ , 3 with respect to V 4 . By (b) , M Q , 4 —the invariant part of B ◦ , 3 in V 4 coincides with B ◦ , 3 and consists of two critical multivectorsthe vertex { d } and the edge { cd } —as well as of the connections between them—the three regular multivectors—forming together the empty quadrangle (highlighted in green in the bottom left panel in Figure 14 ). By (c) , M ◦ , 3 in V 3 continues to M Q , 4 in V 4 . As collections of cells M ◦ , 3 and M Q , 4 are the same, but they represent different dynamics. In particular, M ◦ , 3 behaves like a periodic orbit in V 3 , while M Q , 4 contains heteroclinic connections between equilibria in V 4 . Moreover, M Q , 4 can be further decomposed into a finer block decomposition. ♢

Before proving Theorem 5.7 , we introduce Proposition 5.9 and Lemma 5.10 . Lemma 5.10 will also come in handy later.

Proposition 5.9. [ 32 , Corollary of Proposition 3.10] Let ρ ∈ Paths V ( S,S ′ ,X ), where S and S ′ are isolated invariant sets. Then ρ extends to an essential solution φ with uim − V φ ⊂ S and uim + V φ ⊂ S ′ .

Lemma 5.10. Let A ⊂ X be an isolating block in V and B be a block decomposition of X . Define Q := { q ∈ P | B q ⊂ A } and B Q := { B p ∈ B | p ∈ Q } . If B p ∩ A = ∅ for every p ∈ P \ Q then B Q is a block decomposition of A .

Additionally, Inv V A = C V ( B Q • ,A ) = Inv V C V ( B Q ,A ).

).
