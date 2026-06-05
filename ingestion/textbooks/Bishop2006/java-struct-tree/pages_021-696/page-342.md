[Page 342]

6.18 (�) Consider a Nadaraya-Watson model with one input variable x and one target variable t having Gaussian components with isotropic covariances, so that the covariance matrix is given by σ2I where I is the unit matrix. Write down expressions for the conditional density p(t|x) and for the conditional mean E[t|x] and variance var[t|x], in terms of the kernel function k(x,xn).

6.19 (��) Another viewpoint on kernel regression comes from a consideration of regression problems in which the input variables as well as the target variables are corrupted with additive noise. Suppose each target value tn is generated as usual by taking a function y(zn) evaluated at a point zn, and adding Gaussian noise. The value of zn is not directly observed, however, but only a noise corrupted version xn = zn + ξn where the random variable ξ is governed by some distribution g(ξ). Consider a set of observations {xn,tn}, where n = 1,...,N, together with a corresponding sum-of-squares error function deﬁned by averaging over the distribution of input noise to give

� {y(xn − ξn) − tn}2 g(ξn)dξn. (6.99)

�N

1 2

E =

n=1

By minimizing E with respect to the function y(z) using the calculus of variations (Appendix D), show that optimal solution for y(x) is given by a Nadaraya-Watson kernel regression solution of the form (6.45) with a kernel of the form (6.46).

6.20 (��) www Verify the results (6.66) and (6.67).

6.21 (��) www Consider a Gaussian process regression model in which the kernel function is deﬁned in terms of a ﬁxed set of nonlinear basis functions. Show that the predictive distribution is identical to the result (3.58) obtained in Section 3.3.2 for the Bayesian linear regression model. To do this, note that both models have Gaussian predictive distributions, and so it is only necessary to show that the conditional mean and variance are the same. For the mean, make use of the matrix identity (C.6), and for the variance, make use of the matrix identity (C.7).

6.22 (��) Consider a regression problem with N training set input vectors x1,...,xN and L test set input vectors xN+1,...,xN+L, and suppose we deﬁne a Gaussian process prior over functions t(x). Derive an expression for the joint predictive dis-

tribution for t(xN+1),...,t(xN+L), given the values of t(x1),...,t(xN). Show the marginal of this distribution for one of the test observations tj where N + 1 � j � N + L is given by the usual Gaussian process regression result (6.66) and (6.67).

6.23 (��) www Consider a Gaussian process regression model in which the target variable t has dimensionality D. Write down the conditional distribution of tN+1 for a test input vector xN+1, given a training set of input vectors x1,...,xN+1 and corresponding target observations t1,...,tN.

6.24 (�) Show that a diagonal matrix W whose elements satisfy 0 < Wii < 1 is positive deﬁnite. Show that the sum of two positive deﬁnite matrices is itself positive deﬁnite.
