[Page 717]

to whether the permutation i1i2 ...iN is even or odd, respectively. Note that |I| = 1. Thus, for a 2 × 2 matrix, the determinant takes the form

|A| = a11 a12 a21 a22

= a11a22 − a12a21. (C.11)

The determinant of a product of two matrices is given by

|AB| = |A||B| (C.12) as can be shown from (C.10). Also, the determinant of an inverse matrix is given by

1 |A|

A−1 =

(C.13)

which can be shown by taking the determinant of (C.2) and applying (C.12). If A and B are matrices of size N × M, then

IN + ABT = IM + ATB . (C.14) A useful special case is

IN + abT = 1 + aTb (C.15) where a and b are N-dimensional column vectors.

###### Matrix Derivatives

Sometimes we need to consider derivatives of vectors and matrices with respect to scalars. The derivative of a vector a with respect to a scalar x is itself a vector whose components are given by

∂a ∂x i

∂ai ∂x

=

(C.16)

with an analogous deﬁnition for the derivative of a matrix. Derivatives with respect to vectors and matrices can also be deﬁned, for instance

∂x ∂ai

∂x ∂a i

=

(C.17)

and similarly

∂a ∂b ij

∂ai ∂bj

=

. (C.18)

The following is easily proven by writing out the components

∂ ∂x

∂ ∂x

xTa =

aTx = a. (C.19)
