[Page 51]

modules I u computed by the algorithm for M i +1 are of the following two types. In each case, we argue that the claim of the proposition holds.

- (i) I u is an interval module where the path u is disjoint from the supports of the zigzag filtrations ZZ j that are extended. In this case, I u is not affected by the updates while moving from a i to a i +1 . By inductive hypothesis, I u satisfies the claim.
- (ii) I u is an interval module where the path u intersects the support of an extended filtration ZZ j . There are two cases to be considered: (a) the path u is completely contained in the support of the extended filtration ZZ j . In this case, the matrix updates by the zigzag algorithm described in [ 21 ] implicitly update the representative cycles of I u so that I u satisfies the claim of the proposition. (b) the path u intersects the support of ZZ j only partially. Let a k be the point where the path u deviates from the support of ZZ j for the first time while going backward from a j . Let a ℓ be the immediate point of a k going backward on the support of ZZ j . Then, by the choice of ZZ j , we have the backward inclusion a ℓ ← a k . The interval module I u restricted to the path starting at a k and going forward appears as a newly born interval module on the zigzag module induced by ZZ j . The algorithm in [ 21 ] does not change the representative cycles for such modules because the inclusion arrow a ℓ ← a k is backward. This means that the representative cycles for I u at points a k and backward (as computed for M i ) remain intact. The rest of the representative cycles for I u are computed satisfying the compatibility condition during the extension of ZZ j to a i +1 .


# 9. Discussion

The introduced Conley-Morse persistence barcode provides a new tool, rooted in persistent homology, for describing the evolution of a parameterized combinatorial multivector field. It establishes a strong connection between dynamical systems—particularly continuation theory—and topological data analysis, opening possibilities for further exchanges of ideas that may enrich both fields.

For instance, the Conley-Morse persistence module is a naturally arising example of a persistence module over a poset that can be decomposed into string modules (bars), making it a valuable case study for the rapidly growing field of multiparameter persistence. Conversely, the interpretation of continuation from the viewpoint of persistence theory may enrich Conley index theory, as the Conley-Morse persistence barcode can be viewed as a parameterized Conley index .

This work also raises several open questions and unresolved hypotheses that are worth investigating as future directions:

- Bar coupling problem: As pointed out in Remark 7.9 , the clear coupling between Conley index generators in the AR-split diagram (see map h d ∗ in Theorem 5.12(c) ) does not easily generalize to a coupling of bars at the level of the Conley-Morse persistence barcode, particularly when multiple Conley index generators of a single Morse set are born or die. We hypothesize that a matching still exists, but we only provide a proof of quantitative matching (Theorem 7.8( c ) ).
