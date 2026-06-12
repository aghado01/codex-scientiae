[Page 706]

###### Beta

| |
|---|


This is a distribution over a continuous variable µ ∈ [0,1], which is often used to represent the probability for some binary event. It is governed by two parameters a and b that are constrained by a > 0 and b > 0 to ensure that the distribution can be normalized.

Γ(a + b) Γ(a)Γ(b)

µa−1(1 − µ)b−1 (B.6) E[µ] =

Beta(µ|a,b) =

a a + b

(B.7)

ab (a + b)2(a + b + 1)

var[µ] =

(B.8)

a − 1 a + b − 2

mode[µ] =

. (B.9)

The beta is the conjugate prior for the Bernoulli distribution, for which a and b can be interpreted as the effective prior number of observations of x = 1 and x = 0, respectively. Its density is ﬁnite if a 1 and b 1, otherwise there is a singularity

- at µ = 0 and/or µ = 1. For a = b = 1, it reduces to a uniform distribution. The beta distribution is a special case of the K-state Dirichlet distribution for K = 2.


###### Binomial

The binomial distribution gives the probability of observing m occurrences of x = 1 in a set of N samples from a Bernoulli distribution, where the probability of observing x = 1 is µ ∈ [0,1].

N m

µm(1 − µ)N−m (B.10) E[m] = Nµ (B.11)

Bin(m|N,µ) =

var[m] = Nµ(1 − µ) (B.12) mode[m] = (N + 1)µ (B.13)

where (N + 1)µ denotes the largest integer that is less than or equal to (N + 1)µ, and the quantity

N! m!(N − m)!

N m

=

(B.14)

denotes the number of ways of choosing m objects out of a total of N identical objects. Here m!, pronounced ‘factorial m’, denotes the product m × (m − 1) × ...,×2 × 1. The particular case of the binomial distribution for N = 1 is known as the Bernoulli distribution, and for large N the binomial distribution is approximately Gaussian. The conjugate prior for µ is the beta distribution.
