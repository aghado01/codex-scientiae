[Page 123]

Figure 2.15 Plot of Student’s t-distribution (2.159) for µ = 0 and λ = 1 for various values of ν. The limit ν → ∞ corresponds to a Gaussian distribution with mean µ and precision λ.

0.5

0.4

0.3

ν → ∞ ν = 1.0 ν = 0.1

0.2

0.1

0

−5 0 5

p(x|µ,a,b) = � ∞

N(x|µ,τ−1)Gam(τ|a,b)dτ (2.158)

0

= � ∞

Γ(a) � τ

2π�1/2 exp�−

(x − µ)2� dτ

bae(−bτ)τa−1

τ 2

0

�

�1/2 �b +

�−a−1/2 Γ(a + 1/2)

1 2π

(x − µ)2 2

ba Γ(a)

=

where we have made the change of variable z = τ[b + (x − µ)2/2]. By convention we deﬁne new parameters given by ν = 2a and λ = a/b, in terms of which the distribution p(x|µ,a,b) takes the form

�

�1/2 �1 +

�−ν/2−1/2 (2.159)

Γ(ν/2 + 1/2) Γ(ν/2)

λ(x − µ)2 ν

λ πν

St(x|µ,λ,ν) =

which is known as Student’s t-distribution. The parameter λ is sometimes called the precision of the t-distribution, even though it is not in general equal to the inverse of the variance. The parameter ν is called the degrees of freedom, and its effect is illustrated in Figure 2.15. For the particular case of ν = 1, the t-distribution reduces to the Cauchy distribution, while in the limit ν → ∞ the t-distribution St(x|µ,λ,ν)

Exercise 2.47 becomes a Gaussian N(x|µ,λ−1) with mean µ and precision λ.

From (2.158), we see that Student’s t-distribution is obtained by adding up an inﬁnite number of Gaussian distributions having the same mean but different precisions. This can be interpreted as an inﬁnite mixture of Gaussians (Gaussian mixtures will be discussed in detail in Section 2.3.9. The result is a distribution that in general has longer ‘tails’ than a Gaussian, as was seen in Figure 2.15. This gives the tdistribution an important property called robustness, which means that it is much less sensitive than the Gaussian to the presence of a few data points which are outliers. The robustness of the t-distribution is illustrated in Figure 2.16, which compares the maximum likelihood solutions for a Gaussian and a t-distribution. Note that the maximum likelihood solution for the t-distribution can be found using the expectation-

Exercise 12.24 maximization (EM) algorithm. Here we see that the effect of a small number of
