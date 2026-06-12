[Page 490]

of divergences (Ali and Silvey, 1966; Amari, 1985; Minka, 2005) deﬁned by

4 1 − α2

Dα(p q) =

1 − p(x)(1+α)/2q(x)(1−α)/2 dx (10.19)

where −∞ < α < ∞ is a continuous parameter. The Kullback-Leibler divergence KL(p q) corresponds to the limit α → 1, whereas KL(q p) corresponds to the limit

- Exercise 10.6 α → −1. For all values of α we have Dα(p q) 0, with equality if, and only if,


- p(x) = q(x). Suppose p(x) is a ﬁxed distribution, and we minimize Dα(p q) with respect to some set of distributions q(x). Then for α −1 the divergence is zero forcing, so that any values of x for which p(x) = 0 will have q(x) = 0, and typically
- q(x) will under-estimate the support of p(x) and will tend to seek the mode with the largest mass. Conversely for α 1 the divergence is zero-avoiding, so that values of x for which p(x) > 0 will have q(x) > 0, and typically q(x) will stretch to cover all of p(x), and will over-estimate the support of p(x). When α = 0 we obtain a symmetric divergence that is linearly related to the Hellinger distance given by


DH(p q) = p(x)1/2 − q(x)1/2 dx. (10.20)

The square root of the Hellinger distance is a valid distance metric.

###### 10.1.3 Example: The univariate Gaussian

We now illustrate the factorized variational approximation using a Gaussian distribution over a single variable x (MacKay, 2003). Our goal is to infer the posterior distribution for the mean µ and precision τ, given a data set D = {x1,...,xN} of observed values of x which are assumed to be drawn independently from the Gaussian. The likelihood function is given by

p(D|µ,τ) =

τ 2π

N/2

τ 2

exp −

N

(xn − µ)2 . (10.21)

n=1

We now introduce conjugate prior distributions for µ and τ given by

p(µ|τ) = N µ|µ0,(λ0τ)−1 (10.22) p(τ) = Gam(τ|a0,b0) (10.23)

where Gam(τ|a0,b0) is the gamma distribution deﬁned by (2.146). Together these

- Section 2.3.6 distributions constitute a Gaussian-Gamma conjugate prior distribution. For this simple problem the posterior distribution can be found exactly, and again


Exercise 2.44 takes the form of a Gaussian-gamma distribution. However, for tutorial purposes we will consider a factorized variational approximation to the posterior distribution given by

q(µ,τ) = qµ(µ)qτ(τ). (10.24)
