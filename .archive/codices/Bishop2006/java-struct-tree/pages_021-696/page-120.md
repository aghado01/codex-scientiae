[Page 120]

2

1

a = 0.1 b = 0.1

2

1

a = 1 b = 1

2

1

a = 4 b = 6

0

0 1 2

λ

0

0 1 2

λ

0

0 1 2

λ

Figure 2.13 Plot of the gamma distribution Gam(λ|a, b) deﬁned by (2.146) for various values of the parameters a and b.

The corresponding conjugate prior should therefore be proportional to the product of a power of λ and the exponential of a linear function of λ. This corresponds to the gamma distribution which is deﬁned by

Gam(λ|a,b) =

1 Γ(a)

baλa−1 exp(−bλ). (2.146)

Here Γ(a) is the gamma function that is deﬁned by (1.141) and that ensures that Exercise 2.41 (2.146) is correctly normalized. The gamma distribution has a ﬁnite integral if a > 0,

and the distribution itself is ﬁnite if a � 1. It is plotted, for various values of a and Exercise 2.42 b, in Figure 2.13. The mean and variance of the gamma distribution are given by

a b

E[λ] =

(2.147) var[λ] =

a b2

. (2.148)

Consider a prior distribution Gam(λ|a0,b0). If we multiply by the likelihood function (2.145), then we obtain a posterior distribution

0−1λN/2 exp�

(xn − µ)2� (2.149)

�N

λ 2

p(λ|X) ∝ λa

−b0λ −

n=1

which we recognize as a gamma distribution of the form Gam(λ|aN,bN) where

N 2

aN = a0 +

(2.150)

�N

1 2

N 2

bN = b0 +

(xn − µ)2 = b0 +

σML2 (2.151)

n=1

where σML2 is the maximum likelihood estimator of the variance. Note that in (2.149) there is no need to keep track of the normalization constants in the prior and the likelihood function because, if required, the correct coefﬁcient can be found at the end using the normalized form (2.146) for the gamma distribution.
