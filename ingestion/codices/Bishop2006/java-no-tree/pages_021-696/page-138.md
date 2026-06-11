[Page 138]

any subsequent observations of data. In many cases, however, we may have little idea of what form the distribution should take. We may then seek a form of prior distribution, called a noninformative prior, which is intended to have as little inﬂuence on the posterior distribution as possible (Jeffries, 1946; Box and Tao, 1973; Bernardo and Smith, 1994). This is sometimes referred to as ‘letting the data speak for themselves’.

If we have a distribution p(x|λ) governed by a parameter λ, we might be tempted to propose a prior distribution p(λ) = const as a suitable prior. If λ is a discrete variable with K states, this simply amounts to setting the prior probability of each state to 1/K. In the case of continuous parameters, however, there are two potential difﬁculties with this approach. The ﬁrst is that, if the domain of λ is unbounded, this prior distribution cannot be correctly normalized because the integral over λ diverges. Such priors are called improper. In practice, improper priors can often be used provided the corresponding posterior distribution is proper, i.e., that it can be correctly normalized. For instance, if we put a uniform prior distribution over the mean of a Gaussian, then the posterior distribution for the mean, once we have observed at least one data point, will be proper.

A second difﬁculty arises from the transformation behaviour of a probability density under a nonlinear change of variables, given by (1.27). If a function h(λ) is constant, and we change variables to λ = η2, then h(η) = h(η2) will also be constant. However, if we choose the density pλ(λ) to be constant, then the density of η will be given, from (1.27), by

pη(η) = pλ(λ)

dλ dη

= pλ(η2)2η ∝ η (2.231)

and so the density over η will not be constant. This issue does not arise when we use maximum likelihood, because the likelihood function p(x|λ) is a simple function of λ and so we are free to use any convenient parameterization. If, however, we are to choose a prior distribution that is constant, we must take care to use an appropriate representation for the parameters.

Here we consider two simple examples of noninformative priors (Berger, 1985). First of all, if a density takes the form

###### p(x|µ) = f(x − µ) (2.232)

then the parameter µ is known as a location parameter. This family of densities exhibits translation invariance because if we shift x by a constant to give x = x+c, then

###### p( x| µ) = f( x − µ) (2.233)

where we have deﬁned µ = µ + c. Thus the density takes the same form in the new variable as in the original one, and so the density is independent of the choice of origin. We would like to choose a prior distribution that reﬂects this translation invariance property, and so we choose a prior that assigns equal probability mass to
