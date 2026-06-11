[Page 100]

Exercise 2.17

functional dependence of the Gaussian on x is through the quadratic form

$$
\Delta ^ { 2 } = ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu )
$$

which appears in the exponent. The quantity ∆ is called the Mahalanobis distance from µ to x and reduces to the Euclidean distance when Σ is the identity matrix. The Gaussian distribution will be constant on surfaces in x -space for which this quadratic form is constant.

First of all, we note that the matrix Σ can be taken to be symmetric, without loss of generality, because any antisymmetric component would disappear from the exponent. Now consider the eigenvector equation for the covariance matrix

$$
\Sigma u _ { i } = \lambda _ { i } u _ { i }
$$

where i = 1 ,...,D . Because Σ is a real, symmetric matrix its eigenvalues will be real, and its eigenvectors can be chosen to form an orthonormal set, so that Exercise 2.18

$$
u _ { i } ^ { T } u _ { j } = I _ { i j }
$$

where I ij is the i,j element of the identity matrix and satisﬁes

$$
I _ { i j } = \left \{ \begin{array} { l l } { 1 , } & { i f i = j } \\ { 0 , } & { o t h e r w i s e . } \end{array}
$$

The covariance matrix Σ can be expressed as an expansion in terms of its eigenvec-

tors in the form Exercise 2.19

$$
\Sigma = \sum _ { i = 1 } ^ { D } \lambda _ { i } u _ { i } u _ { i } ^ { T } & & ( 2 . 4 8 ) \\ \text {covariance matrix} \ \Sigma ^ { - 1 } & \text { can be expressed as}
$$

and similarly the inverse covariance matrix Σ − 1 can be expressed as

$$
\Sigma ^ { - 1 } = \sum _ { i = 1 } ^ { D } \frac { 1 } { \lambda _ { i } } u _ { i } ^ { \top } . \\ \intertext { o } ( 2 . 4 4 ) \, \text { the quadratic form becomes }
$$

Substituting (2.49) into (2.44), the quadratic form becomes

$$
\Delta ^ { 2 } = \sum _ { i = 1 } ^ { D } \frac { y _ { i } ^ { 2 } } { \lambda _ { i } }
$$

where we have deﬁned

$$
y _ { i } = \mathbf u _ { i } ^ { T } ( x - \mu ) . \\
$$

We can interpret { y i } as a new coordinate system deﬁned by the orthonormal vectors u i that are shifted and rotated with respect to the original x i coordinates. Forming the vector y = ( y 1 ,...,y D ) T , we have

$$
y = U ( x - \mu )
$$
