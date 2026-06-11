[Page 453]

1

(a)

0.5

1

(b)

0.5

1

(c)

0.5

0

0

0

0 0.5 1

0 0.5 1

0 0.5 1

Figure 9.5 Example of 500 points drawn from the mixture of 3 Gaussians shown in Figure 2.23. (a) Samples from the joint distribution p(z)p(x|z) in which the three states of z, corresponding to the three components of the mixture, are depicted in red, green, and blue, and (b) the corresponding samples from the marginal distribution p(x), which is obtained by simply ignoring the values of z and just plotting the x values. The data set in (a) is said to be complete, whereas that in (b) is incomplete. (c) The same samples in which the colours represent the value of the responsibilities γ(znk) associated with data point xn, obtained by plotting the corresponding point using proportions of red, blue, and green ink given by γ(znk) for k = 1, 2, 3, respectively

matrix X in which the nth row is given by xTn. Similarly, the corresponding latent variables will be denoted by an N × K matrix Z with rows zTn. If we assume that the data points are drawn independently from the distribution, then we can express the Gaussian mixture model for this i.i.d. data set using the graphical representation shown in Figure 9.6. From (9.7) the log of the likelihood function is given by

ln� K

πkN(xn|µk,Σk)�. (9.14)

�N

�

lnp(X|π,µ,Σ) =

n=1

k=1

Before discussing how to maximize this function, it is worth emphasizing that there is a signiﬁcant problem associated with the maximum likelihood framework applied to Gaussian mixture models, due to the presence of singularities. For simplicity, consider a Gaussian mixture whose components have covariance matrices given by Σk = σk2I, where I is the unit matrix, although the conclusions will hold for general covariance matrices. Suppose that one of the components of the mixture model, let us say the jth component, has its mean µj exactly equal to one of the data

Figure 9.6 Graphical representation of a Gaussian mixture model for a set of N i.i.d. data points {xn}, with corresponding latent points {zn}, where n = 1, . . . , N.

π

zn

xn

µ Σ

N
