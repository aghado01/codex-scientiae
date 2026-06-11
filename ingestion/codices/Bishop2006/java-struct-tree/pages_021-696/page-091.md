[Page 91]

given by (2.3) and (2.4), respectively, we have

�N

E[m] ≡

mBin(m|N,µ) = Nµ (2.11)

m=0

�N

(m − E[m])2 Bin(m|N,µ) = Nµ(1 − µ). (2.12)

var[m] ≡

m=0

Exercise 2.4 These results can also be proved directly using calculus.

2.1.1 The beta distribution

We have seen in (2.8) that the maximum likelihood setting for the parameter µ in the Bernoulli distribution, and hence in the binomial distribution, is given by the fraction of the observations in the data set having x = 1. As we have already noted, this can give severely over-ﬁtted results for small data sets. In order to develop a Bayesian treatment for this problem, we need to introduce a prior distribution p(µ) over the parameter µ. Here we consider a form of prior distribution that has a simple interpretation as well as some useful analytical properties. To motivate this prior, we note that the likelihood function takes the form of the product of factors of the form µx(1 − µ)1−x. If we choose a prior to be proportional to powers of µ and (1 − µ), then the posterior distribution, which is proportional to the product of the prior and the likelihood function, will have the same functional form as the prior. This property is called conjugacy and we will see several examples of it later in this chapter. We therefore choose a prior, called the beta distribution, given by

Γ(a + b) Γ(a)Γ(b)

µa−1(1 − µ)b−1 (2.13)

Beta(µ|a,b) =

where Γ(x) is the gamma function deﬁned by (1.141), and the coefﬁcient in (2.13) Exercise 2.5 ensures that the beta distribution is normalized, so that

� 1

Beta(µ|a,b)dµ = 1. (2.14) Exercise 2.6 The mean and variance of the beta distribution are given by

0

a a + b

E[µ] =

(2.15)

ab (a + b)2(a + b + 1)

var[µ] =

. (2.16)

The parameters a and b are often called hyperparameters because they control the distribution of the parameter µ. Figure 2.2 shows plots of the beta distribution for various values of the hyperparameters.

The posterior distribution of µ is now obtained by multiplying the beta prior (2.13) by the binomial likelihood function (2.9) and normalizing. Keeping only the factors that depend on µ, we see that this posterior distribution has the form

p(µ|m,l,a,b) ∝ µm+a−1(1 − µ)l+b−1 (2.17)
