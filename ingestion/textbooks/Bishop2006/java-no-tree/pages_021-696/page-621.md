[Page 621]

![image 158](../../../../../images/imageFile158.png)

Exercises 601

- 12.14 (*) The number of independent parameters in the covariance matrix for the probabilistic PCA model with an M -dimensional latent space and a D-dimensional data space is given by (12.51). Verify that in the case of M = D - 1, the number of independent parameters is the same as in a general covariance Gaussian, whereas for

M =°itisthesameasforaGaussianwithanisotropiccovariance.

- 12.15 (**)IIiI!I Derive the M-step equations (12.56) and (12.57) for the probabilistic

PCA model by maximization of the expected complete-data log likelihood function given by (12.53).

- 12.16 (** *) In Figure 12.11, we showed an application of probabilistic PCA to a data set in which some of the data values were missing at random. Derive the EM algorithm for maximizing the likelihood function for the probabilistic PCA model in this situation. Note that the {zn}, as well as the missing data values that are components of

the vectors {xn }, are now latent variables. Show that in the special case in which all of the data values are observed, this reduces to the EM algorithm for probabilistic PCA derived in Section 12.2.2.

- 12.17 (**) IIiI!I Let W be a D x M matrix whose columns define a linear subspace

of dimensionality M embedded within a data space of dimensionality D, and let J1 be a D-dimensional vector. Given a data set {xn } where n = 1, ... ,N, we can approximate the data points using a linear mapping from a set of M -dimensional vectors {zn}, so that Xn is approximated by W Zn + J1. The associated sum-ofsquares reconstruction cost is given by

N

J = L Ilxn - J1- Wzn112.

n=l

(12.95)

First show that minimizing J with respect to J1leads to an analogous expression with X n and Zn replaced by zero-mean variables X n- x and Zn - Z, respectively, where x and Zdenote sample means. Then show that minimizing J with respect to Zn, where W is kept fixed, gives rise to the PCA Estep (12.58), and that minimizing J with respect to W, where {zn} is kept fixed, gives rise to the PCA M step (12.59).

- 12.18 (*) Derive an expression for the number of independent parameters in the factor analysis model described in Section 12.2.4.
- 12.19 (**) IIiI!I Show that the factor analysis model described in Section 12.2.4 is

invariant under rotations of the latent space coordinates.

- 12.20 (**) By considering second derivatives, show that the only stationary point of the log likelihood function for the factor analysis model discussed in Section 12.2.4 with respect to the parameter J1 is given by the sample mean defined by (12.1). Furthermore, show that this stationary point is a maximum.
- 12.21 (**) Derive the formulae (12.66) and (12.67) for the E step of the EM algorithm for factor analysis. Note that from the result of Exercise 12.20, the parameter J1 can be replaced by the sample mean x.
