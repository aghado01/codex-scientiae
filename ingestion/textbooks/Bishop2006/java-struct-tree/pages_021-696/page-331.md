[Page 331]

sian process regression have also been considered, for purposes such as modelling the distribution over low-dimensional manifolds for unsupervised learning (Bishop et al., 1998a) and the solution of stochastic differential equations (Graepel, 2003).

6.4.3 Learning the hyperparameters

The predictions of a Gaussian process model will depend, in part, on the choice of covariance function. In practice, rather than ﬁxing the covariance function, we may prefer to use a parametric family of functions and then infer the parameter values from the data. These parameters govern such things as the length scale of the correlations and the precision of the noise and correspond to the hyperparameters in a standard parametric model.

Techniques for learning the hyperparameters are based on the evaluation of the likelihood function p(t|θ) where θ denotes the hyperparameters of the Gaussian process model. The simplest approach is to make a point estimate of θ by maximizing the log likelihood function. Because θ represents a set of hyperparameters for the regression problem, this can be viewed as analogous to the type 2 maximum like-

Section 3.5 lihood procedure for linear regression models. Maximization of the log likelihood can be done using efﬁcient gradient-based optimization algorithms such as conjugate gradients (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008).

The log likelihood function for a Gaussian process regression model is easily evaluated using the standard form for a multivariate Gaussian distribution, giving

1 2

lnp(t|θ) = −

ln|CN| −

1 2

tTC−1

N t −

N 2

ln(2π). (6.69)

For nonlinear optimization, we also need the gradient of the log likelihood function with respect to the parameter vector θ. We shall assume that evaluation of the derivatives of CN is straightforward, as would be the case for the covariance functions considered in this chapter. Making use of the result (C.21) for the derivative of C−1

N , together with the result (C.22) for the derivative of ln|CN|, we obtain

Tr�C−1

� +

1 2

1 2

∂CN ∂θi

∂CN ∂θi

∂ ∂θi

tTC−1

C−1

lnp(t|θ) = −

N t. (6.70)

N

N

Because lnp(t|θ) will in general be a nonconvex function, it can have multiple maxima.

It is straightforward to introduce a prior over θ and to maximize the log posterior using gradient-based methods. In a fully Bayesian treatment, we need to evaluate marginals over θ weighted by the product of the prior p(θ) and the likelihood function p(t|θ). In general, however, exact marginalization will be intractable, and we must resort to approximations.

The Gaussian process regression model gives a predictive distribution whose mean and variance are functions of the input vector x. However, we have assumed that the contribution to the predictive variance arising from the additive noise, governed by the parameter β, is a constant. For some problems, known as heteroscedastic, the noise variance itself will also depend on x. To model this, we can extend the
