[Page 20]

## Maroulas, Mike, and Oballe

Throughout the proof we use ξ i to denote input features and Z = { ξ 1 ,...,ξ N } or Z = ( ξ 1 ,...,ξ N ) to denote an input persistence diagram as a set or vector of features. Several preliminary lemmas are presented before the main body of the proof. We begin with a critical lemma which controls the number of features sampled in the band diagonal ∆ β α = { ( b,d ) ∈ W : α < d − b < β } .

Lemma 34 Consider a random persistence diagram D distributed according to f satisfying assumptions ( A 1) ( A 3) . Then there exists C > 0 so that E f ( | ∆ σ 0 ∩ D | ) ≤ Cσ .

Proof Consider a region A ⊂ W and a counting function κ A ( Z ) = | Z ∩ A | such that κ A ( { ξ 1 ,...,ξ N } ) =   N i =1 A ( ξ i ). It is clear that this set function is well deﬁned and measurable if A is measurable. Using set integration (Def. 12),

$$
\mathbb { E } ( | \Delta _ { 0 } ^ { \sigma } \cap D | ) = \int _ { W } \kappa _ { \Delta _ { 0 } ^ { \sigma } } ( Z ) f ( Z ) \delta Z = \sum _ { N = 0 } ^ { M } \frac { N } { N ! } \int _ { W } 1 _ { \Delta _ { 0 } ^ { \sigma } } ( \xi _ { 1 } ) \left [ \int f ( \xi _ { 1 } , \dots \xi _ { N } ) d \xi _ { 2 } \dots d \xi _ { N } \right ] d \xi _ { 1 } \quad ( 4 . 1 0 )
$$

The expressions in Eq. (4.10) can be phrased in terms of the probability hypothesis density from Eq. (3.8), and for any choice of L > 0 are bounded by

$$
\int _ { \Delta _ { 0 } ^ { \sigma } } F _ { D } ( \xi ) d \xi & \leq \int _ { 0 } ^ { L } \int _ { y - \sigma } ^ { y } F _ { D } ( x , y ) \, d x \, d y + \int _ { L } ^ { \infty } \int _ { y - \sigma } ^ { y } C _ { 3 } y ^ { - 2 } \, d x \, d y \\ & \leq L C _ { 2 } \sigma + 3 C _ { 3 } \sigma / L = ( L C _ { 2 } + C _ { 3 } / L ) \sigma
$$

where assumptions (A2) and (A3) respectively yield the bounds C 2 and C 3 y − 2 on the probability hypothesis density, F D .

Lemma 34 yields control over the counting measure ν i deﬁned in Def. 24 and the coeﬃcients Q ∗ i ( · ) of Eq. (3.11) which respectively determine the distribution of lower and upper cardinalities for a persistence diagram sampled according to the kernel density K σ ( Z, D i ).

Corollary 35 Consider a random persistence diagram D distributed according to f satisfying assumptions ( A 1) ( A 3) . Take ν to be the lower cardinality probability mass function for the kernel density K σ ( Z,D ) shown in Eq. (4.6) . Then, there exists C > 0 so that E f ν ( j 0 ) ≤ Cσ whenever j 0 = 0 .

glyph[negationslash]

Proof Since D is random with respect to f , ν is random with respect to f as well. Recall that ν is deﬁned so that E ν ( a ) = D for a distributed according to ν and thus E f [ E ν ( a )] ≤ Cσ for some C > 0 by Lemma 34. Subsequently, the value E f ν ( j 0 ) is controlled by this double expectation so long as j 0 = 0. Indeed,

glyph[negationslash]

$$
\mathbb { E } ( a ) = \sum _ { j = 0 } ^ { \infty } j \nu ( j ) = \sum _ { j = 1 } ^ { \infty } j \nu ( j ) \geq \sum _ { j = 1 } ^ { \infty } \nu ( j ) \geq \nu ( j _ { 0 } )
$$

for any j 0 > 0 and ν i ( j 0 ) = 0 for j 0 <

0 since it represents a cardinality distribution.

In the following lemma, the result of Lemma 34 is used to control the expressions Q ( γ ) or Q ∗ ( γ ), of Eq. (3.10) and Eq. (3.11) respectively, in the kernel density estimate.
