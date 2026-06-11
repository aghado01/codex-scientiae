[Page 80]

1.12 (��) www Using the results (1.49) and (1.50), show that

E[xnxm] = µ2 + Inmσ2 (1.130)

where xn and xm denote data points sampled from a Gaussian distribution with mean µ and variance σ2, and Inm satisﬁes Inm = 1 if n = m and Inm = 0 otherwise. Hence prove the results (1.57) and (1.58).

1.13 (�) Suppose that the variance of a Gaussian is estimated using the result (1.56) but

with the maximum likelihood estimate µML replaced with the true value µ of the mean. Show that this estimator has the property that its expectation is given by the true variance σ2.

1.14 (��) Show that an arbitrary square matrix with elements wij can be written in the form wij = wijS + wijA where wijS and wijA are symmetric and anti-symmetric matrices, respectively, satisfying wijS = wjiS and wijA = −wjiA for all i and j. Now consider the second order term in a higher order polynomial in D dimensions, given by

�D

�D

wijxixj. (1.131)

i=1

j=1

Show that

�D

�D

�D

�D

wijxixj =

wijS xixj (1.132)

i=1

j=1

i=1

j=1

so that the contribution from the anti-symmetric matrix vanishes. We therefore see that, without loss of generality, the matrix of coefﬁcients wij can be chosen to be symmetric, and so not all of the D2 elements of this matrix can be chosen independently. Show that the number of independent parameters in the matrix wijS is given by D(D + 1)/2.

1.15 (���) www In this exercise and the next, we explore how the number of independent parameters in a polynomial grows with the order M of the polynomial and with the dimensionality D of the input space. We start by writing down the Mth order term for a polynomial in D dimensions in the form

�D

�D

�D

. (1.133)

···

2 ···xi

wi

1i2···iMxi

xi

1

M

i1=1

i2=1

iM=1

1i2···iM comprise DM elements, but the number of independent parameters is signiﬁcantly fewer due to the many interchange symmetries of the factor xi

The coefﬁcients wi

. Begin by showing that the redundancy in the coefﬁcients can be removed by rewriting this Mth order term in the form

2 ···xi

xi

1

M

�i1

�D

i1=1

i2=1

i�M−1 iM=1w�i

···

1i2···iMxi

1

2 ···xi

xi

M

. (1.134)
