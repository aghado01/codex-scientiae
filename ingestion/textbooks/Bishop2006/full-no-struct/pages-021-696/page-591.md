[Page 591]

Section 12.2.2

Section 12.2.3

Section 8.1.4

Section 8.2.2

• We can derive an EM algorithm for PCA that is computationally efficient in situations where only a few leading eigenvectors are required and that avoids having to evaluate the data covariance matrix as an intermediate step.

- • The combination of a probabilistic model and EM allows us to deal with missing values in the data set.
- • Mixtures of probabilistic PCA models can be formulated in a principled way and trained using the EM algorithm.
- • Probabilistic PCA forms the basis for a Bayesian treatment of PCA in which the dimensionality of the principal subspace can be found automatically from the data.

- • The existence of a likelihood function allows direct comparison with other probabilistic density models. By contrast, conventional PCA will assign a low reconstruction cost to data points that are close to the principal subspace even if they lie arbitrarily far from the training data.
- • Probabilistic PCA can be used to model class-conditional densities and hence be applied to classification problems.
- • The probabilistic PCA model can be run generatively to provide samples from the distribution.

This formulation of PCA as a probabilistic model was proposed independently by Tipping and Bishop (1997, 1999b) and by Roweis (1998). As we shall see later, it is closely related to factor analysis (Basilevsky, 1994).

Probabilistic PCA is a simple example of the linear-Gaussian framework, in which all of the marginal and conditional distributions are Gaussian. We can formulate probabilistic PCA by first introducing an explicit latent variable z corresponding to the principal-component subspace. Next we define a Gaussian prior distribution p( z) over the latent variable, together with a Gaussian conditional distribution p( xl z) for the observed variable x conditioned on the value of the latent variable. Specifically, the prior distribution over z is given by a zero-mean unit-covariance Gaussian

$$
p ( z ) = \mathcal { N } ( z | 0 , I ) .
$$

Similarly, the conditional distribution of the observed variable x, conditioned on the value of the latent variable z, is again Gaussian, of the form

$$
p ( x | z ) = \mathcal { N } ( x | W z + \mu , \sigma ^ { 2 } I )
$$

in which the mean of x is a general linear function of z governed by the D x M matrix Wand the D-dimensional vector J-L. Note that this factorizes with respect to the elements of x, in other words this is an example of the naive Bayes model. As we shall see shortly, the columns of W span a linear subspace within the data space that corresponds to the principal subspace. The other parameter in this model is the scalar a 2 governing the variance of the conditional distribution. Note that there is no
