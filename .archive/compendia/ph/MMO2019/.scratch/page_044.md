[Page 44]

∅ Now take into account the features in D and the associated random features D as in Def. 24. Although the features in D are not necessarily independent, we may assume without loss of generality the worst case, in which the maximal cardinality is drawn. Given a ﬁxed cardinality, the draws of D are independent. Since any feature may be mapped to the diagonal in the bottleneck distance, a bounding correspondence can be obtained whenever the draws in D and features in D are close enough to the diagonal (within δσ ). Indeed, the features in D are by deﬁnition distance σ ≤ δσ from the diagonal. Restricting to W , the pdf for the draws of 2 2

D   = { ( b j ,d j ) } | N   | j =1 is given by p   ( b,d ) = 1 πN   σ 2   N   j =1 e −     x − b j + d j 2   +   y − b j + d j 2     / 2 σ 2 . Consider the sets U j = B    b j + d j 2 , b j + d j 2   ,δσ   and U =   N   j =1 U j . For each lower feature ( b,d ) ∈ D   , mapping to the diagonal yields a bounding correspondence and the associated probability is bounded below by P [ d − b ≤ δσ ] =   ∆ δσ 0 p   ( x,y ) dxdy ≥   W ∩U p   ( x,y ) dxdy since W ∩ U ⊂ ∆ δσ 0 = { ( b,d ) ∈ W : d − b ≤ δσ } . Next, we restrict the lower bounding integral for each term of p   to its matching subset U j and change variables to attain the desired form:

$$
\int _ { W \cap U } p ^ { \ell } ( x , y ) \, d x \, d y & \geq \sum _ { j = 1 } ^ { N _ { \ell } } \int _ { U _ { j } } \frac { 1 } { 2 \pi N _ { \ell } \sigma ^ { 2 } } e ^ { - \left ( \left ( x - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } + \left ( y - \frac { b _ { j } + d _ { j } } { 2 } \right ) ^ { 2 } \right ) / 2 \sigma ^ { 2 } } \, d x \, d y \\ & = \int _ { B ( ( 0 , 0 ) , \delta ) } \frac { 1 } { 2 \pi } e ^ { - ( x ^ { 2 } + y ^ { 2 } ) / 2 } \, d x \, d y .
$$

Overall, this argument shows that with probability at least P ( | z | ≤ δ ) M there is a correspondence which bounds the bottleneck distance by δσ and the result follows.

## A.2. Proof of Lemma 39

Choose an arbitrary persistence diagram D . Since bottleneck distance is deﬁned according to the sup-norm (see Eq. (2.2)), the bottleneck distance to the null persistence diagram (i.e., without any features) is precisely half the maximal persistence. Thus, we begin by showing that the maximal persistence moment is ﬁnite. Taking Z = { ξ 1 ,...,ξ N } with ξ i = ( b i ,d i ,k i ), we have:

$$
\int _ { \mathcal { W } _ { 0 \colon d - 1 } } \max ( d _ { i } - b _ { i } ) \delta Z \leq \int _ { \mathcal { W } _ { 0 \colon d - 1 } } \| Z \| \, f ( Z ) \delta Z
$$

since max( d i − b i ) ≤ max( ( b i ,d i ) ) ≤ Z . Consider a compact set K ⊂ W 0: − 1 which contains a neighborhood of the origin. Given assumptions ( A 2) ∗ and ( A 3) ∗ , Eq. (A.1) is bounded by the following ﬁnite expression.

$$
\int _ { \mathcal { W } _ { 0 ; d - 1 } } \| Z \| \, f ( Z ) \delta Z \leq \int _ { K } C _ { 2 } \, \| Z \| \, \delta Z + \sum _ { N = 1 } ^ { M } \int _ { h _ { N } ^ { - 1 } ( h _ { N } ( K ) ^ { c } ) } C _ { 3 } \, \| Z \| ^ { - 2 N - 1 } \, d \xi _ { 1 } \dots d \xi _ { N } .
$$

Lastly, we take advantage of the Minkowski inequality, which holds trivially for set integration since it is a linear combination of Lebesgue integrals. Indeed, the MAD centered at D 0 is bounded
