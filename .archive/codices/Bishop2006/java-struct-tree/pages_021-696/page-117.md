[Page 117]

Figure 2.11 In the case of a Gaussian distribution, with θ corresponding to the mean µ, the regression function illustrated in Figure 2.10 takes the form of a straight line, as shown in red. In this case, the random variable z corresponds to the derivative of the log likelihood function and is given by (x − µML)/σ2, and its expectation that deﬁnes the regression function is a straight line given by (µ − µML)/σ2. The root of the regression function corresponds to the maximum likelihood estimator µML.

p(z|µ)

µML

µ

As a speciﬁc example, we consider once again the sequential estimation of the mean of a Gaussian distribution, in which case the parameter θ(N) is the estimate µ(MLN) of the mean of the Gaussian, and the random variable z is given by

1 σ2

∂ ∂µML

z =

lnp(x|µML,σ2) =

(x − µML). (2.136)

Thus the distribution of z is Gaussian with mean µ − µML, as illustrated in Figure 2.11. Substituting (2.136) into (2.135), we obtain the univariate form of (2.126),

provided we choose the coefﬁcients aN to have the form aN = σ2/N. Note that although we have focussed on the case of a single variable, the same technique,

together with the same restrictions (2.130)–(2.132) on the coefﬁcients aN, apply equally to the multivariate case (Blum, 1965).

2.3.6 Bayesian inference for the Gaussian

The maximum likelihood framework gave point estimates for the parameters µ and Σ. Now we develop a Bayesian treatment by introducing prior distributions over these parameters. Let us begin with a simple example in which we consider a single Gaussian random variable x. We shall suppose that the variance σ2 is known, and we consider the task of inferring the mean µ given a set of N observations X = {x1,...,xN}. The likelihood function, that is the probability of the observed data given µ, viewed as a function of µ, is given by

exp�

(xn − µ)2�. (2.137)

�N

�N

1 (2πσ2)N/2

1 2σ2

p(xn|µ) =

p(X|µ) =

−

n=1

n=1

Again we emphasize that the likelihood function p(X|µ) is not a probability distribution over µ and is not normalized.

We see that the likelihood function takes the form of the exponential of a quadratic form in µ. Thus if we choose a prior p(µ) given by a Gaussian, it will be a
