[Page 118]

conjugate distribution for this likelihood function because the corresponding posterior will be a product of two exponentials of quadratic functions of µ and hence will also be Gaussian. We therefore take our prior distribution to be

p(µ) = N µ|µ0,σ02 (2.138) and the posterior distribution is given by

p(µ|X) ∝ p(X|µ)p(µ). (2.139) Exercise 2.38 Simple manipulation involving completing the square in the exponent shows that the

posterior distribution is given by

p(µ|X) = N µ|µN,σN2 (2.140) where

σ2 Nσ02 + σ2

Nσ02 Nσ02 + σ2

µN =

µ0 +

µML (2.141) 1 σN2

1 σ02

N σ2

=

+

(2.142)

in which µML is the maximum likelihood solution for µ given by the sample mean

1 N

µML =

N

xn. (2.143)

n=1

It is worth spending a moment studying the form of the posterior mean and variance. First of all, we note that the mean of the posterior distribution given by (2.141) is a compromise between the prior mean µ0 and the maximum likelihood solution µML. If the number of observed data points N = 0, then (2.141) reduces to the prior mean as expected. For N → ∞, the posterior mean is given by the maximum likelihood solution. Similarly, consider the result (2.142) for the variance of the posterior distribution. We see that this is most naturally expressed in terms of the inverse variance, which is called the precision. Furthermore, the precisions are additive, so that the precision of the posterior is given by the precision of the prior plus one contribution of the data precision from each of the observed data points. As we increase the number of observed data points, the precision steadily increases, corresponding to a posterior distribution with steadily decreasing variance. With no observed data points, we have the prior variance, whereas if the number of data points N → ∞, the variance σN2 goes to zero and the posterior distribution becomes inﬁnitely peaked around the maximum likelihood solution. We therefore see that the maximum likelihood result of a point estimate for µ given by (2.143) is recovered precisely from the Bayesian formalism in the limit of an inﬁnite number of observations. Note also that for ﬁnite N, if we take the limit σ02 → ∞ in which the prior has inﬁnite variance then the posterior mean (2.141) reduces to the maximum likelihood result, while from (2.142) the posterior variance is given by σN2 = σ2/N.
