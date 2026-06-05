[Page 101]

Figure 2.7 The red curve shows the elliptical surface of constant probability density for a Gaussian in a two-dimensional space x = ( x 1 , x 2 ) on which the density is exp( − 1 / 2) of its value at x = µ . The major axes of the ellipse are deﬁned by the eigenvectors u i of the covariance matrix, with corresponding eigenvalues .

ing eigenvalues λ i .

x

![The image depicts a geometric figure with several points and lines. Here is a detailed description of the objects present in the image: 1. **Points and Lines**: - **Points**: There are four points labeled as ( u_1, u_2, u_3, u_4 ). - **Lines**: There are two lines: - **Line ( u_1 )**: This line is drawn from point ( u_1 ) to point ( u_2 ). - **Line ( u_2 )**: This line is drawn from point ( u_2 ) to point ( u_3 ). - **Line ( u_3 )**: This line is drawn from point ( u_3 ) to point ( u_4 ). - **Line ( u_4 )**: This line is drawn from point ( u_4 )](../images/imageFile48.png)

2

2

u

1

u

y

2

y

1

µ

/

1

2

λ

2

/

1

2

λ

1

x

1

Appendix C

where U is a matrix whose rows are given by u T i . From (2.46) it follows that U is an orthogonal matrix, i.e., it satisﬁes UU T = I , and hence also U T U = I , where I is the identity matrix.

The quadratic form, and hence the Gaussian density, will be constant on surfaces for which (2.51) is constant. If all of the eigenvalues λ i are positive, then these surfaces represent ellipsoids, with their centres at µ and their axes oriented along u i , and with scaling factors in the directions of the axes given by λ 1 / 2 i , as illustrated in Figure 2.7.

For the Gaussian distribution to be well deﬁned, it is necessary for all of the eigenvalues λ i of the covariance matrix to be strictly positive, otherwise the distribution cannot be properly normalized. A matrix whose eigenvalues are strictly positive is said to be positive deﬁnite . In Chapter 12, we will encounter Gaussian distributions for which one or more of the eigenvalues are zero, in which case the distribution is singular and is conﬁned to a subspace of lower dimensionality. If all of the eigenvalues are nonnegative, then the covariance matrix is said to be positive semideﬁnite .

Now consider the form of the Gaussian distribution in the new coordinate system deﬁned by the y i . In going from the x to the y coordinate system, we have a Jacobian matrix J with elements given by

$$
J _ { i j } = \frac { \partial x _ { i } } { \partial y _ { j } } = U _ { j i }
$$

where U ji are the elements of the matrix U T . Using the orthonormality property of the matrix U , we see that the square of the determinant of the Jacobian matrix is

$$
| J | ^ { 2 } & = | U ^ { T } | ^ { 2 } = | U ^ { T } | | U | = | U ^ { T } U | = | I | = 1 \\ \text {ence} \, | J | & = 1 . \ A l s o , \, \text {the determinant} \, | \Sigma | \, \text { of the covariance matrix can be written}
$$

            and hence | J | = 1 . Also, the determinant | Σ | of the covariance matrix can be written
