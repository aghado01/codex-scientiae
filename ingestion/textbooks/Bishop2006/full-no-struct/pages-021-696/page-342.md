[Page 342]

6.18 ( ) Consider a Nadaraya-Watson model with one input variable x and one target variable t having Gaussian components with isotropic covariances, so that the covariance matrix is given by σ 2 I where I is the unit matrix. Write down expressions for the conditional density p ( t | x ) and for the conditional mean E [ t | x ] and variance var[ t | x ] , in terms of the kernel function k ( x,x n ) .

6.19 ( ) Another viewpoint on kernel regression comes from a consideration of regression problems in which the input variables as well as the target variables are corrupted with additive noise. Suppose each target value t n is generated as usual by taking a function y ( z n ) evaluated at a point z n , and adding Gaussian noise. The value of z n is not directly observed, however, but only a noise corrupted version x n = z n + ξ n where the random variable ξ is governed by some distribution g ( ξ ) . Consider a set of observations { x n ,t n } , where n = 1 ,...,N , together with a corresponding sum-of-squares error function deﬁned by averaging over the distribution of input noise to give

$$
E = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \int \{ y ( x _ { n } - \xi _ { n } ) - t _ { n } \} ^ { 2 } \, g ( \xi _ { n } ) \, d \xi _ { n } . \\ \intertext { \text {imizing } F with respect to the function } u ( z ) \, \text {using the calculus of variations}
$$

By minimizing E with respect to the function y ( z ) using the calculus of variations (Appendix D), show that optimal solution for y ( x ) is given by a Nadaraya-Watson kernel regression solution of the form (6.45) with a kernel of the form (6.46).

6.20 ( ) www Verify the results (6.66) and (6.67).

6.21 ( ) www Consider a Gaussian process regression model in which the kernel function is deﬁned in terms of a ﬁxed set of nonlinear basis functions. Show that the predictive distribution is identical to the result (3.58) obtained in Section 3.3.2 for the Bayesian linear regression model. To do this, note that both models have Gaussian predictive distributions, and so it is only necessary to show that the conditional mean and variance are the same. For the mean, make use of the matrix identity (C.6), and for the variance, make use of the matrix identity (C.7).

6.22 ( ) Consider a regression problem with N training set input vectors x 1 ,..., x N and L test set input vectors x N +1 ,..., x N + L , and suppose we deﬁne a Gaussian process prior over functions t ( x ) . Derive an expression for the joint predictive distribution for t ( x N +1 ) ,...,t ( x N + L ), given the values of t ( x 1 ) ,...,t ( x N ) . Show the marginal of this distribution for one of the test observations t j where N + 1 j N + L is given by the usual Gaussian process regression result (6.66) and (6.67).

6.23 ( ) www Consider a Gaussian process regression model in which the target variable t has dimensionality D . Write down the conditional distribution of t N +1 for a test input vector x N +1 , given a training set of input vectors x 1 ,..., x N +1 and corresponding target observations t 1 ,..., t N .

6.24 ( ) Show that a diagonal matrix W whose elements satisfy 0 < W ii < 1 is positive deﬁnite. Show that the sum of two positive deﬁnite matrices is itself positive deﬁnite.
