[Page 137]

which can in principle be solved to obtain ηML. We see that the solution for the maximum likelihood estimator depends on the data only through n u(xn), which is therefore called the sufﬁcient statistic of the distribution (2.194). We do not need to store the entire data set itself but only the value of the sufﬁcient statistic. For the Bernoulli distribution, for example, the function u(x) is given just by x and so we need only keep the sum of the data points {xn}, whereas for the Gaussian u(x) = (x,x2)T, and so we should keep both the sum of {xn} and the sum of {x2n}.

If we consider the limit N → ∞, then the right-hand side of (2.228) becomes

E[u(x)], and so by comparing with (2.226) we see that in this limit ηML will equal the true value η.

In fact, this sufﬁciency property holds also for Bayesian inference, although we shall defer discussion of this until Chapter 8 when we have equipped ourselves with the tools of graphical models and can thereby gain a deeper insight into these important concepts.

###### 2.4.2 Conjugate priors

We have already encountered the concept of a conjugate prior several times, for example in the context of the Bernoulli distribution (for which the conjugate prior is the beta distribution) or the Gaussian (where the conjugate prior for the mean is a Gaussian, and the conjugate prior for the precision is the Wishart distribution). In general, for a given probability distribution p(x|η), we can seek a prior p(η) that is conjugate to the likelihood function, so that the posterior distribution has the same functional form as the prior. For any member of the exponential family (2.194), there exists a conjugate prior that can be written in the form

p(η|χ,ν) = f(χ,ν)g(η)ν exp νηTχ (2.229)

where f(χ,ν) is a normalization coefﬁcient, and g(η) is the same function as appears in (2.194). To see that this is indeed conjugate, let us multiply the prior (2.229) by the likelihood function (2.227) to obtain the posterior distribution, up to a normalization coefﬁcient, in the form

p(η|X,χ,ν) ∝ g(η)ν+N exp ηT

N

u(xn) + νχ . (2.230)

n=1

This again takes the same functional form as the prior (2.229), conﬁrming conjugacy. Furthermore, we see that the parameter ν can be interpreted as a effective number of pseudo-observations in the prior, each of which has a value for the sufﬁcient statistic u(x) given by χ.

###### 2.4.3 Noninformative priors

In some applications of probabilistic inference, we may have prior knowledge that can be conveniently expressed through the prior distribution. For example, if the prior assigns zero probability to some value of variable, then the posterior distribution will necessarily also assign zero probability to that value, irrespective of
