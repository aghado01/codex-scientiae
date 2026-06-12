[Page 517]

Instead of thinking of λ as the variational parameter, we can let ξ play this role as this leads to simpler expressions for the conjugate function, which is then given by

g(λ) = λ(ξ)ξ2 − f(ξ) = λ(ξ)ξ2 + ln(eξ/2 + e−ξ/2). (10.142) Hence the bound on f(x) can be written as

f(x) � λx2 − g(λ) = λx2 − λξ2 − ln(eξ/2 + e−ξ/2). (10.143) The bound on the sigmoid then becomes

�

�

σ(x) � σ(ξ)exp

(x − ξ)/2 − λ(ξ)(x2 − ξ2)

(10.144)

where λ(ξ) is deﬁned by (10.141). This bound is illustrated in the right-hand plot of Figure 10.12. We see that the bound has the form of the exponential of a quadratic function of x, which will prove useful when we seek Gaussian representations of

Section 4.5 posterior distributions deﬁned through logistic sigmoid functions.

The logistic sigmoid arises frequently in probabilistic models over binary variables because it is the function that transforms a log odds ratio into a posterior probability. The corresponding transformation for a multiclass distribution is given by

Section 4.3 the softmax function. Unfortunately, the lower bound derived here for the logistic sigmoid does not directly extend to the softmax. Gibbs (1997) proposes a method for constructing a Gaussian distribution that is conjectured to be a bound (although no rigorous proof is given), which may be used to apply local variational methods to multiclass problems.

We shall see an example of the use of local variational bounds in Sections 10.6.1. For the moment, however, it is instructive to consider in general terms how these bounds can be used. Suppose we wish to evaluate an integral of the form

I = � σ(a)p(a)da (10.145)

where σ(a) is the logistic sigmoid, and p(a) is a Gaussian probability density. Such integrals arise in Bayesian models when, for instance, we wish to evaluate the predictive distribution, in which case p(a) represents a posterior parameter distribution. Because the integral is intractable, we employ the variational bound (10.144), which we write in the form σ(a) � f(a,ξ) where ξ is a variational parameter. The integral now becomes the product of two exponential-quadratic functions and so can be integrated analytically to give a bound on I

I � � f(a,ξ)p(a)da = F(ξ). (10.146)

We now have the freedom to choose the variational parameter ξ, which we do by ﬁnding the value ξ� that maximizes the function F(ξ). The resulting value F(ξ�) represents the tightest bound within this family of bounds and can be used as an approximation to I. This optimized bound, however, will in general not be exact.
