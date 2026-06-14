[Page 34]

bars, because we treat the expanded parts as if they arrive at the same time. The same happens in our case; in order to make the construction computable we split the sequence into simpler steps and collapse them again at the very end. We discuss in Section 9 how a choice of AR-cascade may affect the final outcome, but a thorough study of this phenomenon is beyond the scope of this paper.

We prove Proposition 5.18 with the help of the following, more general lemma.

Lemma 5.21 (Consolidation lemma) . Let B be a block decomposition of X for V and Q ⊂ P be a convex subset. Define B Q : = C V ( { B p | p ∈ Q } ,X ). Then B ′ : = B \ { B q | q ∈ Q } ∪ { B Q } is also a block decomposition of X for V .

Proof. An easy modification of the proof of [ 32 , Lemma 4.12] shows that B Q is an isolating block and that B Q ∩ B p = ∅ for all p ∈ P \ Q . Thus, B ′ is a family of mutually disjoint isolating blocks.

Condition (B1) is satisfied, because for a φ ∈ eSol V ( X ) we can find p ∈ P such that uim + φ ⊂ B p ∈ B . If p ∈ Q then uim + φ ⊂ B Q ∈ B ′ ; otherwise we again have uim + φ ⊂ B p ∈ B ′ .

To show that there exists a partial order satisfying (B2) suppose the contrary, that is, the flow induced order on P ′ contains a loop. Since there was no loop in P for B and the set of solutions remains the same, the loop had to appear as a result of aggregating isolating blocks into B Q . Thus, Q is an element of the loop and we have a sequence of relations Q < p 0 < p 1 < ... < p k < Q . It follows that there are q,q ′ ∈ Q such that q < p 0 < q ′ , but this contradicts the assumption that Q is convex. Therefore, (B2) is also proved. □

Proof of Proposition 5.18 . Suppose that Q is not convex in P 0 . Then, for certain p,p ′ ∈ Q and r ∈ P \ Q we have p > r > p ′ . Therefore, there exist paths ρ ∈ Paths V 0 ( B p, 0 ,B r, 0 ,X ) and ρ ′ ∈ Paths V 0 ( B r, 0 ,B p ′ , 0 ,X ), which are also paths in V 1 . Hence, ρ ∈ Paths V 1 ( B q, 1 ,B −→ ι ( r ) , 1 ,X ) and ρ ′ ∈ Paths V 1 ( B −→ ι ( r ) , 1 ,B q, 1 ,X ). This implies q < −→ ι ( r ) < q , which contradicts that B 1 is a block decomposition.

Lemma 5.21 provides that B 0 ′ is indeed a block decomposition of X for V 0 .

Finally, the statement B r, 0 ′ : = C V 0 ( { B p, 0 ,B p ′ , 0 } ,X ) ⊂ B q, 1 follows directly from Theorem 5.7(a) . Clearly, B p, 0 ,B p ′ , 0 ⊂ B r, 0 ′ . Thus, B 0 ⊑ B 0 ′ ⊑ B 1 . □

5.4. Construction of the transition diagram. In this section we present an explicit construction of a transition diagram for a zigzag filtration. The reader interested in the decomposition theorem leading to the Conley-Morse persistence diagram and its properties can safely skip this section.

Let us begin with a simple zigzag filtration consisting of two block partitions B : = ( B 0 , V 0 ) ⊑ ( B 1 , V 1 ). Let −→ ι : P 0 → P 1 be the corresponding forward map. Linear extensions on P 0 and P 1 are called filtration consistent linear orders if −→ ι is order preserving , that is for all p,p ′ ∈ P 0 relation p < p ′ implies −→ ι ( p ) < −→ ι ( p ′ ). The proposition below shows that the blocks that merge together when passing to B 1 are grouped together in the filtration consistent order.

Proposition 5.22. If p,p ′ ,p ′′ ∈ P 0 , p < p ′ < p ′′ and q : = −→ ι ( p ) = −→ ι ( p ′′ ) then −→ ι ( p ′ ) = q .
