[Page 195]

together with a training data set comprising input basis vectors φ(xn) and corresponding target vectors tn, with n = 1,...,N. Show that the maximum likelihood solution WML for the parameter matrix W has the property that each column is given by an expression of the form (3.15), which was the solution for an isotropic noise distribution. Note that this is independent of the covariance matrix Σ. Show that the maximum likelihood solution for Σ is given by

�N

1 N

�

��

�T

tn − WMLT φ(xn)

tn − WMLT φ(xn)

Σ =

. (3.109)

n=1

3.7 (�) By using the technique of completing the square, verify the result (3.49) for the posterior distribution of the parameters w in the linear basis function model in which mN and SN are deﬁned by (3.50) and (3.51) respectively.

3.8 (��) www Consider the linear basis function model in Section 3.1, and suppose that we have already observed N data points, so that the posterior distribution over w is given by (3.49). This posterior can be regarded as the prior for the next observation. By considering an additional data point (xN+1,tN+1), and by completing the square in the exponential, show that the resulting posterior distribution is again given by (3.49) but with SN replaced by SN+1 and mN replaced by mN+1.

3.9 (��) Repeat the previous exercise but instead of completing the square by hand,

make use of the general result for linear-Gaussian models given by (2.116).

3.10 (��) www By making use of the result (2.115) to evaluate the integral in (3.57), verify that the predictive distribution for the Bayesian linear regression model is given by (3.58) in which the input-dependent variance is given by (3.59).

3.11 (��) We have seen that, as the size of a data set increases, the uncertainty associated with the posterior distribution over model parameters decreases. Make use of the matrix identity (Appendix C)

�

�

(M−1v)

vTM−1

�

�−1

M + vvT

= M−1 −

(3.110)

1 + vTM−1v

to show that the uncertainty σN2 (x) associated with the linear regression function given by (3.59) satisﬁes

σN2 +1(x) � σN2 (x). (3.111)

3.12 (��) We saw in Section 2.3.6 that the conjugate prior for a Gaussian distribution with unknown mean and unknown precision (inverse variance) is a normal-gamma distribution. This property also holds for the case of the conditional Gaussian distribution p(t|x,w,β) of the linear regression model. If we consider the likelihood function (3.10), then the conjugate prior for w and β is given by

p(w,β) = N(w|m0,β−1S0)Gam(β|a0,b0). (3.112)
