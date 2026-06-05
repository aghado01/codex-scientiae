[Page 541]

10.29 (�) www Show that the function f(x) = ln(x) is concave for 0 < x < ∞ by computing its second derivative. Determine the form of the dual function g(λ) deﬁned by (10.133), and verify that minimization of λx − g(λ) with respect to λ according to (10.132) indeed recovers the function ln(x).

10.30 (�) By evaluating the second derivative, show that the log logistic function f(x) = −ln(1 + e−x) is concave. Derive the variational upper bound (10.137) directly by making a second order Taylor expansion of the log logistic function around a point x = ξ.

10.31 (��) By ﬁnding the second derivative with respect to x, show that the function f(x) = −ln(ex/2 + e−x/2) is a concave function of x. Now consider the second derivatives with respect to the variable x2 and hence show that it is a convex function of x2. Plot graphs of f(x) against x and against x2. Derive the lower bound (10.144) on the logistic sigmoid function directly by making a ﬁrst order Taylor series expansion of the function f(x) in the variable x2 centred on the value ξ2.

10.32 (��) www Consider the variational treatment of logistic regression with sequential learning in which data points are arriving one at a time and each must be processed and discarded before the next data point arrives. Show that a Gaussian approximation to the posterior distribution can be maintained through the use of the lower bound (10.151), in which the distribution is initialized using the prior, and as each data point is absorbed its corresponding variational parameter ξn is optimized.

10.33 (�) By differentiating the quantity Q(ξ,ξold) deﬁned by (10.161) with respect to

the variational parameter ξn show that the update equation for ξn for the Bayesian logistic regression model is given by (10.163).

10.34 (��) In this exercise we derive re-estimation equations for the variational parameters ξ in the Bayesian logistic regression model of Section 4.5 by direct maximization of the lower bound given by (10.164). To do this set the derivative of L(ξ) with respect to ξn equal to zero, making use of the result (3.117) for the derivative of the log of a determinant, together with the expressions (10.157) and (10.158) which deﬁne the mean and covariance of the variational posterior distribution q(w).

10.35 (��) Derive the result (10.164) for the lower bound L(ξ) in the variational logistic regression model. This is most easily done by substituting the expressions for the Gaussian prior q(w) = N(w|m0,S0), together with the lower bound h(w,ξ) on the likelihood function, into the integral (10.159) which deﬁnes L(ξ). Next gather together the terms which depend on w in the exponential and complete the square to give a Gaussian integral, which can then be evaluated by invoking the standard result for the normalization coefﬁcient of a multivariate Gaussian. Finally take the logarithm to obtain (10.164).

10.36 (��) Consider the ADF approximation scheme discussed in Section 10.7, and show

that inclusion of the factor fj(θ) leads to an update of the model evidence of the form

pj(D) � pj−1(D)Zj (10.242)
