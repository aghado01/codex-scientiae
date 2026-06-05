[Page 603]

![image 140](../../../../../images/imageFile140.png)

###### 12.2. Probabilistic peA 583

Because this integration is intractable, we make use of the Laplace approximation. If we assume that the posterior distribution is sharply peaked, as will occur for sufficiently large data sets, then the re-estimation equations obtained by maximizing the marginal likelihood with respect to ai take the simple form

Section 4.4

Section 3.5.3

(12.62)

which follows from (3.98), noting that the dimensionality of Wi is D. These reestimations are interleaved with the EM algorithm updates for determining Wand a2• The E-step equations are again given by (12.54) and (12.55). Similarly, the Mstep equation for a2 is again given by (12.57). The only change is to the M-step equation for W, which is modified to give

(12.63)

where A = diag(ai)' The value of I-" is given by the sample mean, as before.

If we choose M = D - 1 then, if all ai values are finite, the model represents a full-covariance Gaussian, while if all the ai go to infinity the model is equivalent to an isotropic Gaussian, and so the model can encompass all pennissible values for the effective dimensionality of the principal subspace. It is also possible to consider smaller values of M, which will save on computational cost but which will limit the maximum dimensionality of the subspace. A comparison of the results of this algorithm with standard probabilistic PCA is shown in Figure 12.14.

Bayesian PCA provides an opportunity to illustrate the Gibbs sampling algorithm discussed in Section 11.3. Figure 12.15 shows an example of the samples from the hyperparameters In ai for a data set in D = 4 dimensions in which the dimensionality ofthe latent space is M = 3 but in which the data set is generated from a probabilistic PCA model having one direction of high variance, with the remaining directions comprising low variance noise. This result shows clearly the presence of three distinct modes in the posterior distribution. At each step of the iteration, one of the hyperparameters has a small value and the remaining two have large values, so that two of the three latent variables are suppressed. During the course of the Gibbs sampling, the solution makes sharp transitions between the three modes.

The model described here involves a prior only over the matrix W. A fully Bayesian treatment of PCA, including priors over 1-", a2, and n, and solved using variational methods, is described in Bishop (1999b). For a discussion of various Bayesian approaches to detennining the appropriate dimensionality for a PCA model, see Minka (2001c).

###### 12.2.4 Factor analysis

Factor analysis is a linear-Gaussian latent variable model that is closely related to probabilistic PCA. Its definition differs from that of probabilistic PCA only in that the conditional distribution of the observed variable x given the latent variable z is
