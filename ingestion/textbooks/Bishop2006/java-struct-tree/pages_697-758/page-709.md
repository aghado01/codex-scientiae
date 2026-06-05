[Page 709]

positive-deﬁnite.

(x − µ)TΣ−1(x − µ)� (B.37) E[x] = µ (B.38) cov[x] = Σ (B.39) mode[x] = µ (B.40)

exp�−

1 |Σ|1/2

1 2

1 (2π)D/2

N(x|µ,Σ) =

1 2

D 2

ln|Σ| +

(1 + ln(2π)). (B.41)

H[x] =

The inverse of the covariance matrix Λ = Σ−1 is the precision matrix, which is also symmetric and positive deﬁnite. Averages of random variables tend to a Gaussian, by the central limit theorem, and the sum of two Gaussian variables is again Gaussian. The Gaussian is the distribution that maximizes the entropy for a given variance (or covariance). Any linear transformation of a Gaussian random variable is again Gaussian. The marginal distribution of a multivariate Gaussian with respect to a subset of the variables is itself Gaussian, and similarly the conditional distribution is also Gaussian. The conjugate prior for µ is the Gaussian, the conjugate prior for Λ is the Wishart, and the conjugate prior for (µ,Λ) is the Gaussian-Wishart.

If we have a marginal Gaussian distribution for x and a conditional Gaussian distribution for y given x in the form

p(x) = N(x|µ,Λ−1) (B.42) p(y|x) = N(y|Ax + b,L−1) (B.43)

then the marginal distribution of y, and the conditional distribution of x given y, are given by

p(y) = N(y|Aµ + b,L−1 + AΛ−1AT) (B.44)

p(x|y) = N(x|Σ{ATL(y − b) + Λµ},Σ) (B.45) where

Σ = (Λ + ATLA)−1. (B.46)

If we have a joint Gaussian distribution N(x|µ,Σ) with Λ ≡ Σ−1 and we deﬁne the following partitions

x = �

xa xb�, µ = �

� (B.47)

µa µb

Σ = �

Σaa Σab Σba Σbb�, Λ = �

Λaa Λab Λba Λbb� (B.48)

then the conditional distribution p(xa|xb) is given by p(xa|xb) = N(x|µa|b,Λ−1

aa ) (B.49) µa|b = µa − Λ−1

aa Λab(xb − µb) (B.50)
