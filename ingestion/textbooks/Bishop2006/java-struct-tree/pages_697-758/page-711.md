[Page 711]

where Ijk is the j,k element of the identity matrix. Because p(xk = 1) = µk, the parameters must satisfy 0 � µk � 1 and

�

k µk = 1.

The multinomial distribution is a multivariate generalization of the binomial and

gives the distribution over counts mk for a K-state discrete variable to be in state k given a total number of observations N.

Mult(m1,m2,...,mK|µ,N) = �

� �M

N m1m2 ...mM

µm

k (B.59) E[mk] = Nµk (B.60)

k

k=1

var[mk] = Nµk(1 − µk) (B.61) cov[mjmk] = −Nµjµk (B.62)

where µ = (µ1,...,µK)T, and the quantity

�

� =

N! m1!...mK!

N m1m2 ...mK

(B.63)

gives the number of ways of taking N identical objects and assigning mk of them to bin k for k = 1,...,K. The value of µk gives the probability of the random variable taking state k, and so these parameters are subject to the constraints 0 � µk � 1 and

�

k µk = 1. The conjugate prior distribution for the parameters {µk} is the Dirichlet.

Normal

The normal distribution is simply another name for the Gaussian. In this book, we use the term Gaussian throughout, although we retain the conventional use of the symbol N to denote this distribution. For consistency, we shall refer to the normalgamma distribution as the Gaussian-gamma distribution, and similarly the normalWishart is called the Gaussian-Wishart.

Student’s t

This distribution was published by William Gosset in 1908, but his employer, Guiness Breweries, required him to publish under a pseudonym, so he chose ‘Student’. In the univariate form, Student’s t-distribution is obtained by placing a conjugate gamma prior over the precision of a univariate Gaussian distribution and then integrating out the precision variable. It can therefore be viewed as an inﬁnite mixture
