[Page 102]

as the product of its eigenvalues, and hence

�D

λ1j/2. (2.55)

|Σ|1/2 =

j=1

Thus in the yj coordinate system, the Gaussian distribution takes the form

exp�−

� (2.56)

�D

yj2 2λj

1 (2πλj)1/2

p(y) = p(x)|J| =

j=1

which is the product of D independent univariate Gaussian distributions. The eigenvectors therefore deﬁne a new set of shifted and rotated coordinates with respect to which the joint probability distribution factorizes into a product of independent distributions. The integral of the distribution in the y coordinate system is then

exp�−

� dyj = 1 (2.57)

� p(y)dy =

� ∞

�D

yj2 2λj

1 (2πλj)1/2

−∞

j=1

where we have used the result (1.48) for the normalization of the univariate Gaussian. This conﬁrms that the multivariate Gaussian (2.43) is indeed normalized.

We now look at the moments of the Gaussian distribution and thereby provide an interpretation of the parameters µ and Σ. The expectation of x under the Gaussian distribution is given by

� exp�−

(x − µ)TΣ−1(x − µ)�xdx

1 2

1 |Σ|1/2

1 (2π)D/2

E[x] =

� exp�−

zTΣ−1z�(z + µ)dz (2.58)

1 (2π)D/2

1 2

1 |Σ|1/2

=

where we have changed variables using z = x − µ. We now note that the exponent is an even function of the components of z and, because the integrals over these are taken over the range (−∞,∞), the term in z in the factor (z + µ) will vanish by symmetry. Thus

E[x] = µ (2.59) and so we refer to µ as the mean of the Gaussian distribution.

We now consider second order moments of the Gaussian. In the univariate case, we considered the second order moment given by E[x2]. For the multivariate Gaussian, there are D2 second order moments given by E[xixj], which we can group together to form the matrix E[xxT]. This matrix can be written as

� exp�−

(x − µ)TΣ−1(x − µ)�xxT dx

1 |Σ|1/2

1 (2π)D/2

1 2

E[xxT] =

� exp�−

zTΣ−1z�(z + µ)(z + µ)T dz

1 |Σ|1/2

1 (2π)D/2

1 2

=
