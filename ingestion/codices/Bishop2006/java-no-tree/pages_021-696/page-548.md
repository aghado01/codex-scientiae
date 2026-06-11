[Page 548]

- y1 = z1 −2lnz1 r2

1/2

(11.10)

- y2 = z2 −2lnz2 r2


1/2

(11.11)

- Exercise 11.4 where r2 = z12 + z22. Then the joint distribution of y1 and y2 is given by

p(y1,y2) = p(z1,z2)

∂(z1,z2) ∂(y1,y2)

=

1 √2π

exp(−y12/2)

1 √2π

exp(−y22/2) (11.12)

and so y1 and y2 are independent and each has a Gaussian distribution with zero mean and unit variance.

If y has a Gaussian distribution with zero mean and unit variance, then σy + µ will have a Gaussian distribution with mean µ and variance σ2. To generate vectorvalued variables having a multivariate Gaussian distribution with mean µ and covariance Σ, we can make use of the Cholesky decomposition, which takes the form Σ = LLT (Press et al., 1992). Then, if z is a vector valued random variable whose components are independent and Gaussian distributed with zero mean and unit vari-

- Exercise 11.5 ance, then y = µ + Lz will have mean µ and covariance Σ. Obviously, the transformation technique depends for its success on the ability


to calculate and then invert the indeﬁnite integral of the required distribution. Such operations will only be feasible for a limited number of simple distributions, and so we must turn to alternative approaches in search of a more general strategy. Here we consider two techniques called rejection sampling and importance sampling. Although mainly limited to univariate distributions and thus not directly applicable to complex problems in many dimensions, they do form important components in more general strategies.

###### 11.1.2 Rejection sampling

The rejection sampling framework allows us to sample from relatively complex distributions, subject to certain constraints. We begin by considering univariate distributions and discuss the extension to multiple dimensions subsequently.

Suppose we wish to sample from a distribution p(z) that is not one of the simple, standard distributions considered so far, and that sampling directly from p(z) is difﬁcult. Furthermore suppose, as is often the case, that we are easily able to evaluate p(z) for any given value of z, up to some normalizing constant Z, so that

p(z) =

1 Zp

p(z) (11.13)

where p(z) can readily be evaluated, but Zp is unknown.

In order to apply rejection sampling, we need some simpler distribution q(z), sometimes called a proposal distribution, from which we can readily draw samples.
