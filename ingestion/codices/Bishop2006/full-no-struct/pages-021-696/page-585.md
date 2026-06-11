[Page 585]

Appendix A

minimize J = UISU2' subject to the normalization constraint uI U2 = 1. Using a Lagrange multiplier A2 to enforce the constraint, we consider the minimization of

$$
\widetilde { J } = \mathbf u _ { 2 } ^ { \top } \mathbf S u _ { 2 } + \lambda _ { 2 } \left ( 1 - \mathbf u _ { 2 } ^ { \top } \mathbf u _ { 2 } \right ) .
$$

Setting the derivative with respect to U2 to zero, we obtain SU2 = A2U2 so that U2 is an eigenvector of S with eigenvalue A2. Thus any eigenvector will define a stationary point of the distortion measure. To find the value of J at the minimum, we back-substitute the solution for U2 into the distortion measure to give J = A2. We therefore obtain the minimum value of J by choosing U2 to be the eigenvector corresponding to the smaller of the two eigenvalues. Thus we should choose the principal subspace to be aligned with the eigenvector having the larger eigenvalue. This result accords with our intuition that, in order to minimize the average squared projection distance, we should choose the principal component subspace to pass through the mean of the data points and to be aligned with the directions of maximum variance. For the case when the eigenvalues are equal, any choice of principal direction will give rise to the same value of J.

The general solution to the minimization of J for arbitrary D and arbitrary M < D is obtained by choosing the {Ui} to be eigenvectors of the covariance matrix given by

$$
\S u _ { i } = \lambda _ { i } \mathbf u _ { i }
$$

where i = 1, ... ,D, and as usual the eigenvectors {Ui} are chosen to be orthonormal. The corresponding value of the distortion measure is then given by

$$
J = \sum _ { i = M + 1 } ^ { D } \lambda _ { i }
$$

which is simply the sum of the eigenvalues of those eigenvectors that are orthogonal to the principal subspace. We therefore obtain the minimum value of J by selecting these eigenvectors to be those having the D M smallest eigenvalues, and hence the eigenvectors defining the principal subspace are those corresponding to the M largest eigenvalues.

Although we have considered M < D, the PCA analysis still holds if M = D, in which case there is no dimensionality reduction but simply a rotation of the coordinate axes to align with principal components.

Finally, it is worth noting that there exists a closely related linear dimensionality reduction technique called canonical correlation analysis, or CCA (Hotelling, 1936; Bach and Jordan, 2002). Whereas PCA works with a single random variable, CCA considers two (or more) variables and tries to find a corresponding pair of linear subspaces that have high cross-correlation, so that each component within one of the subspaces is correlated with a single component from the other subspace. Its solution can be expressed in terms of a generalized eigenvector problem.

# 12.1.3 Applications of peA

We can illustrate the use of PCA for data compression by considering the offline digits data set. Because each eigenvector of the covariance matrix is a vector
