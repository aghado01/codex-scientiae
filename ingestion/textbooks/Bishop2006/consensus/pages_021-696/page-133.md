[Page 133]

where X = {x1,...,xN}. We immediately see that the situation is now much more complex than with a single Gaussian, due to the presence of the summation over k inside the logarithm. As a result, the maximum likelihood solution for the parameters no longer has a closed-form analytical solution. One approach to maximizing the likelihood function is to use iterative numerical optimization techniques (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008). Alternatively we can employ a powerful framework called expectation maximization, which will be discussed at length in Chapter 9.

###### 2.4. The Exponential Family

The probability distributions that we have studied so far in this chapter (with the exception of the Gaussian mixture) are speciﬁc examples of a broad class of distributions called the exponential family (Duda and Hart, 1973; Bernardo and Smith, 1994). Members of the exponential family have many important properties in common, and it is illuminating to discuss these properties in some generality.

The exponential family of distributions over x, given parameters η, is deﬁned to be the set of distributions of the form

p(x|η) = h(x)g(η)exp ηTu(x) (2.194)

where x may be scalar or vector, and may be discrete or continuous. Here η are called the natural parameters of the distribution, and u(x) is some function of x. The function g(η) can be interpreted as the coefﬁcient that ensures that the distribution is normalized and therefore satisﬁes

###### g(η) h(x)exp ηTu(x) dx = 1 (2.195)

where the integration is replaced by summation if x is a discrete variable.

We begin by taking some examples of the distributions introduced earlier in the chapter and showing that they are indeed members of the exponential family. Consider ﬁrst the Bernoulli distribution

p(x|µ) = Bern(x|µ) = µx(1 − µ)1−x. (2.196) Expressing the right-hand side as the exponential of the logarithm, we have

p(x|µ) = exp{xlnµ + (1 − x)ln(1 − µ)}

µ 1 − µ

= (1 − µ)exp ln

x . (2.197)

Comparison with (2.194) allows us to identify

η = ln

µ 1 − µ

(2.198)
