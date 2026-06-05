[Page 101]

Figure 2.7 The red curve shows the elliptical surface of constant probability density for a Gaussian in a two-dimensional space $\mathbf{x} = (x_1, x_2)$ on which the density is $\exp(-1/2)$ of its value at $\mathbf{x} = \boldsymbol{\mu}$. The major axes of the ellipse are deﬁned by the eigenvectors $\mathbf{u}_i$ of the covariance matrix, with corresponding eigenvalues $\lambda_i$.

x2

u2

u1

y2

y1

µ

λ21/2

λ11/2

x1

where $U$ is a matrix whose rows are given by $\mathbf{u}_i^T$. From (2.46) it follows that $U$ is an orthogonal matrix, i.e., it satisﬁes $UU^T = I$, and hence also $U^TU = I$, where $I$ is the identity matrix.

The quadratic form, and hence the Gaussian density, will be constant on surfaces for which (2.50) is constant. If all of the eigenvalues $\lambda_i$ are positive, then these surfaces represent ellipsoids, with their centres at $\boldsymbol{\mu}$ and their axes oriented along $\mathbf{u}_i$, and with scaling factors in the directions of the axes given by $\lambda_i^{1/2}$, as illustrated in Figure 2.7.

For the Gaussian distribution to be well deﬁned, it is necessary for all of the eigenvalues $\lambda_i$ of the covariance matrix to be strictly positive, otherwise the distribution cannot be properly normalized. A matrix whose eigenvalues are strictly positive is said to be positive deﬁnite. In Chapter 12, we will encounter Gaussian distributions for which one or more of the eigenvalues are zero, in which case the distribution is singular and is conﬁned to a subspace of lower dimensionality. If all of the eigenvalues are nonnegative, then the covariance matrix is said to be positive semideﬁnite.

Now consider the form of the Gaussian distribution in the new coordinate system deﬁned by the $y_i$. In going from the $\mathbf{x}$ to the $\mathbf{y}$ coordinate system, we have a Jacobian matrix $J$ with elements given by

$$
J_{ij} = \frac{\partial x_i}{\partial y_j} = U_{ji} \tag{2.53}
$$

where $U_{ji}$ are the elements of the matrix $U^T$. Using the orthonormality property of the matrix $U$, we see that the square of the determinant of the Jacobian matrix is

$$
|J|^2 = |U^T|^2 = |U^T||U| = |U^TU| = |I| = 1 \tag{2.54}
$$

and hence $|J| = 1$. Also, the determinant $|\Sigma|$ of the covariance matrix can be written
