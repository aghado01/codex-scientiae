[Page 22]

First, we separate the kernel K σ ( Z, D i ), deﬁned in Eq. (4.6), into three portions, A i , B i , and C i , according to the upper cardinality j :

$$
C _ { i } , \, \text {according to the upper cardinality } \, j \colon & \\ & K _ { \sigma } ( Z , \mathcal { D } _ { i } ) = \sum _ { j = 0 } ^ { N _ { i } } \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & = \nu _ { i } ( N - N _ { i } ) Q _ { i } ( \text {id} ) \prod _ { k = 1 } ^ { N _ { i } } p _ { i } ^ { ( k ) } ( \xi _ { k } ) \prod _ { k = N + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & \quad N _ { i } - 1 \\ & + \sum _ { j = 0 , j \neq N } \, \nu _ { i } ( N - j ) \sum _ { \gamma \in I ( j , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { j } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } \, p _ { i } ^ { \ell } ( \xi _ { k } ) \\ & + 1 \{ n \in N \cdot n _ { i } \} ( N ) \nu _ { i } ( 0 ) \sum _ { \gamma \in I ( N , N _ { i } ) } \, Q _ { i } ( \gamma ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \\ & = A _ { i } + B _ { i } + C _ { i } , \\ \intertext { where } A _ { i } \text { follows from } j = N _ { i } , \, C _ { i } \text { follows from } j = N \, ( C _ { i } = 0 \text { if } N _ { i } \leq N ) , \, \text { and } B _ { i } \text { consists of all }
$$

glyph[negationslash]

where A i follows from j = N i , C i follows from j = N ( C i = 0 if N i ≤ N ), and B i consists of all remaining terms.

The terms B i in Eq. (4.12) are controlled by the lower product N k = j +1 p i ( ξ k ) . Since (1 − q ( j ) i ) ≤ 1 and ν i ( N − j ) ≤ 1 for any choice of γ and j , we have that B i is bounded above by

$$
\sum _ { j = 0 , j \neq N } ^ { N _ { i } - 1 } \sum _ { \gamma \in I ( j , N _ { i } ) } \left [ \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \prod _ { k = j + 1 } ^ { N } p _ { i } ^ { \ell } ( \xi _ { k } ) \right ] .
$$

glyph[negationslash]

The bounding sum of Eq. (4.13) consists of restricted 2 N -dimensional Gaussians, with the weights q ( j ) i dominating the restriction rescaling in Eq. (4.2). Fix π ∈ Π N and j ∈ { 0 ,...,M − 1 } \ { N } . Without loss of generality, we treat the case when the permutation π is the identity. Since our ultimate goal is to control the kernel density estimate ˆ f , consider the portion of   n i =1 1 n B i for which the cardinalities M i = | D i | are ﬁxed at level M i = m ∈ { 0 ,...,M } . Now, m = | D i | ≥ N i > j , so there is some extension for every γ within the sum, γ ∗ ∈ Π m . Recall that this collection is random because each D i is randomly distributed according to f , therefore we consider the expectation with respect to this randomness:

$$
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { M _ { i } } q _ { i } ^ { ( \gamma ^ { * } ( k ) ) } p _ { i } ^ { ( \gamma ^ { * } ( k ) ) } ( \xi _ { k } ) \right ] \to f ( \xi _ { 1 } , \dots , \xi _ { m } ) ,
$$

for any point ( ξ 1 ,...,ξ m ) as a 2 m -dimensional Gaussian kernel density estimate with a proper choice of σ = O ( n − α ) appropriate for 2 M (and hence 2 m ) dimensions (Scott, 2015). Integrating both sides against the extra coordinates, Assumptions (A2) and (A3) along with the dominated convergence theorem yield

$$
\mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon M _ { i } = m \} } \frac { 1 } { | \{ i \colon M _ { i } = m \} | } \prod _ { k = 1 } ^ { j } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \right ] \to \int _ { W ^ { m - j } } f ( \xi _ { 1 } , \dots , \xi _ { m } ) d \xi _ { j + 1 } . . . d \xi _ { m } , \quad ( 4 . 1 4 )
$$
