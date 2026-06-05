[Page 501]

Section 10.2.4

Exercise 10.16

Indeed, these singularities are removed if we simply introduce a prior and then use a MAP estimate instead of maximum likelihood. Furthermore, there is no over-ﬁtting if we choose a large number K of components in the mixture, as we saw in Figure 10.6. Finally, the variational treatment opens up the possibility of determining the optimal number of components in the mixture without resorting to techniques such as cross validation.

# 10.2.2 Variational lower bound

We can also straightforwardly evaluate the lower bound (10.3) for this model. In practice, it is useful to be able to monitor the bound during the re-estimation in order to test for convergence. It can also provide a valuable check on both the mathematical expressions for the solutions and their software implementation, because at each step of the iterative re-estimation procedure the value of this bound should not decrease. We can take this a stage further to provide a deeper test of the correctness of both the mathematical derivation of the update equations and of their software implementation by using ﬁnite differences to check that each update does indeed give a (constrained) maximum of the bound (Svens´ en and Bishop, 2004).

For the variational mixture of Gaussians, the lower bound (10.3) is given by

$$
\text {For the variational mixture of Gaussians, the lower bound (10.3) is given by} \\ \mathcal { L } \ = \ \sum _ { Z } \iint q ( Z , \pi , \mu , \Lambda ) \ln \left \{ \frac { p ( X , Z , \pi , \mu , \Lambda ) } { q ( Z , \pi , \mu , \Lambda ) } \right \} \, d \pi d \mu d \Lambda \\ \equiv \ \mathbb { E } [ \ln p ( X , Z , \pi , \mu , \Lambda ) ] - \mathbb { E } [ \ln q ( Z , \pi , \mu , \Lambda ) ] \\ \equiv \ \mathbb { E } [ \ln p ( X | Z , \mu , \Lambda ) ] + \mathbb { E } [ \ln p ( Z | \pi ) ] + \mathbb { E } [ \ln p ( \mu , \Lambda ) ] \\ - \mathbb { E } [ \ln q ( Z ) ] - \mathbb { E } [ \ln q ( \pi ) ] - \mathbb { E } [ \ln q ( \mu , \Lambda ) ] \\ \quad \text {where, to keep the notation uncluttered, we have omitted the * superscript on the}
$$

where, to keep the notation uncluttered, we have omitted the superscript on the q distributions, along with the subscripts on the expectation operators because each expectation is taken with respect to all of the random variables in its argument. The various terms in the bound are easily evaluated to give the following results

$$
\text { various terms in the bound are easily evaluated to give the following results} \\ \mathbb { E } [ \ln p ( X | Z , \mu , \Lambda ) ] = \frac { 1 } { 2 } \sum _ { k = 1 } ^ { K } N _ { k } \left \{ \ln \widetilde { \Lambda } _ { k } - D \beta _ { k } ^ { - 1 } - \nu _ { k } \text {Tr} ( S _ { k } W _ { k } ) \\ - \nu _ { k } ( \bar { x } _ { k } - m _ { k } ) ^ { T } W _ { k } ( \bar { x } _ { k } - m _ { k } ) - D \ln ( 2 \pi ) \right \} ( 1 0 . 7 1 ) \\ \mathbb { E } [ \ln \rho ( Z | + ) ] \sum _ { k = 1 } ^ { N } \sum _ { \substack { k = 1 \\ \sum \rho ( k ) = 0 } } \ln \widetilde { \rho } _ { k } \sim \widetilde { \rho } _ { k } \\
$$

$$
\mathbb { E } [ \ln p ( Z | \pi ) ] \ = \ \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } r _ { n k } \ln \widetilde { \pi } _ { k } \\ \mathbb { E } [ \ln p ( \pi ) ] \ = \ \ln C ( \alpha _ { 0 } ) + ( \alpha _ { 0 } - 1 ) \sum _ { k = 1 } ^ { K } \ln \widetilde { \pi } _ { k }
$$

$$
\mathbb { E } [ \ln p ( \pi ) ] \ = \ \ln C ( \alpha _ { 0 } ) + ( \alpha _ { 0 } - 1 ) \sum _ { k = 1 } ^ { K } \ln \widetilde { \pi } _ { k }
$$
