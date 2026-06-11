[Page 112]

Similarly, we can ﬁnd the mean of the Gaussian distribution over z by identifying the linear terms in (2.102), which are given by

xTΛµ − xTATLb + yTLb = �

x y�T �

�. (2.106)

Λµ − ATLb Lb

Using our earlier result (2.71) obtained by completing the square over the quadratic form of a multivariate Gaussian, we ﬁnd that the mean of z is given by

�

�. (2.107)

Λµ − ATLb Lb

E[z] = R−1

Exercise 2.30 Making use of (2.105), we then obtain

E[z] = �

Aµ + b�. (2.108)

µ

Next we ﬁnd an expression for the marginal distribution p(y) in which we have marginalized over x. Recall that the marginal distribution over a subset of the components of a Gaussian random vector takes a particularly simple form when ex-

Section 2.3 pressed in terms of the partitioned covariance matrix. Speciﬁcally, its mean and covariance are given by (2.92) and (2.93), respectively. Making use of (2.105) and (2.108) we see that the mean and covariance of the marginal distribution p(y) are given by

E[y] = Aµ + b (2.109) cov[y] = L−1 + AΛ−1AT. (2.110)

A special case of this result is when A = I, in which case it reduces to the convolution of two Gaussians, for which we see that the mean of the convolution is the sum of the mean of the two Gaussians, and the covariance of the convolution is the sum of their covariances.

Finally, we seek an expression for the conditional p(x|y). Recall that the results for the conditional distribution are most easily expressed in terms of the partitioned

Section 2.3 precision matrix, using (2.73) and (2.75). Applying these results to (2.105) and (2.108) we see that the conditional distribution p(x|y) has mean and covariance given by

E[x|y] = (Λ + ATLA)−1 �

�

ATL(y − b) + Λµ

(2.111) cov[x|y] = (Λ + ATLA)−1. (2.112)

The evaluation of this conditional can be seen as an example of Bayes’ theorem. We can interpret the distribution p(x) as a prior distribution over x. If the variable y is observed, then the conditional distribution p(x|y) represents the corresponding posterior distribution over x. Having found the marginal and conditional distributions, we effectively expressed the joint distribution p(z) = p(x)p(y|x) in the form p(x|y)p(y). These results are summarized below.
