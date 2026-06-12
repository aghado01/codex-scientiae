[Page 151]

2.16 ( ) www Consider two random variables x 1 and x 2 having Gaussian distributions with means µ 1 ,µ 2 and precisions τ 1 , τ 2 respectively. Derive an expression for the differential entropy of the variable x = x 1 + x 2 . To do this, ﬁrst ﬁnd the distribution of x by using the relation

$$
p ( x ) & = \int _ { - \infty } ^ { \infty } p ( x | x _ { 2 } ) p ( x _ { 2 } ) \, d x _ { 2 } & ( 2 . 2 8 4 ) \\ \intertext { t h e s u r g e i n the w i n g e n t }
$$

and completing the square in the exponent. Then observe that this represents the convolution of two Gaussian distributions, which itself will be Gaussian, and ﬁnally make use of the result (1.110) for the entropy of the univariate Gaussian.

2.17 ( ) www Consider the multivariate Gaussian distribution given by (2.43). By writing the precision matrix (inverse covariance matrix) Σ − 1 as the sum of a symmetric and an anti-symmetric matrix, show that the anti-symmetric term does not appear in the exponent of the Gaussian, and hence that the precision matrix may be taken to be symmetric without loss of generality. Because the inverse of a symmetric matrix is also symmetric (see Exercise 2.22), it follows that the covariance matrix may also be chosen to be symmetric without loss of generality.

2.18 ( ) Consider a real, symmetric matrix Σ whose eigenvalue equation is given by (2.45). By taking the complex conjugate of this equation and subtracting the original equation, and then forming the inner product with eigenvector u i , show that the eigenvalues λ i are real. Similarly, use the symmetry property of Σ to show that two eigenvectors u i and u j will be orthogonal provided λ j = λ i . Finally, show that without loss of generality, the set of eigenvectors can be chosen to be orthonormal, so that they satisfy (2.46), even if some of the eigenvalues are zero.

/negationslash

2.19 ( ) Show that a real, symmetric matrix Σ having the eigenvector equation (2.45) can be expressed as an expansion in the eigenvectors, with coefﬁcients given by the eigenvalues, of the form (2.48). Similarly, show that the inverse matrix Σ − 1 has a representation of the form (2.49).

2.20 ( ) www A positive deﬁnite matrix Σ can be deﬁned as one for which the quadratic form T

$$
a ^ { \top } \Sigma a
$$

is positive for any real value of the vector a . Show that a necessary and sufﬁcient condition for Σ to be positive deﬁnite is that all of the eigenvalues λ i of Σ , deﬁned by (2.45), are positive.

2.21 ( ) Show that a real, symmetric matrix of size D × D has D ( D +1) / 2 independent parameters.

2.22 ( ) www Show that the inverse of a symmetric matrix is itself symmetric.

2.23 ( ) By diagonalizing the coordinate system using the eigenvector expansion (2.45), show that the volume contained within the hyperellipsoid corresponding to a constant
