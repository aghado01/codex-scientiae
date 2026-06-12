[Page 336]

where we have used p(tN|aN+1,aN) = p(tN|aN). The conditional distribution p(aN+1|aN) is obtained by invoking the results (6.66) and (6.67) for Gaussian process regression, to give

p(aN+1|aN) = N(aN+1|kTC−1

N aN,c − kTC−1

N k). (6.78)

We can therefore evaluate the integral in (6.77) by ﬁnding a Laplace approximation for the posterior distribution p(aN|tN), and then using the standard result for the convolution of two Gaussian distributions.

The prior p(aN) is given by a zero-mean Gaussian process with covariance matrix CN, and the data term (assuming independence of the data points) is given by

p(tN|aN) =

N

N

σ(an)tn(1 − σ(an))1−tn =

n=1

n=1

ntnσ(−an). (6.79)

ea

We then obtain the Laplace approximation by Taylor expanding the logarithm of p(aN|tN), which up to an additive normalization constant is given by the quantity

Ψ(aN) = lnp(aN) + lnp(tN|aN)

1 2

1 2

N 2

aTNC−1

ln(2π) −

ln|CN| + tTNaN

= −

N aN −

N

ln(1 + ea

n) + const. (6.80)

−

n=1

First we need to ﬁnd the mode of the posterior distribution, and this requires that we evaluate the gradient of Ψ(aN), which is given by

###### ∇Ψ(aN) = tN − σN − C−1

N aN (6.81)

where σN is a vector with elements σ(an). We cannot simply ﬁnd the mode by setting this gradient to zero, because σN depends nonlinearly on aN, and so we resort to an iterative scheme based on the Newton-Raphson method, which gives rise

Section 4.3.3 to an iterative reweighted least squares (IRLS) algorithm. This requires the second

derivatives of Ψ(aN), which we also require for the Laplace approximation anyway, and which are given by

∇∇Ψ(aN) = −WN − C−1

N (6.82)

where WN is a diagonal matrix with elements σ(an)(1−σ(an)), and we have used the result (4.88) for the derivative of the logistic sigmoid function. Note that these

diagonal elements lie in the range (0,1/4), and hence WN is a positive deﬁnite matrix. Because CN (and hence its inverse) is positive deﬁnite by construction, and

- Exercise 6.24 because the sum of two positive deﬁnite matrices is also positive deﬁnite, we see that the Hessian matrix A = −∇∇Ψ(aN) is positive deﬁnite and so the posterior distribution p(aN|tN) is log convex and therefore has a single mode that is the global
