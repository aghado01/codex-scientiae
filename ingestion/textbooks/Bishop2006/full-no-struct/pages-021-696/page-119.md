[Page 119]

Figure 2.12

Illustration of Bayesian inference for the mean µ of a Gaussian distribution, in which the variance is assumed to be known. The curves show the prior distribution over µ (the curve labelled N = 0 ), which in this case is itself Gaussian, along with the posterior distribution given by (2.140) for increasing numbers N of data points. The data points are generated from a Gaussian of mean 0 . 8 and variance 0 . 1 , and the prior is chosen to have mean 0 . In both the prior and the likelihood function, the variance is set to the true value.

![The image presents a graph with two lines, labeled as N=0 and N=1. The x-axis is labeled as N=0 and the y-axis is labeled as N=1. The graph shows two peaks and two troughs. The peaks are located at the points 0 and 1, and the troughs are located at the points 0 and 1. ### Graph Description: - **X-axis (N=0):** - The x-axis is labeled as N=0 and has a minimum value of 0. - The y-axis is labeled as N=1 and has a minimum value of 1. - **Y-axis (N=1):** - The y-axis is labeled as N=1 and has a minimum value of 1. - The x-axis is labeled as N=0 and has a minimum value of](../images/imageFile53.png)

5

N

= 10

N

= 2

N

= 1

N

= 0

0

-1

0

1

Exercise 2.40

Section 2.3.5

We illustrate our analysis of Bayesian inference for the mean of a Gaussian distribution in Figure 2.12. The generalization of this result to the case of a D dimensional Gaussian random variable x with known covariance and unknown mean is straightforward.

We have already seen how the maximum likelihood expression for the mean of a Gaussian can be re-cast as a sequential update formula in which the mean after observing N data points was expressed in terms of the mean after observing N − 1 data points together with the contribution from data point x N . In fact, the Bayesian paradigm leads very naturally to a sequential view of the inference problem. To see this in the context of the inference of the mean of a Gaussian, we write the posterior distribution with the contribution from the ﬁnal data point x N separated out so that

$$
\text {in with the combination from the main data point} \, x _ { N } \text { separated out so that} \\ p ( \mu | D ) \in \left [ p ( \mu ) \prod _ { n = 1 } ^ { N - 1 } p ( x _ { n } | \mu ) \right ] p ( x _ { N } | \mu ) . \\ \intertext { i n s u g r a b k e s } \text {in square brackets is } \text {up to a normalization coefficient} \text { just the posterior}
$$

The term in square brackets is (up to a normalization coefﬁcient) just the posterior distribution after observing N − 1 data points. We see that this can be viewed as a prior distribution, which is combined using Bayes’ theorem with the likelihood function associated with data point x N to arrive at the posterior distribution after observing N data points. This sequential view of Bayesian inference is very general and applies to any problem in which the observed data are assumed to be independent and identically distributed.

So far, we have assumed that the variance of the Gaussian distribution over the data is known and our goal is to infer the mean. Now let us suppose that the mean is known and we wish to infer the variance. Again, our calculations will be greatly simpliﬁed if we choose a conjugate form for the prior distribution. It turns out to be most convenient to work with the precision λ ≡ 1 /σ 2 . The likelihood function for λ takes the form

$$
takes the form \\ p ( X | \lambda ) = \prod _ { n = 1 } ^ { N } \mathcal { N } ( x _ { n } | \mu , \lambda ^ { - 1 } ) \, \infty \, \lambda ^ { N / 2 } \exp \left \{ - \frac { \lambda } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right \} .
$$
