[Page 595]

![image 132](../../../../../images/imageFile132.png)

12.2. Probabilistic peA 575

Again, we shall assume that the eigenvectors have been arranged in order of decreasing values of the corresponding eigenvalues, so that the M principal eigenvectors are Ul,"" UM. In this case, the columns of W define the principal subspace of standard PCA. The corresponding maximum likelihood solution for (J'2 is then given by

1 D

(J'~L = D-M L Ai

(12.46)

i=M+l

so that (J'~L is the average variance associated with the discarded dimensions.

Because R is orthogonal, it can be interpreted as a rotation matrix in the M x M latent space. If we substitute the solution for W into the expression for C, and make use of the orthogonality property RRT = I, we see that C is independent of R. This simply says that the predictive density is unchanged by rotations in the latent space as discussed earlier. For the particular case of R = I, we see that the columns of W are the principal component eigenvectors scaled by the variance parameters Ai - (J'2. The interpretation of these scaling factors is clear once we recognize that for a convolution of independent Gaussian distributions (in this case the latent space distribution and the noise model) the variances are additive. Thus the variance Ai in the direction of an eigenvector Ui is composed of the sum of a contribution Ai -

(J'2 from the projection of the unit-variance latent space distribution into data space through the corresponding column of W, plus an isotropic contribution of variance (J'2 which is added in all directions by the noise model.

It is worth taking a moment to study the form of the covariance matrix given by (12.36). Consider the variance of the predictive distribution along some direction specified by the unit vector v, where vTv = 1, which is given by vTCv. First suppose that v is orthogonal to the principal subspace, in other words it is given by some linear combination of the discarded eigenvectors. Then vTV = 0 and hence vTCv = (J'2. Thus the model predicts a noise variance orthogonal to the principal subspace, which, from (12.46), is just the average of the discarded eigenvalues. Now suppose that v = Ui where Ui is one of the retained eigenvectors defining the principal subspace. Then vTCv = (Ai - (J'2) + (J'2 = Ai. In other words, this model correctly captures the variance of the data along the principal axes, and approximates the variance in all remaining directions with a single average value (J'2.

One way to construct the maximum likelihood density model would simply be to find the eigenvectors and eigenvalues of the data covariance matrix and then to evaluate Wand (J'2 using the results given above. In this case, we would choose R = I for convenience. However, if the maximum likelihood solution is found by numerical optimization of the likelihood function, for instance using an algorithm such as conjugate gradients (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008) or through the EM algorithm, then the resulting value of R is essentially arbitrary. This implies that the columns of W need not be orthogonal. If an orthogonal basis is required, the matrix W can be post-processed appropriately (Golub and Van Loan, 1996). Alternatively, the EM algorithm can be modified in such a way as to yield orthonormal principal directions, sorted in descending order of the corresponding eigenvalues, directly (Ahn and Oh, 2003).

Section 12.2.2
