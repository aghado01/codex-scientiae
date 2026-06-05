[Page 596]

Section 3.3.1

Exercise 12.11

Exercise 12.12

Section 2.3

The rotational invariance in latent space represents a form of statistical nonidentifiability, analogous to that encountered for mixture models in the case of discrete latent variables. Here there is a continuum of parameters all of which lead to the same predictive density, in contrast to the discrete nonidentifiability associated with component re-labelling in the mixture setting.

If we consider the case of M = D, so that there is no reduction of dimensionality, then U M = U and L M = L. Making use of the orthogonality properties UU T = I and RR T = I, we see that the covariance C of the marginal distribution for x becomes

$$
C = U ( L - \sigma ^ { 2 } I ) ^ { 1 / 2 } R R ^ { T } ( L - \sigma ^ { 2 } I ) ^ { 1 / 2 } U ^ { T } + \sigma ^ { 2 } I = U L U ^ { T } = S \quad ( 1 2 . 4 7 )
$$

and so we obtain the standard maximum likelihood solution for an unconstrained Gaussian distribution in which the covariance matrix is given by the sample covariance.

Conventional PCA is generally formulated as a projection of points from the Ddimensional data space onto an M -dimensional linear subspace. Probabilistic PCA, however, is most naturally expressed as a mapping from the latent space into the data space via (12.33). For applications such as visualization and data compression, we can reverse this mapping using Bayes' theorem. Any point x in data space can then be summarized by its posterior mean and covariance in latent space. From (12.42) the mean is given by

$$
\mathbb { E } [ z | x ] = M ^ { - 1 } W _ { M L } ^ { T } ( x - \bar { x } )
$$

where M is given by (12.41). This projects to a point in data space given by

$$
W \mathbb { E } [ z | x ] + \mu .
$$

Note that this takes the same form as the equations for regularized linear regression and is a consequence of maximizing the likelihood function for a linear Gaussian model. Similarly, the posterior covariance is given from (12.42) by 0-2M1 and is independent of x. 2

If we take the limit 0----t 0, then the posterior mean reduces to

$$
( W _ { M L } ^ { T } W _ { M L } ) ^ { - 1 } W _ { M L } ^ { T } ( x - \overline { x } )
$$

which represents an orthogonal projection of the data point onto the latent space, and so we recover the standard PCA model. The posterior covariance in this limit is zero, however, and the density becomes singular. For 02 > 0, the latent projection is shifted towards the origin, relative to the orthogonal projection.

Finally, we note that an important role for the probabilistic PCA model is in defining a multivariate Gaussian distribution in which the number of degrees of freedom, in other words the number of independent parameters, can be controlled whilst still allowing the model to capture the dominant correlations in the data. Recall that a general Gaussian distribution has D(D + 1)/2 independent parameters in its covariance matrix (plus another D parameters in its mean). Thus the number of parameters scales quadratically with D and can become excessive in spaces of high
