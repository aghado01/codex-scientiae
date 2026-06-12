[Page 80]

1.12 ( ) www Using the results (1.49) and (1.50), show that

$$
\mathbb { E } [ x _ { n } x _ { m } ] = \mu ^ { 2 } + I _ { n m } \sigma ^ { 2 }
$$

where x n and x m denote data points sampled from a Gaussian distribution with mean µ and variance σ 2 , and I nm satisﬁes I nm = 1 if n = m and I nm = 0 otherwise. Hence prove the results (1.57) and (1.58).

1.13 ( ) Suppose that the variance of a Gaussian is estimated using the result (1.56) but with the maximum likelihood estimate µ ML replaced with the true value µ of the mean. Show that this estimator has the property that its expectation is given by the true variance σ 2 .

1.14 ( ) Show that an arbitrary square matrix with elements w ij can be written in the form w ij = w S ij + w A ij where w S ij and w A ij are symmetric and anti-symmetric matrices, respectively, satisfying w S ij = w S ji and w A ij = − w A ji for all i and j . Now consider the second order term in a higher order polynomial in D dimensions, given by

$$
\sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } x _ { i } x _ { j } .
$$

Show that

$$
\sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } x _ { i } x _ { j } & = \sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } ^ { S } x _ { i } x _ { j } \\ \text { contribution from the anti-symmetric matrix vanishes. We therefore see}
$$

so that the contribution from the anti-symmetric matrix vanishes. We therefore see that, without loss of generality, the matrix of coefﬁcients w ij can be chosen to be symmetric, and so not all of the D 2 elements of this matrix can be chosen independently. Show that the number of independent parameters in the matrix w S ij is given by D ( D + 1) / 2 .

1.15 ( ) www In this exercise and the next, we explore how the number of independent parameters in a polynomial grows with the order M of the polynomial and with the dimensionality D of the input space. We start by writing down the M th order term for a polynomial in D dimensions in the form

$$
\sum _ { i _ { 1 } = 1 } ^ { D } \sum _ { i _ { 2 } = 1 } ^ { D } \cdots \sum _ { i _ { M } = 1 } ^ { D } w _ { i _ { 1 } i _ { 2 } \cdots i _ { M } } x _ { i _ { 1 } } x _ { i _ { 2 } } \cdots x _ { i _ { M } } .
$$

The coefﬁcients w i 1 i 2 ··· i M comprise D M elements, but the number of independent parameters is signiﬁcantly fewer due to the many interchange symmetries of the factor x i 1 x i 2 ··· x i M . Begin by showing that the redundancy in the coefﬁcients can be removed by rewriting this M th order term in the form

$$
\sum _ { i _ { 1 } = 1 } ^ { D } \sum _ { i _ { 2 } = 1 } ^ { i _ { 1 } } \cdots \sum _ { i _ { M } = 1 } ^ { i _ { M - 1 } } \widetilde { w } _ { i _ { 1 } i _ { 2 } \cdots i _ { M } } x _ { i _ { 1 } } x _ { i _ { 2 } } \cdots x _ { i _ { M } } .
$$
