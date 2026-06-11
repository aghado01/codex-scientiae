[Page 509]

where we have evaluated the integral by making use of the result (2.115) for the linear-Gaussian model. Here the input-dependent variance is given by

σ2(x) =

1 β

+ φ(x)TSNφ(x). (10.106)

Note that this takes the same form as the result (3.59) obtained with ﬁxed α except that now the expected value E[α] appears in the deﬁnition of SN.

###### 10.3.3 Lower bound

Another quantity of importance is the lower bound L deﬁned by

L(q) = E[lnp(w,α,t)] − E[lnq(w,α)]

= Ew[lnp(t|w)] + Ew,α[lnp(w|α)] + Eα[lnp(α)] −Eα[lnq(w)]w − E[lnq(α)]. (10.107)

- Exercise 10.27 Evaluation of the various terms is straightforward, making use of results obtained in previous chapters, and gives


β 2π −

N 2

β 2

E[lnp(t|w)]w =

tTt + βmTNΦTt

ln

β 2

Tr ΦTΦ(mNmTN + SN) (10.108) E[lnp(w|α)]w,α = −

−

M 2

M 2

(ψ(aN) − lnbN) −

ln(2π) +

aN 2bN

mTNmN + Tr(SN) (10.109) E[lnp(α)]α = a0 lnb0 + (a0 − 1)[ψ(aN) − lnbN]

aN bN − lnΓ(aN) (10.110)

−b0

1 2

M 2

[1 + ln(2π)] (10.111) −E[lnq(α)]α = lnΓ(aN) − (aN − 1)ψ(aN) − lnbN + aN. (10.112)

ln|SN| +

−E[lnq(w)]w =

Figure 10.9 shows a plot of the lower bound L(q) versus the degree of a polynomial model for a synthetic data set generated from a degree three polynomial. Here the prior parameters have been set to a0 = b0 = 0, corresponding to the noninformative prior p(α) ∝ 1/α, which is uniform over lnα as discussed in Section 2.3.6. As we saw in Section 10.1, the quantity L represents lower bound on the log marginal likelihood p(t|M) for the model. If we assign equal prior probabilities p(M) to the different values of M, then we can interpret L as an approximation to the posterior model probability p(M|t). Thus the variational framework assigns the highest probability to the model with M = 3. This should be contrasted with the maximum likelihood result, which assigns ever smaller residual error to models of increasing complexity until the residual error is driven to zero, causing maximum likelihood to favour severely over-ﬁtted models.
