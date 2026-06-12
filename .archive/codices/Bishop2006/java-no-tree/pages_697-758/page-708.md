[Page 708]

###### Gamma

| |
|---|


The Gamma is a probability distribution over a positive random variable τ > 0 governed by parameters a and b that are subject to the constraints a > 0 and b > 0 to ensure that the distribution can be normalized.

1 Γ(a)

Gam(τ|a,b) =

baτa−1e−bτ (B.26) E[τ] =

a b

(B.27) var[τ] =

a b2

(B.28) mode[τ] =

a − 1 b

for α 1 (B.29) E[lnτ] = ψ(a) − lnb (B.30)

H[τ] = lnΓ(a) − (a − 1)ψ(a) − lnb + a (B.31)

where ψ(·) is the digamma function deﬁned by (B.25). The gamma distribution is the conjugate prior for the precision (inverse variance) of a univariate Gaussian. For a 1 the density is everywhere ﬁnite, and the special case of a = 1 is known as the exponential distribution.

###### Gaussian

| |
|---|


The Gaussian is the most widely used distribution for continuous variables. It is also known as the normal distribution. In the case of a single variable x ∈ (−∞,∞) it is governed by two parameters, the mean µ ∈ (−∞,∞) and the variance σ2 > 0.

1 (2πσ2)1/2

1 2σ2

N(x|µ,σ2) =

exp −

(x − µ)2 (B.32)

E[x] = µ (B.33) var[x] = σ2 (B.34)

mode[x] = µ (B.35) H[x] =

1 2

1 2

lnσ2 +

(1 + ln(2π)). (B.36)

The inverse of the variance τ = 1/σ2 is called the precision, and the square root of the variance σ is called the standard deviation. The conjugate prior for µ is the Gaussian, and the conjugate prior for τ is the gamma distribution. If both µ and τ are unknown, their joint conjugate prior is the Gaussian-gamma distribution.

For a D-dimensional vector x, the Gaussian is governed by a D-dimensional mean vector µ and a D × D covariance matrix Σ that must be symmetric and
