[Page 30]

The AR-split diagram captures dependencies of Conley indices of isolated invariant sets involved in the AR-decomposition. Therefore, it will serve as an elementary building block for the analysis of basic zigzag filtrations B = {B λ } λ ∈ Λ with Λ = { 0 , 1 ,...,T } . In particular, we compose all AR-split diagrams of the AR-splits occurring in B into a single diagram called a transition diagram for B . We denote it by TD and define it constructively using the following procedure:

1. Transition step: for each successive pair B λ ⊑ B λ +1 in B we relate the Conley indices associated with the isolating blocks in B λ with those in B λ +1 using the split diagrams. We have three cases (which are symmetric for the B λ ⊒ B λ +1 case): 1

- 1.1. If −→ ι − λ ( q ) = { p 0 ,p 1 } , that is B q,λ +1 ∈ B λ +1 splits into B p 0 ,λ ,B p 1 ,λ ∈ B λ , we construct an AR-split diagram (we show an explicit construction in Section 5.4 ). 1
- 1.2. If −→ ι − λ ( q ) = { p } then we take any index pair ( P q ,E q ) for M q,λ +1 in V λ +1 that is also an index pair for M p,λ in V λ such that B q,λ +1 ⊂ P q \ E q (it always exists, for example (cl B q,λ +1 , mo B q,λ +1 ) satisfies this condition). 1
- 1.3. If −→ ι − λ ( q ) = ∅ then we take any index pair ( P q ,E q ) for M q,λ +1 in V λ +1 such that B q,λ +1 ⊂ P q \ E q (this case can only happen if B λ is not a block partition of X ).


2. Aligning step: The first step provides index pairs for every isolating block occurring in B . In particular, for each isolating block in B 0 we construct exactly one index pair from the Step 1 for B 0 and B 1 , the same holds for B T , using the step for B T − 1 and B T . Any other block B p,λ has two index pairs constructed in the process, one from the transition from B λ − 1 to B λ , and the other from the transition from B λ to B λ +1 . We denote the corresponding index pairs as P ⊢ p,λ ,E ⊢ p,λ and P ⊣ p,λ ,E ⊣ p,λ , respectively. Both index pairs are for Inv V λ B p,λ in V λ , thus, we connect them using the connecting sequence (see equation ( 4.5 )) to get a proper filtration of topological pairs.

The above procedure explains the general philosophy of the transition diagram, we provide a concrete recipe for the index pairs in Section 5.4 . After applying the homology functor to the constructed transition diagram we obtain the Conley-Morse persistence module whose decomposition into intervals (strings) gives the Conley-Morse persistence barcode . We will return to the decomposition in Section 7 after necessary algebraic preparations in Section 6 .

Example 5.15. Consider the first four stages of the zigzag filtration from Example 5.3 , that is B 0 ⊒ B 1 ⊑ B 2 ⊑ B 3 , which form a basic zigzag filtration. The last part of the filtration, that is B 3 ⊑ B 4 , contains the splitting of B ▼ , 3 into five isolating blocks, thus, making the filtration non-basic. We will address this more general situation in the next section.

In the first step of the construction of the transition diagram, we relate all pairs of successive block decompositions using the AR-split diagrams. The yellow
