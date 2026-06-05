[Page 46]

Figure 1.14

![The image is a graph titled P(x) = N(x,N(x,0)), which represents the probability distribution of a variable named N(x,N(x,0)) over a set of values labeled x and x. The graph is a line graph with a horizontal axis labeled x and a vertical axis labeled N(x,N(x,0)). The graph has a single point labeled x=0 at the point x=0, indicating that the probability distribution is at its minimum value at x=0. The graph also has multiple points labeled x=1,...,x=N(x,N(x,0)) where x=1 and x=N(x,0) are the points where the graph intersects the horizontal axis. The graph has a horizontal axis labeled x and a vertical axis labeled N(x,N(](../images/imageFile19.png)

Illustration of the likelihood function for a Gaussian distribution, shown by the red curve. Here the black points denote a data set of values { x n } , and the likelihood function given by (1.53) corresponds to the product of the blue values. Maximizing the likelihood involves adjusting the mean and variance of the Gaussian so as to maximize this product.

p

(

x

)

2

N

|

(

x

µ,σ 2

)

n

x

x

n

# Section 1.2.5

Now suppose that we have a data set of observations x = ( x 1 ,...,x N ) T , representing N observations of the scalar variable x . Note that we are using the typeface x to distinguish this from a single observation of the vector-valued variable ( x 1 ,...,x D ) T , which we denote by x . We shall suppose that the observations are drawn independently from a Gaussian distribution whose mean µ and variance σ 2 are unknown, and we would like to determine these parameters from the data set. Data points that are drawn independently from the same distribution are said to be independent and identically distributed , which is often abbreviated to i.i.d. We have seen that the joint probability of two independent events is given by the product of the marginal probabilities for each event separately. Because our data set x is i.i.d., we can therefore write the probability of the data set, given µ and σ 2 , in the form

$$
p ( \mathbf x | \mu , \sigma ^ { 2 } ) = \prod _ { n = 1 } ^ { N } \mathcal { N } \left ( x _ { n } | \mu , \sigma ^ { 2 } \right ) . \\ \intertext { a f u n c t o r } \text {as } a \text { function of } \mathbf u \text { and } \sigma ^ { 2 } \text {  this is the likelibhood function for the Gauss-}
$$

When viewed as a function of µ and σ 2 , this is the likelihood function for the Gaussian and is interpreted diagrammatically in Figure 1.14.

One common criterion for determining the parameters in a probability distribution using an observed data set is to ﬁnd the parameter values that maximize the likelihood function. This might seem like a strange criterion because, from our foregoing discussion of probability theory, it would seem more natural to maximize the probability of the parameters given the data, not the probability of the data given the parameters. In fact, these two criteria are related, as we shall discuss in the context of curve ﬁtting.

For the moment, however, we shall determine values for the unknown parameters µ and σ 2 in the Gaussian by maximizing the likelihood function (1.53). In practice, it is more convenient to maximize the log of the likelihood function. Because the logarithm is a monotonically increasing function of its argument, maximization of the log of a function is equivalent to maximization of the function itself. Taking the log not only simpliﬁes the subsequent mathematical analysis, but it also helps numerically because the product of a large number of small probabilities can easily underﬂow the numerical precision of the computer, and this is resolved by computing instead the sum of the log probabilities. From (1.46) and (1.53), the log likelihood
