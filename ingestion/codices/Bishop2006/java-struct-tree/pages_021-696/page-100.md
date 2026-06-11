[Page 100]

functional dependence of the Gaussian on x is through the quadratic form

∆2 = (x − µ)TΣ−1(x − µ) (2.44)

which appears in the exponent. The quantity ∆ is called the Mahalanobis distance from µ to x and reduces to the Euclidean distance when Σ is the identity matrix. The Gaussian distribution will be constant on surfaces in x-space for which this quadratic form is constant.

First of all, we note that the matrix Σ can be taken to be symmetric, without

loss of generality, because any antisymmetric component would disappear from the Exercise 2.17 exponent. Now consider the eigenvector equation for the covariance matrix

Σui = λiui (2.45)

where i = 1,...,D. Because Σ is a real, symmetric matrix its eigenvalues will be Exercise 2.18 real, and its eigenvectors can be chosen to form an orthonormal set, so that

uTi uj = Iij (2.46) where Iij is the i,j element of the identity matrix and satisﬁes

Iij = �

1, if i = j 0, otherwise.

(2.47)

The covariance matrix Σ can be expressed as an expansion in terms of its eigenvecExercise 2.19 tors in the form

�D

Σ =

λiuiuTi (2.48)

i=1

and similarly the inverse covariance matrix Σ−1 can be expressed as

�D

1 λi

Σ−1 =

uiuTi . (2.49)

i=1

Substituting (2.49) into (2.44), the quadratic form becomes

�D

yi2 λi

∆2 =

(2.50)

i=1

where we have deﬁned

yi = uTi (x − µ). (2.51)

We can interpret {yi} as a new coordinate system deﬁned by the orthonormal vectors ui that are shifted and rotated with respect to the original xi coordinates. Forming the vector y = (y1,...,yD)T, we have

y = U(x − µ) (2.52)
