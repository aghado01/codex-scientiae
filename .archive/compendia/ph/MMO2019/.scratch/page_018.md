[Page 18]

Notice that in Corollary 28, the input for the PHD is a single feature ξ as opposed to a list of features Z = { ξ 1 ,...,ξ N } for the global kernel in Proposition 25. Furthermore, Proposition 25 extends to the analogue result for a center persistence diagram with features of varied degree of homology.

Corollary 30 Consider a persistence diagram D = − 1 k =0 D k ×{ k } split according to the degrees of homology with associated random persistence diagrams D k deﬁned according to Eq. (4.6) for each center diagram D k . Treating each D k as independent, the full global pdf for D = D k centered at D with bandwidth σ is given by

$$
K _ { \sigma } ( Z , \mathcal { D } ) = \Lambda ( N ) \prod _ { k = 0 } ^ { \mathfrak { d } - 1 } K _ { \sigma } ( Z _ { k } , \mathcal { D } _ { k } ) ,
$$

where Z =   − 1 k =0 Z k × { k } ⊂ W 0: − 1 with each Z k ⊂ W of cardinality | Z k | = N k within the multi-index N = ( N 0 ,...,N − 1 ) and

$$
\Lambda ( N ) = \frac { N ! } { | N | ! } \colon = \frac { \prod N _ { k } ! } { ( \sum N _ { k } ) ! } .
$$

Proof The result follows immediately from taking set derivatives of the full belief function β D ( S ) =   k β D k ( S ). In particular, the set derivatives δβ D k δZ ( ∅ ) are zero unless Z ⊂ W k . Thus, the product rule leaves only the single term δβ D δZ ( ∅ ) =   − 1 k =0 δβ D k δZ k ( ∅ ). In turn, each kernel global pdf K σ ( Z k , D k ) is related to the associated belief function derivative by a sum over permutations Π N k (see Eq. (3.7)). Compositions of these permutations are N k !-fold redundant against the | N | ! permutations in Π | N | , yielding the coeﬃcient Λ( N ).

## 4.2. Convergence of the Kernel Density Estimator

In this section, to prove the convergence (to the target distribution) of the kernel density estimate deﬁned via the kernel established in Proposition 25, we consider persistence diagrams { D i } n i =1 which are i.i.d. sampled from a target distribution with global pdf f . Toward this end, we require the following assumptions on f :

( A 1) f ( Z ) = 0 for | Z | > M ∈ N (bounded cardinality).

( A 2) The local density f N : W N k → R is bounded for each N ∈ { 1 ,...,M } .

( A 3) There exists C N > 0 so that f ( ξ 1 ,...,ξ N ) ≤ C N ( ξ 1 ,...,ξ N ) − 2 N for each N ∈ { 1 ,...,M } .
