[Page 485]

It should be emphasized that we are making no further assumptions about the distribution. In particular, we place no restriction on the functional forms of the individual factors q i ( Z i ) . This factorized form of variational inference corresponds to an approximation framework developed in physics called mean ﬁeld theory (Parisi, 1988).

Amongst all distributions q ( Z ) having the form (10.5), we now seek that distribution for which the lower bound L ( q ) is largest. We therefore wish to make a free form (variational) optimization of L ( q ) with respect to all of the distributions q i ( Z i ) , which we do by optimizing with respect to each of the factors in turn. To achieve this, we ﬁrst substitute (10.5) into (10.3) and then dissect out the dependence on one of the factors q j ( Z j ) . Denoting q j ( Z j ) by simply q j to keep the notation uncluttered, we then obtain

$$
of the factors q _ { j } ( Z _ { j } ) . \, \text {Denoting} \, q _ { j } ( Z _ { j } ) \, \text {by simply} \, q _ { j } \, \text {to keep the notation uncluttered,} \\ \text {we then obtain} \\ \\ \mathcal { L } ( q ) \ = \ \int \prod _ { i } q _ { i } \left \{ \ln p ( X , Z ) - \sum _ { i } \ln q _ { i } \right \} \, d Z \\ \equiv \ \int q _ { j } \left \{ \int \ln p ( X , Z ) \prod _ { i \neq j } q _ { i } \, d Z _ { i } \right \} \, d Z _ { j } - \int q _ { j } \ln q _ { j } \, d Z _ { j } + \text {const} \\ \equiv \ \int q _ { j } \ln \widetilde { p } ( X , Z _ { j } ) \, d Z _ { j } - \int q _ { j } \ln q _ { j } \, d Z _ { j } + \text {const} \\ \text {where we have defined a new distribution} \, \widetilde { p } ( X , Z _ { j } ) \, by the relation } \\ \ln \widetilde { p } ( X , Z _ { j } ) = \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] + \text {const.}
$$

/negationslash

$$
\text {have defined a new distribution } \widetilde { p } ( X , Z _ { j } ) \, b y \, \text {the relation} \\ \ln \widetilde { p } ( X , Z _ { j } ) = \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] + \text {const.} \\ \text {notation } \mathbb { F } \, \left [ \, \dots \, \right ] \text {doms on } \text {an} \, \text {notation} \, \text {with } \text {respect} \, \text {to the a distributions}
$$

ln p ( X , Z j ) = E i = j [ln p ( X , Z )] + const . (10.7) Here the notation E i = j [ ··· ] denotes an expectation with respect to the q distributions over all variables z i for i = j , so that

/negationslash

/negationslash

/negationslash

$$
\text {variables} \, Z _ { i } \, \text {for} \, \imath \neq j , \, \text {so that} \, \\ \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] = \int \ln p ( X , Z ) \prod _ { i \neq j } q _ { i } \, \text {d} Z _ { i } . \\
$$

/negationslash

/negationslash

Now suppose we keep the { q i = j } ﬁxed and maximize L ( q ) in (10.6) with respect to all possible forms for the distribution q j ( Z j ) . This is easily done by recognizing that (10.6) is a negative Kullback-Leibler divergence between q j ( Z j ) and p ( X , Z j ) . Thus maximizing (10.6) is equivalent to minimizing the Kullback-Leibler

/negationslash

![image 39](../images/imageFile39.png)

# Leonhard Euler 1707–1783

Euler was a Swiss mathematician and physicist who worked in St. Petersburg and Berlin and who is widely considered to be one of the greatest mathematicians of all time. He is certainly the most proliﬁc, and ﬁll 75 volumes. Amongst his many

his collected works fill 75 volumes. Amongst his many contributions, he formulated the modern theory of the function, he developed (together with Lagrange) the calculus of variations, and he discovered the formula e iπ = -1 , which relates four of the most important numbers in mathematics. During the last 17 years of his life, he was almost totally blind, and yet he produced nearly half of his results during this period.
