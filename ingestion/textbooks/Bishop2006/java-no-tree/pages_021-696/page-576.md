[Page 576]

###### Exercises

- 11.1 ( ) www Show that the ﬁnite sample estimator f deﬁned by (11.2) has mean equal to E[f] and variance given by (11.3).

- 11.2 ( ) Suppose that z is a random variable with uniform distribution over (0,1) and that we transform z using y = h−1(z) where h(y) is given by (11.6). Show that y has the distribution p(y).
- 11.3 ( ) Given a random variable z that is uniformly distributed over (0,1), ﬁnd a transformation y = f(z) such that y has a Cauchy distribution given by (11.8).
- 11.4 ( ) Suppose that z1 and z2 are uniformly distributed over the unit circle, as shown in Figure 11.3, and that we make the change of variables given by (11.10) and (11.11). Show that (y1,y2) will be distributed according to (11.12).
- 11.5 ( ) www Let z be a D-dimensional random variable having a Gaussian distribution with zero mean and unit covariance matrix, and suppose that the positive deﬁnite symmetric matrix Σ has the Cholesky decomposition Σ = LLT where L is a lowertriangular matrix (i.e., one with zeros above the leading diagonal). Show that the variable y = µ + Lz has a Gaussian distribution with mean µ and covariance Σ. This provides a technique for generating samples from a general multivariate Gaussian using samples from a univariate Gaussian having zero mean and unit variance.

- 11.6 ( ) www In this exercise, we show more carefully that rejection sampling does indeed draw samples from the desired distribution p(z). Suppose the proposal distribution is q(z) and show that the probability of a sample value z being accepted is given by p(z)/kq(z) where p is any unnormalized distribution that is proportional to p(z), and the constant k is set to the smallest value that ensures kq(z) p(z) for all values of z. Note that the probability of drawing a value z is given by the probability of drawing that value from q(z) times the probability of accepting that value given that it has been drawn. Make use of this, along with the sum and product rules of probability, to write down the normalized form for the distribution over z, and show that it equals p(z).

- 11.7 ( ) Suppose that z has a uniform distribution over the interval [0,1]. Show that the variable y = btanz + c has a Cauchy distribution given by (11.16).
- 11.8 ( ) Determine expressions for the coefﬁcients ki in the envelope distribution (11.17) for adaptive rejection sampling using the requirements of continuity and normalization.
- 11.9 ( ) By making use of the technique discussed in Section 11.1.1 for sampling from a single exponential distribution, devise an algorithm for sampling from the piecewise exponential distribution deﬁned by (11.17).
- 11.10 ( ) Show that the simple random walk over the integers deﬁned by (11.34), (11.35), and (11.36) has the property that E[(z(τ))2] = E[(z(τ−1))2] + 1/2 and hence by induction that E[(z(τ))2] = τ/2.
