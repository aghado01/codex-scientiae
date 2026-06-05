[Page 510]

Figure 10.9 Plot of the lower bound L versus the order M of the polynomial, for a polynomial model, in which a set of 10 data points is generated from a polynomial with M = 3 sampled over the interval (−5, 5) with additive Gaussian noise of variance 0.09. The value of the bound gives the log probability of the model, and we see that the value of the bound peaks at M = 3, corresponding to the true model from which the data set was generated.

1 3 5 7 9

10.4. Exponential Family Distributions

In Chapter 2, we discussed the important role played by the exponential family of distributions and their conjugate priors. For many of the models discussed in this book, the complete-data likelihood is drawn from the exponential family. However, in general this will not be the case for the marginal likelihood function for the observed data. For example, in a mixture of Gaussians, the joint distribution of observations xn and corresponding hidden variables zn is a member of the exponential family, whereas the marginal distribution of xn is a mixture of Gaussians and hence is not.

Up to now we have grouped the variables in the model into observed variables and hidden variables. We now make a further distinction between latent variables, denoted Z, and parameters, denoted θ, where parameters are intensive (ﬁxed in number independent of the size of the data set), whereas latent variables are extensive (scale in number with the size of the data set). For example, in a Gaussian mixture model, the indicator variables zkn (which specify which component k is responsible for generating data point xn) represent the latent variables, whereas the means µk, precisions Λk and mixing proportions πk represent the parameters.

Consider the case of independent identically distributed data. We denote the data values by X = {xn}, where n = 1,...N, with corresponding latent variables Z = {zn}. Now suppose that the joint distribution of observed and latent variables is a member of the exponential family, parameterized by natural parameters η so that

�N

�

�

h(xn,zn)g(η)exp

ηTu(xn,zn)

p(X,Z|η) =

. (10.113)

n=1

We shall also use a conjugate prior for η, which can be written as p(η|ν0,v0) = f(ν0,χ0)g(η)ν

�

�

exp

νoηTχ0

. (10.114)

0

Recall that the conjugate prior distribution can be interpreted as a prior number ν0 of observations all having the value χ0 for the u vector. Now consider a variational
