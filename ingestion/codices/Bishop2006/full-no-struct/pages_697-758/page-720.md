[Page 720]

We can take the eigenvectors u i to be the columns of an M × M matrix U , which from orthonormality satisﬁes

$$
U ^ { T } U = I .
$$

Such a matrix is said to be orthogonal . Interestingly, the rows of this matrix are also orthogonal, so that UU T = I . To show this, note that (C.37) implies U T UU − 1 = U − 1 = U T and so UU − 1 = UU T = I . Using (C.12), it also follows that | U | = 1 . The eigenvector equation (C.29) can be expressed in terms of U in the form

The eigenvector equation (C.29) can be expressed in terms of U in the form

$$
A U = U \Lambda
$$

where Λ is an M × M diagonal matrix whose diagonal elements are given by the eigenvalues λ i . If we consider a column vector x that is transformed by an orthogonal matrix U

If we consider a column vector x that is transformed by an orthogonal matrix U to give a new vector

x = Ux then the length of the vector is preserved because x T x = x T U T Ux =

$$
\tilde { x } = U x
$$

$$
\widetilde { x } ^ { T } \widetilde { x } = x ^ { T } U ^ { T } U x = x ^ { T } x
$$

    x T x and similarly the angle between any two such vectors is preserved because

x T y = x T U T Uy = x T y . (C.41) Thus, multiplication by U can be interpreted as a rigid rotation of the coordinate system.

From (C.38), it follows that

$$
U ^ { T } A U = \Lambda
$$

and because Λ is a diagonal matrix, we say that the matrix A is diagonalized by the matrix U . If we left multiply by U and right multiply by U T , we obtain

$$
A = U \Lambda U ^ { T }
$$

Taking the inverse of this equation, and using (C.3) together with U − 1 = U T , we have 1 1 T

$$
A ^ { - 1 } = U \Lambda ^ { - 1 } U ^ { T } .
$$
