[Page 608]

Exercise 12.26

Substituting this expansion back into the eigenvector equation, we obtain

$$
\frac { 1 } { N } \sum _ { n = 1 } ^ { N } \phi ( x _ { n } ) \phi ( x _ { n } ) ^ { T } \sum _ { m = 1 } ^ { N } a _ { i m } \phi ( x _ { m } ) = \lambda _ { i } \sum _ { n = 1 } ^ { N } a _ { i n } \phi ( x _ { n } ) .
$$

The key step is now to express this in terms of the kernel function k (x n , x m ) = ¢(Xn)T ¢(x m ), which we do by multiplying both sides by ¢(xZ)T to give

$$
\frac { 1 } { N } \sum _ { n = 1 } ^ { N } k ( x _ { l } , x _ { n } ) \sum _ { m = 1 } ^ { m } a _ { i m } k ( x _ { n } , x _ { m } ) = \lambda _ { i } \sum _ { n = 1 } ^ { N } a _ { i n } k ( x _ { l } , x _ { n } ) .
$$

This can be written in matrix notation as

$$
K ^ { 2 } a _ { i } = \lambda _ { i } N K a _ { i }
$$

where ai is an N-dimensional column vector with elements ani for n = 1, ... ,N. We can find solutions for ai by solving the following eigenvalue problem

$$
K a _ { i } = \lambda _ { i } N a _ { i }
$$

in which we have removed a factor of K from both sides of (12.79). Note that the solutions of (12.79) and (12.80) differ only by eigenvectors of K having zero eigenvalues that do not affect the principal components projection.

The normalization condition for the coefficients ai is obtained by requiring that the eigenvectors in feature space be normalized. Using (12.76) and (12.80), we have

$$
1 = v _ { i } ^ { T } v _ { i } = \sum _ { n = 1 } ^ { N } \sum _ { m = 1 } ^ { N } a _ { i n } a _ { i m } \phi ( x _ { n } ) ^ { T } \phi ( x _ { m } ) = a _ { i } ^ { T } K a _ { i } = \lambda _ { i } N a _ { i } ^ { T } a _ { i } . \quad ( 1 2 . 8 1 )
$$

Having solved the eigenvector problem, the resulting principal component projections can then also be cast in terms of the kernel function so that, using (12.76), the projection of a point x onto eigenvector i is given by

$$
y _ { i } ( x ) = \phi ( x ) ^ { \top } v _ { i } = \sum _ { n = 1 } ^ { N } a _ { i n } \phi ( x ) ^ { \top } \phi ( x _ { n } ) = \sum _ { n = 1 } ^ { N } a _ { i n } k ( x , x _ { n } )
$$

and so again is expressed in terms of the kernel function.

In the original D-dimensional x space there are D orthogonal eigenvectors and hence we can find at most D linear principal components. The dimensionality M of the feature space, however, can be much larger than D (even infinite), and thus we can find a number of nonlinear principal components that can exceed D. Note, however, that the number of nonzero eigenvalues cannot exceed the number N of data points, because (even if M > N) the covariance matrix in feature space has rank at most equal to N. This is reflected in the fact that kernel PCA involves the eigenvector expansion of the N x N matrix K.
