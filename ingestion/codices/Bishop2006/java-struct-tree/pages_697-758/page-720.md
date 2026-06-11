[Page 720]

and then choose the second to be orthogonal to the ﬁrst (it can be shown that the degenerate eigenvectors are never linearly dependent). Hence the eigenvectors can be chosen to be orthogonal, and by normalizing can be set to unit length. Because there are M eigenvalues, the corresponding M orthogonal eigenvectors form a complete set and so any M-dimensional vector can be expressed as a linear combination of the eigenvectors.

We can take the eigenvectors ui to be the columns of an M × M matrix U, which from orthonormality satisﬁes

UTU = I. (C.37)

Such a matrix is said to be orthogonal. Interestingly, the rows of this matrix are also orthogonal, so that UUT = I. To show this, note that (C.37) implies UTUU−1 = U−1 = UT and so UU−1 = UUT = I. Using (C.12), it also follows that |U| = 1. The eigenvector equation (C.29) can be expressed in terms of U in the form

AU = UΛ (C.38)

where Λ is an M × M diagonal matrix whose diagonal elements are given by the eigenvalues λi.

If we consider a column vector x that is transformed by an orthogonal matrix U to give a new vector

x� = Ux (C.39) then the length of the vector is preserved because

x�Tx� = xTUTUx = xTx (C.40) and similarly the angle between any two such vectors is preserved because

x�Ty� = xTUTUy = xTy. (C.41)

Thus, multiplication by U can be interpreted as a rigid rotation of the coordinate system.

From (C.38), it follows that

UTAU = Λ (C.42)

and because Λ is a diagonal matrix, we say that the matrix A is diagonalized by the matrix U. If we left multiply by U and right multiply by UT, we obtain

A = UΛUT (C.43)

Taking the inverse of this equation, and using (C.3) together with U−1 = UT, we have

A−1 = UΛ−1UT. (C.44)
