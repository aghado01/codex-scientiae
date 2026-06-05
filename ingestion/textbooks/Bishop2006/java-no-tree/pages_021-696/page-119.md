[Page 119]

Figure 2.12 Illustration of Bayesian inference for the mean µ of a Gaussian distribution, in which the variance is assumed to be known. The curves show the prior distribution over µ (the curve labelled N = 0), which in this case is itself Gaussian, along with the posterior distribution given by (2.140) for increasing numbers N of data points. The data points are generated from a Gaussian of mean 0.8 and variance 0.1, and the prior is chosen to have mean 0. In both the prior and the likelihood function, the variance is set to the true value.

5

|N = 0<br><br>N = 1<br><br>N = 2<br><br>N = 10<br><br>|
|---|


0

−1 0 1

We illustrate our analysis of Bayesian inference for the mean of a Gaussian distribution in Figure 2.12. The generalization of this result to the case of a Ddimensional Gaussian random variable x with known covariance and unknown mean

- Exercise 2.40 is straightforward. We have already seen how the maximum likelihood expression for the mean of


- Section 2.3.5 a Gaussian can be re-cast as a sequential update formula in which the mean after observing N data points was expressed in terms of the mean after observing N − 1


data points together with the contribution from data point xN. In fact, the Bayesian paradigm leads very naturally to a sequential view of the inference problem. To see this in the context of the inference of the mean of a Gaussian, we write the posterior distribution with the contribution from the ﬁnal data point xN separated out so that

N−1

p(µ|D) ∝ p(µ)

p(xn|µ) p(xN|µ). (2.144)

n=1

The term in square brackets is (up to a normalization coefﬁcient) just the posterior distribution after observing N − 1 data points. We see that this can be viewed as a prior distribution, which is combined using Bayes’ theorem with the likelihood function associated with data point xN to arrive at the posterior distribution after observing N data points. This sequential view of Bayesian inference is very general and applies to any problem in which the observed data are assumed to be independent and identically distributed.

So far, we have assumed that the variance of the Gaussian distribution over the data is known and our goal is to infer the mean. Now let us suppose that the mean is known and we wish to infer the variance. Again, our calculations will be greatly simpliﬁed if we choose a conjugate form for the prior distribution. It turns out to be most convenient to work with the precision λ ≡ 1/σ2. The likelihood function for λ takes the form

p(X|λ) =

N

λ 2

N(xn|µ,λ−1) ∝ λN/2 exp −

n=1

N

(xn − µ)2 . (2.145)

n=1
