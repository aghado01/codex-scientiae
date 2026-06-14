[Page 11]

I ( N,M ) consists of all (strictly) increasing injections γ : { 1 ,...,N } → { 1 ,...,M } , which enumerate (unordered) correspondences between the input features ( ξ 1 ,...,ξ N ) and a subset of the M random singletons, and M

$$
\mathcal { Q } ^ { * } ( \gamma ) = \frac { \prod _ { j = 1 } ^ { M } ( 1 - q ^ { ( j ) } ) } { \prod _ { k = 1 } ^ { N } ( 1 - q ^ { ( \gamma ( k ) ) } ) } .
$$

Proof Since the singleton events D j are independent, the belief function for D = ∪ j D j decomposes into β D ( S ) = M j =1 β D j ( S ). Next, we employ the product rule for the set derivative (see Def. 9) to obtain the global pdf for D in terms of the singleton belief functions and their ﬁrst derivatives. Higher derivatives of β D j are zero since D j are singletons (see Remark 17). Thus, the product rule yields ﬁrst derivatives on all (ordered) subsets of the singleton belief functions:

$$
\frac { \delta ^ { N } \beta _ { D } } { \delta \xi _ { 1 } \dots \delta \xi _ { N } } ( \emptyset ) = \sum _ { 1 \leq j _ { 1 } \neq , \dots , \neq j _ { N } \leq M } \frac { \beta _ { D ^ { 1 } } ( \emptyset ) \cdots \beta _ { D ^ { M } } ( \emptyset ) } { \beta _ { D ^ { j _ { 1 } } } ( \emptyset ) \cdots \beta _ { D ^ { j _ { N } } } ( \emptyset ) } \left [ \frac { \delta \beta _ { D ^ { j _ { 1 } } } } { \delta \xi _ { 1 } } ( \emptyset ) \cdots \frac { \delta \beta _ { D ^ { j _ { N } } } } { \delta \xi _ { N } } ( \emptyset ) \right ] .
$$

glyph[negationslash]

glyph[negationslash]

By Proposition 16, we have that β D j ( ∅ ) = (1 − q ( j ) ) and δβ D j i δξ i ( ∅ ) = q j i p ( j i ) ( ξ i ) and so

$$
\frac { \delta ^ { N } \beta _ { D } } { \delta \xi _ { 1 } \dots \delta \xi _ { N } } ( \emptyset ) = \sum _ { 1 \leq j _ { 1 } \neq , \dots , \neq j _ { N } \leq M } \left [ \frac { \prod _ { j = 1 } ^ { M } ( 1 - q ^ { ( j ) } ) } { \prod _ { j = 1 } ^ { N } ( 1 - q ^ { ( j _ { k } ) } ) } \prod _ { k = 1 } ^ { N } q ^ { ( j _ { k } ) } \right ] \prod _ { k = 1 } ^ { N } p ^ { ( j _ { k } ) } ( \xi _ { k } ) ,
$$

glyph[negationslash]

glyph[negationslash]

which nearly resembles Eq. (3.9). To bridge the gap, we describe the choice of indices j i by an injective function from { 1 ,...,N } into { 1 ,...,M } . In turn, each such injective function is uniquely determined by the composition of an increasing injection γ ∈ I ( N,M ) which decides the range of the function and permutations on the domain, Π N . These permutations take into account the order of the range. The value of Q is independent of order, and thus is determined by γ as in Eq. (3.10). We reorder the product in order to shift these permutations onto the input variables, obtaining

$$
\frac { \delta ^ { N } \beta _ { D } } { \delta \xi _ { 1 } \dots \delta \xi _ { N } } ( \emptyset ) = \sum _ { \pi \in \Pi _ { N } \ \gamma \in I ( N , M ) } \mathcal { Q } ( \gamma ) \prod _ { k = 1 } ^ { N } p ^ { ( \gamma ( k ) ) } ( \xi _ { \pi ( k ) } ) .
$$

Finally, the global pdf in Eq. (3.9) follows directly from applying Eq. (3.7) to Eq.(3.12).

Remark 21 The global pdf in Eq. (3.9) , and in particular the sum over γ ∈ I ( N,M ) , accounts for each possible combination of singleton presence. Moreover, summing over permutations as in Eq. (3.12) and dividing by N ! yields a symmetric pdf with terms for every possible assignment between singletons and inputs. The weights Q ( γ ) indicate the probability of each assignment occurring, and is the product of the appropriate probability for each singleton to be either present, q ( j ) , or absent, 1 − q ( j ) , for each j .

Example 1 Consider two 1-dimensional singleton diagrams, D 1 and D 2 , with probabilities of being nonempty q (1) = 0 . 6 and q (2) = 0 . 8, respectively. The corresponding local densities when nonempty are given by p (1) ( x ) = 1 √ 2 π e − ( x +1) 2 / 2 and p (2) ( x ) = 1 √ 2 π e − ( x − 1) 2 / 2 . Lemma 20 yields the global pdf for D = D 1 ∪ D 2 through a set of local densities { f 0 ,f 1 ( x ) ,f 2 ( x,y ) } such that
