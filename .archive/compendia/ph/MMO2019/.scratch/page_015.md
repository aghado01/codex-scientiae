[Page 15]

Deﬁnition 24 The lower random diagram D is deﬁned by choosing a cardinality N according to a pmf ν followed by N i.i.d. draws according to a ﬁxed density p . First, take N = D and deﬁne ν ( · ) with mean N and so that ν ( n ) = 0 for n > mN for some m > 0 independent of N . The subsequent density p ( b,d ) is given by projecting the lower features D of the center diagram D onto the diagonal b = d , then creating a restricted Gaussian kernel density estimation for these features; speciﬁcally, 2 2

$$
p ^ { \ell } ( b , d ) & = \frac { 1 } { N _ { \ell } } \sum _ { ( b _ { i } , d _ { i } ) \in \mathcal { B } ^ { \ell } } \frac { 1 } { \pi \sigma ^ { 2 } } e ^ { - \left ( \left ( b - \frac { b _ { i } + d _ { i } } { 2 } \right ) ^ { 2 } + \left ( d - \frac { b _ { i } + d _ { i } } { 2 } \right ) ^ { 2 } \right ) / 2 \sigma ^ { 2 } } .
$$

Projecting the lower features D of the center diagram D onto the diagonal simpliﬁes later analysis and evaluation of p ; without projecting, a unique normalization factor, similar to q ( j ) in Def. 22, would be required for each Gaussian summand in Eq. (4.4). By Proposition 16 and Eq. (3.7), global pdfs of random persistence diagrams are described by a random vector pdf for each cardinality layer, resulting in the following global pdf for D :

$$
f _ { D ^ { \ell } } ( \xi _ { 1 } , \dots , \xi _ { N } ) = \nu ( N ) \prod _ { j = 1 } ^ { N } p ^ { \ell } ( \xi _ { j } ) .
$$

Eq. (4.5) provides a noise model for the short-lived features near the diagonal. Combining the expressions for D and D u , we arrive at the following proposition.

Proposition 25 Fix a center persistence diagram D and bandwidth σ > 0 . Split D into D and D u according to Eq. (4.1) . Deﬁne D with global pdf from Eq. (4.5) , and D u with global pdf from Eq. (3.9) . Treating the random persistence diagrams D u and D as independent, deﬁne their union D . The following kernel density satisﬁes Def. 13 as the global pdf of D :

$$
K _ { \sigma } ( Z , \mathcal { D } ) = \sum _ { j = 0 } ^ { N _ { u } } \nu ( N - j ) \sum _ { \gamma \in I ( j , N _ { u } ) } \mathcal { Q } ( \gamma ) \prod _ { k = 1 } ^ { j } p ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } p ^ { \ell } ( \xi _ { k } ) ,
$$

where Z = ( ξ 1 ,...,ξ N ) is the input, ξ i = ( b i ,d i ) for i = 1 ,...,N are the features, and N u = | D u | depends on both D and σ . Here Q ( γ ) is given by Eq. (3.10) , each p ( j ) refers to the modiﬁed Gaussian pdf as shown in Eq. (4.2) for its matching feature ξ j in D u , and p   is given by Eq. (4.4) .

Proof Since D u and D are independent random persistence diagrams, the belief function decomposes into β D ( S ) = β D u ( S ) β D ( S ). Moreover, since derivatives above order N u vanish for β D u (see Remark 17), the product rule and binomial-type counting yield

$$
\frac { \delta ^ { N } \beta _ { D } } { \delta \xi _ { 1 } \dots \delta \xi _ { N } } ( \emptyset ) & = \sum _ { j = 0 } ^ { N } \sum _ { 1 \leq i _ { 1 } \neq \dots \neq i _ { j } \leq N } \frac { \delta ^ { j } \beta _ { D } ^ { u } } { \delta \xi _ { i _ { 1 } } \dots \delta \xi _ { i _ { j } } } ( \emptyset ) \frac { \delta ^ { N - j } \beta _ { D } ^ { e } } { \delta \xi _ { 1 } \dots \delta \hat { \xi } _ { i _ { 1 } } \dots \delta \hat { \xi } _ { i _ { j } } \dots \delta \xi _ { N } } ( \emptyset ) \\ & = \sum _ { \pi \in \Pi _ { N } } \sum _ { j = 0 } ^ { N } \frac { 1 } { j ! ( N - j ) ! } \frac { \delta ^ { j } \beta _ { D } ^ { u } } { \delta \pi ( 1 ) \dots \delta \pi ( j ) } ( \emptyset ) \frac { \delta ^ { N - j } \beta _ { D } ^ { e } } { \delta \xi _ { ( j + 1 ) } \dots \delta \xi _ { ( N ) } } ( \emptyset ) \\
$$

glyph[negationslash]

glyph[negationslash]

where δ ˆ ξ i indicates that the given index is skipped in the set derivative (having been allocated to the other factor). Similar to the proof of Lemma 20, the choice of indices i j is replaced with a
