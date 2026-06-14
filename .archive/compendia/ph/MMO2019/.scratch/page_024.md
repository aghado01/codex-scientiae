[Page 24]

Application of classical kernel density estimate results require division by the cardinality of the draw, when in context n is generally larger than this cardinality. Thus, we must again consider the cases wherein N i   = M i . Consequently, we ﬁnd that the expectation for the ratio between the true draw cardinality and n is given by P f ( | D | = N ) + O ( σ ) according to Lemma 34. Indeed, this ratio converges to f ( N ) := P f ( | D | = N ). After this ﬁnal correction, we have shown that 1 n   n i =1 A i approach the true pdf f ( ξ 1 ,...,ξ N ).

glyph[negationslash]

Lastly, we need only to control the terms C i from Eq. (4.12). We begin by bounding the probability mass functions ν i by 1 and considering only terms for which the characteristic function is nonzero:

$$
\frac { 1 } { n } \sum _ { i = 1 } ^ { n } C _ { i } & = \frac { 1 } { n } \sum _ { \{ i ; N < N \} } \nu _ { i } ( 0 ) \sum _ { \gamma \in I ( N , N _ { i } ) } \mathcal { Q } _ { i } ( \gamma ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \leq \frac { 1 } { n } \sum _ { \{ i ; N < N _ { i } \} } \sum _ { \gamma \in I ( N , N _ { i } ) } \mathcal { Q } _ { i } ( \gamma ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) . \\ \\ N o r t _ { \ } w o r l i t \, \cdot \, \text {comm.} \, Q ( \gamma ) \, \underset { \ } o w d o n g l e p _ { \ } A _ { i } \, ( 3 \, 1 0 ) \, \text {, and} \, \text {only} \, I _ { \ } o m m e \, 3 6 \, \text {to the unpn bound}
$$

Next, we split the term Q ( γ ) according to Eq. (3.10) and apply Lemma 36 to the upper bound in Eq. (4.18) to obtain the larger upper bound

$$
\frac { 1 } { n } \sum _ { \{ i \colon N < N _ { i } \} \gamma \in I ( N , N _ { i } ) } \mathcal { Q } ^ { * } ( \gamma ) \prod _ { k = 1 } ^ { N } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \leq C \left [ \frac { 1 } { n } \sum _ { \{ i \colon N < N _ { i } \} \gamma \in I ( N , N _ { i } ) } \prod _ { k = 1 } ^ { N } q _ { i } ^ { ( \gamma ( k ) ) } p _ { i } ^ { ( \gamma ( k ) ) } ( \xi _ { k } ) \right ] \sigma .
$$

The expectation of the bracketed terms in Eq. (4.19) converges in a fashion identical to the terms 1 n n i =1 A i . Since these terms are multiplied by σ , altogether 1 n n i =1 C i vanishes in the limit as n → ∞ . Putting together the limits of each portion built from K σ ( Z, D i ) = A i + B i + C i , the theorem follows.  

## 4.3. A Measure of Dispersion

Theorem 31 has established the convergence of a kernel density estimator. Along with density function estimation, one would like to verify the convergence of properties such as spread. In the absence of vector space structure on the space of persistence diagrams, we turn to the bottleneck metric (Def. 5) to deﬁne a notion of spread. Speciﬁcally, we measure dispersion with respect to a distribution of persistence diagrams through its mean absolute deviation in this metric.

Deﬁnition 37 The mean absolute bottleneck deviation (MAD) from origin diagram D with respect to a global pdf f is given by

$$
M A D _ { f } ( \mathcal { D } ) = \int _ { \mathcal { W } _ { 0 \colon d - 1 } } W _ { \infty } ( \mathcal { D } , Z ) f ( Z ) \delta Z
$$

The following proposition and lemma aid in proving convergence of MAD kernel estimates. Their proofs are delegated to the supplementary materials.
