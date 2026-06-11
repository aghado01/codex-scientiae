[Page 719]

for i = 1 ,...,M , where u i is an eigenvector and λ i is the corresponding eigenvalue . This can be viewed as a set of M simultaneous homogeneous linear equations, and the condition for a solution is that

$$
| A - \lambda _ { i } I | = 0
$$

which is known as the characteristic equation . Because this is a polynomial of order M in λ i , it must have M solutions (though these need not all be distinct). The rank of A is equal to the number of nonzero eigenvalues.

Of particular interest are symmetric matrices, which arise as covariance matrices, kernel matrices, and Hessians. Symmetric matrices have the property that A ij = A ji , or equivalently A T = A . The inverse of a symmetric matrix is also symmetric, as can be seen by taking the transpose of A − 1 A = I and using AA − 1 = I together with the symmetry of I .

In general, the eigenvalues of a matrix are complex numbers, but for symmetric matrices the eigenvalues λ i are real. This can be seen by ﬁrst left multiplying (C.29) by ( u i ) T , where denotes the complex conjugate, to give

$$
( u _ { i } ^ { * } ) ^ { T } \, A u _ { i } = \lambda _ { i } \, ( u _ { i } ^ { * } ) ^ { T } \, u _ { i } .
$$

Next we take the complex conjugate of (C.29) and left multiply by u T i to give

$$
u _ { i } ^ { \top } A u _ { i } ^ { * } = \lambda _ { i } ^ { * } u _ { i } ^ { \top } u _ { i } ^ { * } .
$$

where we have used A = A because we consider only real matrices A . Taking the transpose of the second of these equations, and using A T = A , we see that the left-hand sides of the two equations are equal, and hence that λ i = λ i and so λ i must be real.

The eigenvectors u i of a real symmetric matrix can be chosen to be orthonormal (i.e., orthogonal and of unit length) so that

$$
u _ { i } ^ { T } u _ { j } = I _ { i j }
$$

where I ij are the elements of the identity matrix I . To show this, we ﬁrst left multiply (C.29) by u T j to give T T

$$
u _ { j } ^ { T } A u _ { i } = \lambda _ { i } u _ { j } ^ { T } u _ { i }
$$

and hence, by exchange of indices, we have

$$
u _ { i } ^ { T } A u _ { j } = \lambda _ { j } u _ { i } ^ { T } u _ { j } .
$$

We now take the transpose of the second equation and make use of the symmetry property A T = A , and then subtract the two equations to give

$$
( \lambda _ { i } - \lambda _ { j } ) \, u _ { i } ^ { \top } u _ { j } & = 0 . \\
$$

Hence, for λ i = λ j , we have u T i u j = 0 , and hence u i and u j are orthogonal. If the two eigenvalues are equal, then any linear combination α u i + β u j is also an eigenvector with the same eigenvalue, so we can select one linear combination arbitrarily,

/negationslash and then choose the second to be orthogonal to the first (it can be shown that the degenerate eigenvectors are never linearly dependent). Hence the eigenvectors can be chosen to be orthogonal, and by normalizing can be set to unit length. Because there are M eigenvalues, the corresponding M orthogonal eigenvectors form a complete set and so any M -dimensional vector can be expressed as a linear combination of the eigenvectors.
