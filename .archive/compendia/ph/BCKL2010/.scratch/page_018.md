[Page 18]

by (6.1), it follows that if

$$
\text {at if} \quad \sigma _ { N } ^ { - 1 } \leq \sqrt { 2 - \delta } \sqrt { \log N } \\ \text {then} \quad \sigma _ { N } ^ { - 1 } = \tau _ { 0 } ( \hat { u } _ { 0 } \hat { \sigma } _ { 0 } - \sigma _ { 0 } \| u \| ) \quad ( \tau _ { 0 }
$$

for some 0 < δ < 2, then

$$
\inf _ { \hat { \theta } } \sup _ { | \theta _ { i } | \leq 1 } \mathbb { E } w ( \| \hat { \theta } - \theta \| _ { \infty } ) \to w ( 1 ) ,
$$

as N → ∞ , but

$$
\psi _ { n } ^ { - 1 } L \kappa ^ { - \beta } = C _ { 0 } ^ { \prime } .
$$

By the continuity of the function w , we have

$$
\inf _ { \hat { \theta } } \sup _ { | \theta _ { i } | \leq 1 } \mathbb { E } w ( \psi _ { n } ^ { - 1 } L \kappa ^ { - \beta } \, \| \, \hat { \theta } - \theta \, \| _ { \infty } ) \to w ( C _ { 0 } ^ { \prime } ) ,
$$

when N → ∞ . Since δ was chosen arbitrarily, the result follows.

## Appendix A. Background on Topology

In this appendix we present a technical overview of homology as used in our procedures. For an intensive treatment we refer the reader to the excellent text [32].

Homology is an algebraic procedure for counting holes in topological spaces. There are numerous variants of homology: we use simplicial homology with Z coeﬃcients. Given a set of points V , a k -simplex is an unordered subset { v 0 , v 1 , . . ., v k } where v i ∈ V and v i = v j for all i = j . The faces of this k -simplex consist of all ( k − 1)-simplices of the form { v 0 , . . ., v i − 1 , v i +1 , . . ., v k } for some 0 ≤ i ≤ k . Geometrically, the k simplex can be described as follows: given k +1 points in R m ( m ≥ k ), the k -simplex is a convex body bounded by the union of ( k − 1) linear subspaces of R m of deﬁned by all possible collections of k points (chosen out of k +1 points). A simplicial complex is a collection of simplices which is closed with respect to inclusion of faces. Triangulated surfaces form a concrete example, where the vertices of the triangulation correspond to V . The orderings of the vertices correspond to an orientation. Any abstract simplicial complex on a (ﬁnite) set of points V has a geometric realization in some R m . Let X denote a simplicial complex. Roughly speaking, the homology of X , denoted H ∗ ( X ), is a sequence of vector spaces { H k ( X ) : k = 0 , 1 , 2 , 3 , . . . } , where H k ( X ) is called the k -dimensional homology of X . The dimension of H k ( X ), called the k -th Betti number of X , is a coarse measurement of the number of diﬀerent holes in the space X that can be sensed by using subcomplexes of dimension k .

/negationslash

/negationslash

For example, the dimension of H 0 ( X ) is equal to the number of connected components of X . These are the types of features (holes) in X
