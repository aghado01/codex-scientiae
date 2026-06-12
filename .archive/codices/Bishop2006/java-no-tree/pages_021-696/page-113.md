[Page 113]

###### Marginal and Conditional Gaussians

Given a marginal Gaussian distribution for x and a conditional Gaussian distribution for y given x in the form

p(x) = N(x|µ,Λ−1) (2.113) p(y|x) = N(y|Ax + b,L−1) (2.114)

the marginal distribution of y and the conditional distribution of x given y are given by

p(y) = N(y|Aµ + b,L−1 + AΛ−1AT) (2.115)

p(x|y) = N(x|Σ{ATL(y − b) + Λµ},Σ) (2.116) where

Σ = (Λ + ATLA)−1. (2.117)

###### 2.3.4 Maximum likelihood for the Gaussian

Given a data set X = (x1,...,xN)T in which the observations {xn} are assumed to be drawn independently from a multivariate Gaussian distribution, we can estimate the parameters of the distribution by maximum likelihood. The log likelihood function is given by

N 2

ND 2

ln(2π)−

lnp(X|µ,Σ) = −

ln|Σ|−

N

1 2

(xn−µ)TΣ−1(xn−µ). (2.118)

n=1

By simple rearrangement, we see that the likelihood function depends on the data set only through the two quantities

###### N

xn,

n=1

N

xnxTn. (2.119)

n=1

These are known as the sufﬁcient statistics for the Gaussian distribution. Using Appendix C (C.19), the derivative of the log likelihood with respect to µ is given by

∂ ∂µ

lnp(X|µ,Σ) =

N

Σ−1(xn − µ) (2.120)

n=1

and setting this derivative to zero, we obtain the solution for the maximum likelihood estimate of the mean given by

1 N

µML =

N

xn (2.121)

n=1
