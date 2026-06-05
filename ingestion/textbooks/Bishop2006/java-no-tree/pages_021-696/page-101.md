[Page 101]

Figure 2.7 The red curve shows the elliptical surface of constant probability density for a Gaussian in a two-dimensional space x = (x1, x2) on which the density is exp(−1/2) of its value at x = µ. The major axes of the ellipse are deﬁned by the eigenvectors ui of the covariance matrix, with corresponding eigenvalues λi.

x2

u2

u1

y2

y1

µ

λ21/2

λ11/2

x1

where U is a matrix whose rows are given by uTi . From (2.46) it follows that U is Appendix C an orthogonal matrix, i.e., it satisﬁes UUT = I, and hence also UTU = I, where I

is the identity matrix.

The quadratic form, and hence the Gaussian density, will be constant on surfaces for which (2.51) is constant. If all of the eigenvalues λi are positive, then these surfaces represent ellipsoids, with their centres at µ and their axes oriented along ui,

and with scaling factors in the directions of the axes given by λ1i/2, as illustrated in Figure 2.7.

For the Gaussian distribution to be well deﬁned, it is necessary for all of the eigenvalues λi of the covariance matrix to be strictly positive, otherwise the distribution cannot be properly normalized. A matrix whose eigenvalues are strictly positive is said to be positive deﬁnite. In Chapter 12, we will encounter Gaussian distributions for which one or more of the eigenvalues are zero, in which case the distribution is singular and is conﬁned to a subspace of lower dimensionality. If all of the eigenvalues are nonnegative, then the covariance matrix is said to be positive semideﬁnite.

Now consider the form of the Gaussian distribution in the new coordinate system

deﬁned by the yi. In going from the x to the y coordinate system, we have a Jacobian matrix J with elements given by

∂xi ∂yj

Jij =

= Uji (2.53)

where Uji are the elements of the matrix UT. Using the orthonormality property of the matrix U, we see that the square of the determinant of the Jacobian matrix is

|J|2 = UT 2 = UT |U| = UTU = |I| = 1 (2.54) and hence |J| = 1. Also, the determinant |Σ| of the covariance matrix can be written
