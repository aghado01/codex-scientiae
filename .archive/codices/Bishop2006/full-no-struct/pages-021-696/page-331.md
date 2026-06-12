[Page 331]

Section 3.5

sian process regression have also been considered, for purposes such as modelling the distribution over low-dimensional manifolds for unsupervised learning (Bishop et al. , 1998a) and the solution of stochastic differential equations (Graepel, 2003).

# 6.4.3 Learning the hyperparameters

The predictions of a Gaussian process model will depend, in part, on the choice of covariance function. In practice, rather than ﬁxing the covariance function, we may prefer to use a parametric family of functions and then infer the parameter values from the data. These parameters govern such things as the length scale of the correlations and the precision of the noise and correspond to the hyperparameters in a standard parametric model.

Techniques for learning the hyperparameters are based on the evaluation of the likelihood function p ( t | θ ) where θ denotes the hyperparameters of the Gaussian process model. The simplest approach is to make a point estimate of θ by maximizing the log likelihood function. Because θ represents a set of hyperparameters for the regression problem, this can be viewed as analogous to the type 2 maximum likelihood procedure for linear regression models. Maximization of the log likelihood can be done using efﬁcient gradient-based optimization algorithms such as conjugate gradients (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008).

The log likelihood function for a Gaussian process regression model is easily evaluated using the standard form for a multivariate Gaussian distribution, giving

$$
\ln p ( \mathbf t | \theta ) = - \frac { 1 } { 2 } \ln | C _ { N } | - \frac { 1 } { 2 } \mathbf t ^ { T } C _ { N } ^ { - 1 } \mathbf t - \frac { N } { 2 } \ln ( 2 \pi ) .
$$

For nonlinear optimization, we also need the gradient of the log likelihood function with respect to the parameter vector θ . We shall assume that evaluation of the derivatives of C N is straightforward, as would be the case for the covariance functions considered in this chapter. Making use of the result (C.21) for the derivative of C − 1 N , together with the result (C.22) for the derivative of ln | C N | , we obtain

$$
\mathcal { O } _ { N } \, , & \log \frac { \partial } { \partial N } \ln \frac { \partial } { \partial N } ( \partial _ { N } ) \, + \frac { 1 } { 2 } T r \left ( C _ { N } ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { i } } \right ) + \frac { 1 } { 2 } t ^ { T } C _ { N } ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { i } } C _ { N } ^ { - 1 } \, . \\ & \frac { \partial } { \partial \theta _ { i } } \ln p ( t | \theta ) = - \frac { 1 } { 2 } T r \left ( C _ { N } ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { i } } \right ) + \frac { 1 } { 2 } t ^ { T } C _ { N } ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { i } } C _ { N } ^ { - 1 } \, . \\ \\ D _ { N } & \log ( 1 + \theta ) \cdot \frac { 1 } { 2 } t \cdot \frac { 1 } { 2 } \log ( 1 - 1 ) .
$$

Because ln p ( t | θ ) will in general be a nonconvex function, it can have multiple maxima.

It is straightforward to introduce a prior over θ and to maximize the log posterior using gradient-based methods. In a fully Bayesian treatment, we need to evaluate marginals over θ weighted by the product of the prior p ( θ ) and the likelihood function p ( t | θ ) . In general, however, exact marginalization will be intractable, and we must resort to approximations.
