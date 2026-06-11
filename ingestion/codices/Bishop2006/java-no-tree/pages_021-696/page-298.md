[Page 298]

to the posterior distribution (Hinton and van Camp, 1993) and also using a fullcovariance Gaussian (Barber and Bishop, 1998a; Barber and Bishop, 1998b). The most complete treatment, however, has been based on the Laplace approximation (MacKay, 1992c; MacKay, 1992b) and forms the basis for the discussion given here. We will approximate the posterior distribution by a Gaussian, centred at a mode of the true posterior. Furthermore, we shall assume that the covariance of this Gaussian is small so that the network function is approximately linear with respect to the parameters over the region of parameter space for which the posterior probability is signiﬁcantly nonzero. With these two approximations, we will obtain models that are analogous to the linear regression and classiﬁcation models discussed in earlier chapters and so we can exploit the results obtained there. We can then make use of the evidence framework to provide point estimates for the hyperparameters and to compare alternative models (for example, networks having different numbers of hidden units). To start with, we shall discuss the regression case and then later consider the modiﬁcations needed for solving classiﬁcation tasks.

###### 5.7.1 Posterior parameter distribution

Consider the problem of predicting a single continuous target variable t from a vector x of inputs (the extension to multiple targets is straightforward). We shall suppose that the conditional distribution p(t|x) is Gaussian, with an x-dependent mean given by the output of a neural network model y(x,w), and with precision (inverse variance) β

p(t|x,w,β) = N(t|y(x,w),β−1). (5.161)

Similarly, we shall choose a prior distribution over the weights w that is Gaussian of the form

p(w|α) = N(w|0,α−1I). (5.162)

For an i.i.d. data set of N observations x1,...,xN, with a corresponding set of target values D = {t1,...,tN}, the likelihood function is given by

N

N(tn|y(xn,w),β−1) (5.163)

p(D|w,β) =

n=1

and so the resulting posterior distribution is then

p(w|D,α,β) ∝ p(w|α)p(D|w,β). (5.164)

which, as a consequence of the nonlinear dependence of y(x,w) on w, will be nonGaussian.

We can ﬁnd a Gaussian approximation to the posterior distribution by using the Laplace approximation. To do this, we must ﬁrst ﬁnd a (local) maximum of the posterior, and this must be done using iterative numerical optimization. As usual, it is convenient to maximize the logarithm of the posterior, which can be written in the
