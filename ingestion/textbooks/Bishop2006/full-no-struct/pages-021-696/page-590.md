[Page 590]

dimensional centred data matrix, whose nth row is given by (x n X)T. The covariance matrix (12.3) can then be written as S = N1 XTX, and the corresponding eigenvector equation becomes

$$
\frac { 1 } { N } X ^ { T } X u _ { i } = \lambda _ { i } u _ { i } .
$$

Now pre-multiply both sides by X to give

$$
\frac { 1 } { N } X X ^ { T } ( X u _ { i } ) = \lambda _ { i } ( X u _ { i } ) .
$$

If we now define Vi = XUi, we obtain

$$
\frac { 1 } { N } X X ^ { T } v _ { i } = \lambda _ { i } v _ { i }
$$

which is an eigenvector equation for the N x N matrix N1 XX T . We see that this has the same N -1 eigenvalues as the original covariance matrix (which itself has an additional D N + 1 eigenvalues of value zero). Thus we can solve the eigenvector problem in spaces of lower dimensionality with computational cost O(N 3 ) instead of O(D 3 ). In order to determine the eigenvectors, we multiply both sides of (12.28) by X T to give

$$
\left ( \frac { 1 } { N } X ^ { T } X \right ) ( X ^ { T } v _ { i } ) = \lambda _ { i } ( X ^ { T } v _ { i } )
$$

from which we see that (XTVi) is an eigenvector of S with eigenvalue Ai. Note, however, that these eigenvectors need not be normalized. To determine the appropriate normalization, we re-scale Ui ex: X T Vi by a constant such that Ilui II = 1, which, assuming Vi has been normalized to unit length, gives

$$
u _ { i } = \frac { 1 } { ( N \lambda _ { i } ) ^ { 1 / 2 } } X ^ { \top } v _ { i } .
$$

In summary, to apply this approach we first evaluate XX T and then find its eigenvectors and eigenvalues and then compute the eigenvectors in the original data space using (12.30).

# 12.2. Probabilistic peA

The formulation of PCA discussed in the previous section was based on a linear projection of the data onto a subspace of lower dimensionality than the original data space. We now show that PCA can also be expressed as the maximum likelihood solution of a probabilistic latent variable model. This reformulation of PCA, known as probabilistic peA, brings several advantages compared with conventional PCA:

• Probabilistic PCA represents a constrained form of the Gaussian distribution in which the number of free parameters can be restricted while still allowing the model to capture the dominant correlations in a data set.
