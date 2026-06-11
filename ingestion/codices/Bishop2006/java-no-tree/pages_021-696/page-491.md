[Page 491]

Note that the true posterior distribution does not factorize in this way. The optimum factors qµ(µ) and qτ(τ) can be obtained from the general result (10.9) as follows. For qµ(µ) we have

lnq µ(µ) = Eτ [lnp(D|µ,τ) + lnp(µ|τ)] + const

N

E[τ] 2

(xn − µ)2 + const. (10.25)

λ0(µ − µ0)2 +

= −

n=1

Completing the square over µ we see that qµ(µ) is a Gaussian N µ|µN,λ−N1 with

- Exercise 10.7 mean and precision given by

µN =

λ0µ0 + Nx λ0 + N

(10.26) λN = (λ0 + N)E[τ]. (10.27)

Note that for N → ∞ this gives the maximum likelihood result in which µN = x and the precision is inﬁnite.

Similarly, the optimal solution for the factor qτ(τ) is given by

lnq τ(τ) = Eµ [lnp(D|µ,τ) + lnp(µ|τ)] + lnp(τ) + const

= (a0 − 1)lnτ − b0τ +

N 2

lnτ

−

τ 2

Eµ

N

n=1

(xn − µ)2 + λ0(µ − µ0)2 + const (10.28)

and hence qτ(τ) is a gamma distribution Gam(τ|aN,bN) with parameters

aN = a0 +

N 2

(10.29)

bN = b0 +

1 2

Eµ

N

n=1

(xn − µ)2 + λ0(µ − µ0)2 . (10.30)

- Exercise 10.8 Again this exhibits the expected behaviour when N → ∞. It should be emphasized that we did not assume these speciﬁc functional forms


for the optimal distributions qµ(µ) and qτ(τ). They arose naturally from the structure Section 10.4.1 of the likelihood function and the corresponding conjugate priors.

Thus we have expressions for the optimal distributions qµ(µ) and qτ(τ) each of which depends on moments evaluated with respect to the other distribution. One approach to ﬁnding a solution is therefore to make an initial guess for, say, the moment E[τ] and use this to re-compute the distribution qµ(µ). Given this revised distribution we can then extract the required moments E[µ] and E[µ2], and use these to recompute the distribution qτ(τ), and so on. Since the space of hidden variables for this example is only two dimensional, we can illustrate the variational approximation to the posterior distribution by plotting contours of both the true posterior and the factorized approximation, as illustrated in Figure 10.4.
