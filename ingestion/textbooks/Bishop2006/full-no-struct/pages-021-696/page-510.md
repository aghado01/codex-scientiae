[Page 510]

Figure 10.9

Plot of the lower bound L versus the order M of the polynomial, for a polynomial model, in which a set of 10 data points is generated from a polynomial with M = 3 sampled over the interval ( − 5 , 5) with additive Gaussian noise of variance 0.09. The value of the bound gives the log probability of the model, and we see that the value of the bound peaks at M = 3 , corresponding to the true model from which the data set was generated.

![A line graph with a linear scale of range 0 to 9 on the y-axis, labeled Number of people. The x-axis shows the number of people in the population, ranging from 0 to 9. The graph shows a general upward trend, with the number of people increasing from 0 to 9.](../images/imageFile241.png)

1

3

5

7

9

# 10.4. Exponential Family Distributions

In Chapter 2, we discussed the important role played by the exponential family of distributions and their conjugate priors. For many of the models discussed in this book, the complete-data likelihood is drawn from the exponential family. However, in general this will not be the case for the marginal likelihood function for the observed data. For example, in a mixture of Gaussians, the joint distribution of observations x n and corresponding hidden variables z n is a member of the exponential family, whereas the marginal distribution of x n is a mixture of Gaussians and hence is not.

Up to now we have grouped the variables in the model into observed variables and hidden variables. We now make a further distinction between latent variables, denoted Z , and parameters, denoted θ , where parameters are intensive (ﬁxed in number independent of the size of the data set), whereas latent variables are extensive (scale in number with the size of the data set). For example, in a Gaussian mixture model, the indicator variables z kn (which specify which component k is responsible for generating data point x n ) represent the latent variables, whereas the means µ k , precisions Λ k and mixing proportions π k represent the parameters.

Consider the case of independent identically distributed data. We denote the data values by X = { x n } , where n = 1 ,...N , with corresponding latent variables Z = { z n } . Now suppose that the joint distribution of observed and latent variables is a member of the exponential family, parameterized by natural parameters η so that

$$
p ( X , Z | \eta ) = \prod _ { n = 1 } ^ { N } h ( x _ { n } , z _ { n } ) g ( \eta ) \exp \left \{ \eta ^ { T } u ( x _ { n } , z _ { n } ) \right \} . \\ \text {We shall also use a conjugate prior for } \eta , \text { which can be written as}
$$

We shall also use a conjugate prior for η , which can be written as

$$
\text {all also use a conjugate prior for } \eta , \text { which can be written as} \\ p ( \eta | \nu _ { 0 } , \nu _ { 0 } ) = f ( \nu _ { 0 } , \chi _ { 0 } ) g ( \eta ) ^ { \nu _ { 0 } } \exp \left \{ \nu _ { 0 } \eta ^ { T } \chi _ { 0 } \right \} . \\ \text { that the conjugate prior distribution can be interpreted as a prior number } \nu _ { 0 } \\ \text {ations all having the value } \chi _ { 0 } \text { for the } \text {u vector.  Now consider a variational}
$$

Recall that the conjugate prior distribution can be interpreted as a prior number ν 0 of observations all having the value χ 0 for the u vector. Now consider a variational
