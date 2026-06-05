[Page 299]

form

α 2

lnp(w|D) = −

β 2

wTw −

N

{y(xn,w) − tn}2 + const (5.165)

n=1

which corresponds to a regularized sum-of-squares error function. Assuming for the moment that α and β are ﬁxed, we can ﬁnd a maximum of the posterior, which we denote wMAP, by standard nonlinear optimization algorithms such as conjugate gradients, using error backpropagation to evaluate the required derivatives.

Having found a mode wMAP, we can then build a local Gaussian approximation by evaluating the matrix of second derivatives of the negative log posterior distribution. From (5.165), this is given by

A = −∇∇lnp(w|D,α,β) = αI + βH (5.166)

where H is the Hessian matrix comprising the second derivatives of the sum-ofsquares error function with respect to the components of w. Algorithms for computing and approximating the Hessian were discussed in Section 5.4. The corresponding Gaussian approximation to the posterior is then given from (4.134) by

q(w|D) = N(w|wMAP,A−1). (5.167)

Similarly, the predictive distribution is obtained by marginalizing with respect to this posterior distribution

p(t|x,D) = p(t|x,w)q(w|D)dw. (5.168)

However, even with the Gaussian approximation to the posterior, this integration is still analytically intractable due to the nonlinearity of the network function y(x,w) as a function of w. To make progress, we now assume that the posterior distribution has small variance compared with the characteristic scales of w over which y(x,w) is varying. This allows us to make a Taylor series expansion of the network function around wMAP and retain only the linear terms

y(x,w) y(x,wMAP) + gT(w − wMAP) (5.169) where we have deﬁned

g = ∇wy(x,w)|w=wMAP . (5.170) With this approximation, we now have a linear-Gaussian model with a Gaussian distribution for p(w) and a Gaussian for p(t|w) whose mean is a linear function of w of the form

p(t|x,w,β) N t|y(x,wMAP) + gT(w − wMAP),β−1 . (5.171)

- Exercise 5.38 We can therefore make use of the general result (2.115) for the marginal p(t) to give p(t|x,D,α,β) = N t|y(x,wMAP),σ2(x) (5.172)
