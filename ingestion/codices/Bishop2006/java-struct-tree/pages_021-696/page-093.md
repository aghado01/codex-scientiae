[Page 93]

2

prior

1

2

likelihood function

1

2

posterior

1

0

0 0.5 1

µ

0

0 0.5 1

µ

0

0 0.5 1

µ

Figure 2.3 Illustration of one step of sequential Bayesian inference. The prior is given by a beta distribution with parameters a = 2, b = 2, and the likelihood function, given by (2.9) with N = m = 1, corresponds to a single observation of x = 1, so that the posterior is given by a beta distribution with parameters a = 3, b = 2.

distribution by multiplying by the likelihood function for the new observation and then normalizing to obtain the new, revised posterior distribution. At each stage, the posterior is a beta distribution with some total number of (prior and actual) observed values for x = 1 and x = 0 given by the parameters a and b. Incorporation of an additional observation of x = 1 simply corresponds to incrementing the value of a by 1, whereas for an observation of x = 0 we increment b by 1. Figure 2.3 illustrates one step in this process.

We see that this sequential approach to learning arises naturally when we adopt a Bayesian viewpoint. It is independent of the choice of prior and of the likelihood function and depends only on the assumption of i.i.d. data. Sequential methods make use of observations one at a time, or in small batches, and then discard them before the next observations are used. They can be used, for example, in real-time learning scenarios where a steady stream of data is arriving, and predictions must be made before all of the data is seen. Because they do not require the whole data set to be stored or loaded into memory, sequential methods are also useful for large data sets.

Section 2.3.5 Maximum likelihood methods can also be cast into a sequential framework.

If our goal is to predict, as best we can, the outcome of the next trial, then we must evaluate the predictive distribution of x, given the observed data set D. From the sum and product rules of probability, this takes the form

p(x = 1|D) = � 1

p(x = 1|µ)p(µ|D)dµ = � 1

µp(µ|D)dµ = E[µ|D]. (2.19)

0

0

Using the result (2.18) for the posterior distribution p(µ|D), together with the result (2.15) for the mean of the beta distribution, we obtain

m + a m + a + l + b

p(x = 1|D) =

(2.20)

which has a simple interpretation as the total fraction of observations (both real observations and ﬁctitious prior observations) that correspond to x = 1. Note that in the limit of an inﬁnitely large data set m,l → ∞ the result (2.20) reduces to the maximum likelihood result (2.8). As we shall see, it is a very general property that the Bayesian and maximum likelihood results will agree in the limit of an inﬁnitely
