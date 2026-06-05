[Page 719]

for i = 1,...,M, where ui is an eigenvector and λi is the corresponding eigenvalue. This can be viewed as a set of M simultaneous homogeneous linear equations, and the condition for a solution is that

|A − λiI| = 0 (C.30)

which is known as the characteristic equation. Because this is a polynomial of order M in λi, it must have M solutions (though these need not all be distinct). The rank of A is equal to the number of nonzero eigenvalues.

Of particular interest are symmetric matrices, which arise as covariance matrices, kernel matrices, and Hessians. Symmetric matrices have the property that Aij = Aji, or equivalently AT = A. The inverse of a symmetric matrix is also symmetric, as can be seen by taking the transpose of A−1A = I and using AA−1 = I together with the symmetry of I.

In general, the eigenvalues of a matrix are complex numbers, but for symmetric matrices the eigenvalues λi are real. This can be seen by ﬁrst left multiplying (C.29) by (u�i )T, where � denotes the complex conjugate, to give

(u�i )T Aui = λi (u�i )T ui. (C.31) Next we take the complex conjugate of (C.29) and left multiply by uTi to give

uTi Au�i = λ�i uTi u�i . (C.32) where we have used A� = A because we consider only real matrices A. Taking the transpose of the second of these equations, and using AT = A, we see that the left-hand sides of the two equations are equal, and hence that λ�i = λi and so λi must be real.

The eigenvectors ui of a real symmetric matrix can be chosen to be orthonormal (i.e., orthogonal and of unit length) so that

uTi uj = Iij (C.33)

where Iij are the elements of the identity matrix I. To show this, we ﬁrst left multiply (C.29) by uTj to give

uTj Aui = λiuTj ui (C.34) and hence, by exchange of indices, we have

uTi Auj = λjuTi uj. (C.35)

We now take the transpose of the second equation and make use of the symmetry property AT = A, and then subtract the two equations to give

(λi − λj)uTi uj = 0. (C.36)

Hence, for λi �= λj, we have uTi uj = 0, and hence ui and uj are orthogonal. If the two eigenvalues are equal, then any linear combination αui + βuj is also an eigenvector with the same eigenvalue, so we can select one linear combination arbitrarily,
