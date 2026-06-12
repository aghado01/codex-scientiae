[Page 117]

Figure 2.11

In the case of a Gaussian distribution, with θ corresponding to the mean µ , the regression function illustrated in Figure 2.10 takes the form of a straight line, as shown in red. In this case, the random variable z corresponds to the derivative of the log likelihood function and is given by ( x − µ ML ) /σ 2 , and its expectation that deﬁnes the regression function is a straight line given by ( µ − µ ML ) /σ 2 . The root of the regression function corresponds to the maximum likelihood estimator µ ML .

![The image depicts a diagram of a right triangle. The diagram consists of two parallel lines, labeled as ( \triangle A ) and ( \triangle B ). The line ( \triangle A ) is drawn with a horizontal line, while the line ( \triangle B ) is drawn with a vertical line. The angle between the two lines is labeled as ( \angle A ). ### Detailed Description: #### **Line Segments and Angles:** - **Line ( \triangle A ):** - The line ( \triangle A ) is a right triangle, meaning it has a right angle at the bottom. - The length of the line ( \triangle A ) is ( 1 ) unit. - **Line ( \triangle B ):** - The line ( \triangle B ) is a right triangle, meaning](../images/imageFile52.png)

|

p

(

z

µ

)

µ

ML

µ

As a speciﬁc example, we consider once again the sequential estimation of the mean of a Gaussian distribution, in which case the parameter θ ( N ) is the estimate µ ( N ) ML of the mean of the Gaussian, and the random variable z is given by

$$
z = \frac { \partial } { \partial \mu _ { M L } } \ln p ( x | \mu _ { M L } , \sigma ^ { 2 } ) = \frac { 1 } { \sigma ^ { 2 } } ( x - \mu _ { M L } ) .
$$

Thus the distribution of z is Gaussian with mean µ − µ ML , as illustrated in Figure 2.11. Substituting (2.136) into (2.135), we obtain the univariate form of (2.126), provided we choose the coefﬁcients a N to have the form a N = σ 2 /N . Note that although we have focussed on the case of a single variable, the same technique, together with the same restrictions (2.130)–(2.132) on the coefﬁcients a N , apply equally to the multivariate case (Blum, 1965).

# 2.3.6 Bayesian inference for the Gaussian

The maximum likelihood framework gave point estimates for the parameters µ and Σ . Now we develop a Bayesian treatment by introducing prior distributions over these parameters. Let us begin with a simple example in which we consider a single Gaussian random variable x . We shall suppose that the variance σ 2 is known, and we consider the task of inferring the mean µ given a set of N observations X = { x 1 ,...,x N } . The likelihood function, that is the probability of the observed data given µ , viewed as a function of µ , is given by

$$
data \text { given } \mu , \text { viewed as a function of } \mu , \text { is given by} \\ p ( X | \mu ) = \prod _ { n = 1 } ^ { N } p ( x _ { n } | \mu ) = \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { N / 2 } } \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right \} . \quad ( 2 . 1 3 ) \\ \text {Again we emphasize that the likelihood function } p ( X | \mu ) \text { is not a probability distrib-}
$$

Again we emphasize that the likelihood function p ( X | µ ) is not a probability distribution over µ and is not normalized.

We see that the likelihood function takes the form of the exponential of a quadratic form in µ . Thus if we choose a prior p ( µ ) given by a Gaussian, it will be a conjugate distribution for this likelihood function because the corresponding posterior will be a product of two exponentials of quadratic functions of µ and hence will also be Gaussian. We therefore take our prior distribution to be and the posterior distribution is given by
