[Page 298]

to the posterior distribution (Hinton and van Camp, 1993) and also using a full-covariance Gaussian (Barber and Bishop, 1998a; Barber and Bishop, 1998b). The most complete treatment, however, has been based on the Laplace approximation (MacKay, 1992c; MacKay, 1992b) and forms the basis for the discussion given here. We will approximate the posterior distribution by a Gaussian, centred at a mode of the true posterior. Furthermore, we shall assume that the covariance of this Gaussian is small so that the network function is approximately linear with respect to the parameters over the region of parameter space for which the posterior probability is significantly nonzero. With these two approximations, we will obtain models that are analogous to the linear regression and classification models discussed in earlier chapters and so we can exploit the results obtained there. We can then make use of the evidence framework to provide point estimates for the hyperparameters and to compare alternative models (for example, networks having different numbers of hidden units). To start with, we shall discuss the regression case and then later consider the modifications needed for solving classification tasks.

### 5.7.1 Posterior parameter distribution

Consider the problem of predicting a single continuous target variable $t$ from a vector $\mathbf{x}$ of inputs (the extension to multiple targets is straightforward). We shall suppose that the conditional distribution $p(t|\mathbf{x})$ is Gaussian, with an $\mathbf{x}$-dependent mean given by the output of a neural network model $y(\mathbf{x},\mathbf{w})$, and with precision (inverse variance) $\beta$

$$
p(t|\mathbf{x},\mathbf{w},\beta) = \mathcal{N}(t|y(\mathbf{x},\mathbf{w}),\beta^{-1}).
\tag{5.161}
$$

Similarly, we shall choose a prior distribution over the weights $\mathbf{w}$ that is Gaussian of the form

$$
p(\mathbf{w}|\alpha) = \mathcal{N}(\mathbf{w}|\mathbf{0},\alpha^{-1}\mathbf{I}).
\tag{5.162}
$$

For an i.i.d. data set of $N$ observations $\mathbf{x}_1,\ldots,\mathbf{x}_N$, with a corresponding set of target values $\mathcal{D} = \{t_1,\ldots,t_N\}$, the likelihood function is given by

$$
p(\mathcal{D}|\mathbf{w},\beta) = \prod_{n=1}^N \mathcal{N}(t_n|y(\mathbf{x}_n,\mathbf{w}), \beta^{-1})
\tag{5.163}
$$

and so the resulting posterior distribution is then

$$
p(\mathbf{w}|\mathcal{D},\alpha,\beta) \propto p(\mathbf{w}|\alpha)p(\mathcal{D}|\mathbf{w},\beta)
\tag{5.164}
$$

which, as a consequence of the nonlinear dependence of $y(\mathbf{x},\mathbf{w})$ on $\mathbf{w}$, will be non-Gaussian.

We can find a Gaussian approximation to the posterior distribution by using the Laplace approximation. To do this, we must first find a (local) maximum of the posterior, and this must be done using iterative numerical optimization. As usual, it is convenient to maximize the logarithm of the posterior, which can be written in the
