[Page 23]

which is again bounded via (A2) and (A3). Of course, |{ i : M i = m }| ≤ n , so taking Eq. (4.14) into account for every m bounds the averaging sum of the upper product: 1 n   n i =1   j k =1 q ( γ ( k )) i p ( γ ( k )) i ( ξ k ).

Relying on Eq. (4.13), we must also consider the lower product N k = j +1 p i ( ξ k ). Since the points ξ i are ﬁxed, we focus on their minimal persistence p min = min i ( d i − b i ). Thus,

and subsequently, Maroulas, Mike, and Oballe that the target distribution associated with [ ∏ N k =1 q ( k ) i p ( k ) i ( ξ k ) ] is the rescaled 1 f ( N ) f ( ξ 1 , ..., ξ N ), where f ( N ) := P f ( | D | = N ). This rescaling for the conditional pdf f ( D | | D | = N ) is necessary to reweight according to Proposition 16.

$$
p _ { i } ^ { \ell } ( \xi _ { i } ) \leq \frac { 1 } { 2 \pi \sigma ^ { 2 } } e ^ { - ( b - d ) ^ { 2 } / 4 \sigma ^ { 2 } } \leq \frac { 1 } { 2 \pi \sigma ^ { 2 } } e ^ { - p _ { \min } ^ { 2 } / 4 \sigma ^ { 2 } } ,
$$

$$
\left [ \prod _ { k = j + 1 } ^ { N } p _ { i } ^ { \ell } ( \xi _ { k } ) \right ] \leq \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { N } } e ^ { - N p _ { \min } ^ { 2 } / 4 \sigma ^ { 2 } } \rightarrow 0 ,
$$

as σ → 0, uniformly on any compact subset of W (or W 0: − 1 ). Altogether, Eqs. (4.14) and (4.15) guarantee that the term n i =1 1 n B i → 0 as n → ∞ in the kernel density estimation.

Next we focus on the terms A i in Eq. (4.12). We split the sum 1 n n i =1 A i according to the cardinality of D i . Speciﬁcally, separate A i into the cases where M i = N i or M i = N i . First consider the associated set of indices { i : M i = N i } and deﬁne the mismatch number MM( n ) to be its cardinality. Critical to our argument, the mismatch number is random with respect to f because it is deﬁned according to the features in D i . We obtain the following mismatched term:

glyph[negationslash]

glyph[negationslash]

$$
\frac { 1 } { n } \sum _ { \{ i \colon N _ { i } \neq M _ { i } \} } A _ { i } \leq \left ( \frac { M M ( n ) } { n } \right ) \frac { 1 } { M M ( n ) } \sum _ { \{ i \colon N _ { i } \neq M _ { i } \} } \left [ \mathcal { Q } _ { i } ( \text {id} ) \prod _ { k = 1 } ^ { N _ { i } } p _ { i } ^ { ( k ) } ( \xi _ { k } ) \prod _ { k = N _ { i } + 1 } ^ { N } p _ { i } ^ { \ell } ( \xi _ { k } ) \right ]
$$

glyph[negationslash]

glyph[negationslash]

The bounding sum in Eq. (4.16) is split into pieces where M i = m for each m between 0 and M . Using the same strategy yielding Eq. (4.14), with MM ( n ) in place of n , the sum of the upper product converges to layered integrals of f for each level m and each N i < m by extending γ = id. Using the same approach leading to Eq. (4.15), the lower product vanishes in the limit if N i = N , or is an empty product if N i = N ; in either case, this factor is bounded. Now, according to Lemma 34, P f ( M i = N i ) = P f ( D i ∩ ∆  σ 0 = ∅ ) ≤ C 5 σ ; consequently, E f [ MM ( n ) /n ] → 0 and the mismatch terms on left hand side of Eq. (4.16) follow.

glyph[negationslash]

glyph[negationslash]

glyph[negationslash]

Now consider the indices for which N i = M i . In this case, since D i are empty, ν i = δ 0 , and the only values which contribute to the sum are for N i = N . The remaining portion of the kernel density estimate is given by

$$
\frac { 1 } { n } \mathbb { E } ^ { f } \sum _ { \{ i \colon N _ { i } = M _ { i } \} } A _ { i } = \frac { 1 } { n } \mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon N _ { i } = M _ { i } \} } \left ( \mathcal { Q } _ { i } ( i d ) \prod _ { k = 1 } ^ { N } p _ { i } ^ { ( k ) } ( \xi k ) \right ) \right ] = \frac { 1 } { n } \mathbb { E } ^ { f } \left [ \sum _ { \{ i \colon N _ { i } = M _ { i } \} } \left ( \prod _ { k = 1 } ^ { N } q _ { i } ^ { ( k ) } p _ { i } ^ { ( k ) } ( \xi k ) \right ) \right ] .
$$

As shown, the terms in Eq. (4.17) are restricted 2 N dimensional Gaussians. It is known (Scott, 2015) that restricted Gaussian kernel density estimates like     N k =1 q ( k ) i p ( k ) i ( ξ k )   converge (uniformly on compactly contained sets) to the true value of the chosen draws D i for a suitable choice of α in σ = O ( n − α ) as restricted by N ≤ M . After correcting for the samples with N i < M i = N , the samples D i are treated as random draws from f ( D || D | = N ). Consequently, we may conclude
