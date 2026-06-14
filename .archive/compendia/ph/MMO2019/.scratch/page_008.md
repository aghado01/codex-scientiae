[Page 8]

The map h N creates equivalence classes on W N 0: − 1 according to the action of the permutations Π N ; speciﬁcally, [ Z ] = [( ξ 1 ,...,ξ N )] h N = ξ π (1) ,...,ξ π ( N ) : π ∈ Π N for each Z = ( ξ 1 ,...,ξ N ) ∈ W N 0: − 1 . These equivalence classes yield the space

$$
\mathcal { W } _ { 0 \colon \mathbf d - 1 } ^ { N } / \Pi _ { N } = \left \{ [ \xi ] _ { h _ { N } } \colon \xi \in \mathcal { W } _ { 0 \colon \mathbf d - 1 } ^ { N } \right \} ,
$$

equipped with the quotient topology. The topology on C ≤ M ( W 0: − 1 ) is deﬁned so that each h N lifts to a homeomorphism between W N 0: − 1 / Π N and C N ( W 0: − 1 ) , and we write W N 0: − 1 / Π N ∼ = C N ( W 0: − 1 ) .

With a topology in hand, one can deﬁne probability measures on the associated Borel σ -algebra. Thus, we deﬁne a random persistence diagram D to be a random element distributed according to some probability measure on C ≤ M ( W 0: − 1 ) for a ﬁxed maximal cardinality M ∈ N . We denote associated probabilities by P [ · ] and expected values by E [ · ]. Since W N 0: − 1 / Π N ∼ = C N ( W 0: − 1 ), we work toward deﬁning probability densities on the collection of Euclidean spaces ∪ M N =0 W N 0: − 1 .

Deﬁnition 8 For a given random persistence diagram D and any Borel subset A of W 0: − 1 , the belief function β D is deﬁned as

$$
\beta _ { D } ( A ) = \mathbb { P } \left [ D \subset A \right ] .
$$

Since A is a Borel subset of W 0: − 1 , the collection O A = { D ∈ C ≤ M ( W 0: − 1 ) : D ⊂ A } is the quotient of ∪ M N =0 A N ⊂ ∪ M N =0 W N 0: − 1 under h N ; moreover, A N is clearly Borel in the Euclidean topology of ∪ M N =0 W N 0: − 1 . Therefore, since h N induces a homeomorphism (see deﬁnition 7), O A is a Borel subset of C ≤ M ( W 0: − 1 ). The belief function of a random persistence diagram is similar to the joint cumulative distribution function for a random vector, in particular by yielding a probability density function through Radon-Nikody´m type derivatives.

Deﬁnition 9 Fix φ deﬁned on Borel subsets of C ≤ M ( W 0: − 1 ) into R . For an element ξ ∈ W 0: − 1 or a multiset Z ⊂ W 0: − 1 with Z = { ξ 1 ,...,ξ N } , the set derivative (evaluated at the empty set ∅ ) is respectively given by

$$
& \frac { \delta \phi } { \delta \xi } ( \emptyset ) = \lim _ { n \to \infty } \frac { \phi ( B ( \xi , 1 / n ) ) } { \lambda ( B ( \xi , 1 / n ) ) } , \\ & \frac { \delta \phi } { \delta Z } ( \emptyset ) = \frac { \delta ^ { N } \phi } { \delta \xi _ { 1 } \dots \delta \xi _ { N } } = \left [ \frac { \delta } { \delta \xi _ { 1 } } \cdots \frac { \delta } { \delta \xi _ { N } } \phi \right ] ( \emptyset ) ,
$$

where B ( ξ, 1 /n ) are Euclidean balls and λ indicates Lebesgue measure on W 0: − 1 .
