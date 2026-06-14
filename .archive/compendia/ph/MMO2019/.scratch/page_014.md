[Page 14]

$$
\mathcal { D } ^ { u } = \{ ( b _ { i } , d _ { i } , k ) \in \mathcal { D } \colon d _ { i } - b _ { i } \geq \sigma \} \text { and } \mathcal { D } ^ { \ell } = \{ ( b _ { i } , d _ { i } , k ) \in \mathcal { D } \colon d _ { i } - b _ { i } < \sigma \} .
$$

Now deﬁne random diagrams D u centered at D u and D centered at D such that D = D u ∪ D . Ultimately, the global pdf of D centered at D is our kernel density.

Deﬁnition 22 Each feature ξ j = ( b j ,d j ) ∈ D u yields an independent random singleton diagram D j deﬁned by its chance to be nonempty q ( j ) (via Eq. (4.3) ) along with its potential position ( b,d ) sampled according to a modiﬁed Gaussian distribution, denoted by N ∗ (( b j ,d j ) ,σI ) . The global pdf for D u is then determined by Lemma 20, where each p ( j ) is given by the pdf associated with N ∗ (( b j ,d j ) ,σI ) , which is given by

$$
p ^ { ( j ) } ( b , d ) = \frac { \varphi _ { j } ( b , d ) } { \int _ { W } \varphi _ { j } ( u , v ) d u \, d v } \mathbb { 1 } _ { W } ( b , d ) ,
$$

where ϕ j is the pdf of the (unmodiﬁed) normal N (( b j ,d j ) ,σI ) , and W ( · ) is the indicator function for the wedge.

The global pdf for each D j is readily obtained by a pair of restrictions. First, we restrict the usual Gaussian distribution to the halfspace T = ( b,d ) ∈ R 2 : b < d . Features sampled below the diagonal are considered to disappear from the diagram and thus we deﬁne the chance to be nonempty by

$$
q ^ { ( j ) } = \mathbb { P } ( D ^ { j } \neq \emptyset ) = \int _ { \{ v > u \} } \varphi _ { j } ( u , v ) \, d u \, d v .
$$

glyph[negationslash]

Afterward, the Gaussian restricted to T is further restricted to W and renormalized to obtain a probability measure as in Eq. (4.2). This double restriction to both T and W is necessary for proper restriction of the Gaussian pdf and deﬁnition of q ( j ) = P ( D j = ∅ ). Indeed, restriction to W alone causes points with small birth time to have an artiﬁcially high chance to disappear; while restriction to T alone yields nonsensical features with negative radius (with b < 0). In kernel density estimation, the eﬀects of this distinction become negligible as the bandwidth goes to zero. In practice, this distinction is important for features with small birth time relative to the bandwidth.

glyph[negationslash]

Remark 23 In the ˇ Cech construction of a persistence diagram, a feature lies on the line b = 0 if and only if it has degree of homology k = 0 . Consequently, for a feature (0 ,d j ) with k = 0 , we instead take

$$
p ^ { ( j ) } ( d ) = \frac { \phi _ { j } ( d ) } { \int _ { \mathbb { R } ^ { + } } \phi _ { j } ( u ) \, d u } \mathbb { I } _ { \mathbb { R } ^ { + } } ( d ) \ a n d \ q ^ { ( j ) } = \int _ { \mathbb { R } ^ { + } } \phi _ { j } ( u ) \, d u
$$

where φ j is the 1-dimensional Gaussian centered at d j with standard deviation σ .

Whereas the large persistence features in D u have small chance to fall below the diagonal and disappear, the existence of the small persistence features in D is volatile: these features disappear and appear ﬂuidly under small changes in the underlying data. The distribution of D is described by a probability mass function (pmf) ν and lower density p .
