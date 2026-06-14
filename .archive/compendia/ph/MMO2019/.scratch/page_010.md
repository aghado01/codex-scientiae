[Page 10]

The following proposition is critical to determine the global pdf for (i) the union of independent singleton diagrams (i.e., D j ≤ 1), (ii) a randomly chosen cardinality, N , followed by N i.i.d. draws from a ﬁxed distribution, and (iii) a random persistence diagram kernel density function. The proof of this proposition follows similar arguments to (Mahler, 1995) (Theorem 17, pp. 155–156).

Proposition 16 Let D be a random persistence diagram with cardinality bounded by M and let β D ( S ) = P ( D ⊂ S ) be the belief function for D . Then β D expands as β D ( S ) = a 0 +   M m =1 a m q m ( S ) , where a m = P ( | D | = m ) and q m ( S ) = P [ D ⊂ S | D | = m ] .

Remark 17 The decomposition in Proposition 16 is often applied as a ﬁrst step toward ﬁnding the local density constituents of the global pdf. In particular, f N = f D W N 0: − 1 = 0 for N > M .

Lastly, we encounter a computationally convenient summary for a random persistence diagram called the probability hypothesis density (PHD). The integral of the PHD over a subset U in W 0: − 1 gives the expected number of points in the region U ; moreover, any other function on W 0: − 1 with this property is a.e. equal to the PHD (Goodman et al., 2013).

Deﬁnition 18 (Matheron, 1975) The probability hypothesis density (PHD) for a random persistence diagram D is deﬁned as the set function F D ( a ) = δβ D δZ ( { a } ) and is expressed as a set integral as δβ

$$
F _ { D } ( a ) = \int _ { \{ Z \colon \{ a \} \subset Z \} } \frac { \delta \beta } { \delta Z } ( \emptyset ) \delta Z .
$$

In particular, E ( | D ∩ U | ) =   U F D ( u ) du for any region U .

Remark 19 Def. 18 is equivalent to an intensity function of a point process. In general, the intensity function induced by a given global pdf may be undeﬁnied, but under mild conditions Eq. (3.8) is ﬁnite (we discuss this further in Section 4.2). Since D is a random persistence diagram, the PHD is always deﬁned as a distribution and can always be integrated to obtain the identity E ( | D ∩ U | ) =   U F D ( u ) du for any region U .

Proposition 16 leads to the following lemma which is crucial for determining the kernel density. We refer to a random persistence diagram D with | D | ≤ 1 as a singleton diagram, and such singletons are indexed by superscripts.

Lemma 20 Consider a multiset of independent singleton random persistence diagrams D j M j =1 . If each singleton D j is described by the value q ( j ) = P [ D j = ∅ ] and the subsequent conditional pdf, p ( j ) ( ξ ) , given D j = 1 , then the global pdf for D = ∪ M j =1 D j is given by

glyph[negationslash]

$$
f _ { D } ( \xi _ { 1 } , \dots , \xi _ { N } ) = \sum _ { \gamma \in I ( N , M ) } \mathcal { Q } ( \gamma ) \prod _ { k = 1 } ^ { N } p ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) ,
$$

for each N ∈ { 0 ,...,M } where

$$
\mathcal { Q } ( \gamma ) = \mathcal { Q } ^ { * } ( \gamma ) \prod _ { k = 1 } ^ { N } q ^ { ( \gamma ( k ) ) } ,
$$
