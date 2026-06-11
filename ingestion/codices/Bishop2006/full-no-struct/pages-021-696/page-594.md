[Page 594]

Figure 12.10 The probabilistic peA model for a data set of N observations of x can be expressed as a directed graph in which each observation X n is associated with a value of the latent variable.

Zn of the latent variable.

02

Zn

Xn

..-+--w

N

# 12.2.1 Maximum likelihood peA

We next consider the determination of the model parameters using maximum likelihood. Given a data set X = {x n } of observed data points, the probabilistic peA model can be expressed as a directed graph, as shown in Figure 12.10. The corresponding log likelihood function is given, from (12.35), by

$$
\ln p ( X | \mu , W , \sigma ^ { 2 } ) & = \sum _ { n = 1 } ^ { N } \ln p ( x _ { n } | W , \mu , \sigma ^ { 2 } ) \\ & = \ - \frac { N D } { 2 } \ln ( 2 \pi ) - \frac { N } { 2 } \ln | C | - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { T } C ^ { - 1 } ( x _ { n } - \mu ) .
$$

Setting the derivative of the log likelihood with respect to JL equal to zero gives the expected result JL = x where x is the data mean defined by (12.1). Back-substituting we can then write the log likelihood function in the form

$$
\ln p ( X | W , \mu , \sigma ^ { 2 } ) = - \frac { N } { 2 } \left \{ D \ln ( 2 \pi ) + \ln | C | + \text {Tr} \left ( C ^ { - 1 } S \right ) \right \} \quad
$$

where S is the data covariance matrix defined by (12.3). Because the log likelihood is a quadratic function of JL, this solution represents the unique maximum, as can be confirmed by computing second derivatives.

Maximization with respect to W and 0'2 is more complex but nonetheless has an exact closed-form solution. It was shown by Tipping and Bishop (1999b) that all of the stationary points of the log likelihood function can be written as

$$
W _ { M L } = U _ { M } ( L _ { M } - \sigma ^ { 2 } I ) ^ { 1 / 2 } R
$$

where U M is a D x M matrix whose columns are given by any subset (of size M) of the eigenvectors of the data covariance matrix S, the M x M diagonal matrix L M has elements given by the corresponding eigenvalues ..\, and R is an arbitrary M x M orthogonal matrix.

Furthermore, Tipping and Bishop (1999b) showed that the maximum of the likelihood function is obtained when the M eigenvectors are chosen to be those whose eigenvalues are the M largest (all other solutions being saddle points). A similar result was conjectured independently by Roweis (1998), although no proof was given.
