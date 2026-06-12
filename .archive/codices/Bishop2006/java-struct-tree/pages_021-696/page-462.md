[Page 462]

Figure 9.9 This shows the same graph as in Figure 9.6 except that we now suppose that the discrete variables zn are observed, as well as the data variables xn.

π

zn

xn

µ Σ

N

Now consider the problem of maximizing the likelihood for the complete data set {X,Z}. From (9.10) and (9.11), this likelihood function takes the form

�N

�K

πz

k N(xn|µk,Σk)znk (9.35)

p(X,Z|µ,Σ,π) =

nk

n=1

k=1

where znk denotes the kth component of zn. Taking the logarithm, we obtain

�N

�K

lnp(X,Z|µ,Σ,π) =

znk {lnπk + lnN(xn|µk,Σk)}. (9.36)

n=1

k=1

Comparison with the log likelihood function (9.14) for the incomplete data shows that the summation over k and the logarithm have been interchanged. The logarithm now acts directly on the Gaussian distribution, which itself is a member of the exponential family. Not surprisingly, this leads to a much simpler solution to the maximum likelihood problem, as we now show. Consider ﬁrst the maximization with respect to the means and covariances. Because zn is a K-dimensional vector with all elements equal to 0 except for a single element having the value 1, the complete-data log likelihood function is simply a sum of K independent contributions, one for each mixture component. Thus the maximization with respect to a mean or a covariance is exactly as for a single Gaussian, except that it involves only the subset of data points that are ‘assigned’ to that component. For the maximization with respect to the mixing coefﬁcients, we note that these are coupled for different values of k by virtue of the summation constraint (9.9). Again, this can be enforced using a Lagrange multiplier as before, and leads to the result

�N

1 N

πk =

znk (9.37)

n=1

so that the mixing coefﬁcients are equal to the fractions of data points assigned to the corresponding components.

Thus we see that the complete-data log likelihood function can be maximized trivially in closed form. In practice, however, we do not have values for the latent variables so, as discussed earlier, we consider the expectation, with respect to the posterior distribution of the latent variables, of the complete-data log likelihood.
