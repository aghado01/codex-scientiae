[Page 487]

optimal factor q 1(z1). In doing so it is useful to note that on the right-hand side we only need to retain those terms that have some functional dependence on z1 because all other terms can be absorbed into the normalization constant. Thus we have

###### lnq 1(z1) = Ez

[lnp(z)] + const

2

1 2

(z1 − µ1)2Λ11 − (z1 − µ1)Λ12(z2 − µ2) + const

= Ez

2 −

1 2

= −

z12Λ11 + z1µ1Λ11 − z1Λ12 (E[z2] − µ2) + const. (10.11)

Next we observe that the right-hand side of this expression is a quadratic function of z1, and so we can identify q (z1) as a Gaussian distribution. It is worth emphasizing that we did not assume that q(zi) is Gaussian, but rather we derived this result by variational optimization of the KL divergence over all possible distributions q(zi). Note also that we do not need to consider the additive constant in (10.9) explicitly because it represents the normalization constant that can be found at the end by

Section 2.3.1 inspection if required. Using the technique of completing the square, we can identify

the mean and precision of this Gaussian, giving

###### q (z1) = N(z1|m1,Λ−1

11 ) (10.12) where

###### m1 = µ1 − Λ−1

11 Λ12 (E[z2] − µ2). (10.13) By symmetry, q 2(z2) is also Gaussian and can be written as

###### q 2(z2) = N(z2|m2,Λ−1

22 ) (10.14) in which

###### m2 = µ2 − Λ−1

22 Λ21 (E[z1] − µ1). (10.15) Note that these solutions are coupled, so that q (z1) depends on expectations computed with respect to q (z2) and vice versa. In general, we address this by treating the variational solutions as re-estimation equations and cycling through the variables in turn updating them until some convergence criterion is satisﬁed. We shall see an example of this shortly. Here, however, we note that the problem is sufﬁciently simple that a closed form solution can be found. In particular, because E[z1] = m1 and E[z2] = m2, we see that the two equations are satisﬁed if we take E[z1] = µ1 and E[z2] = µ2, and it is easily shown that this is the only solution provided the dis-

Exercise 10.2 tribution is nonsingular. This result is illustrated in Figure 10.2(a). We see that the mean is correctly captured but that the variance of q(z) is controlled by the direction of smallest variance of p(z), and that the variance along the orthogonal direction is signiﬁcantly under-estimated. It is a general result that a factorized variational approximation tends to give approximations to the posterior distribution that are too compact.

By way of comparison, suppose instead that we had been minimizing the reverse Kullback-Leibler divergence KL(p q). As we shall see, this form of KL divergence
