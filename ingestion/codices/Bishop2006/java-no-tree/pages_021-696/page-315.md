[Page 315]

1

1

1

| |
|---|


| |
|---|


| |
|---|


0.5

0.75

0.75

0

0.5

0.5

−0.5

0.25

0.25

−1

0

0

−1 0 1

−1

0 1

−1

0 1

| |
|---|
| |


| |
|---|
| |


| |
|---|
| |


0.04

0.04

0.04

0.02

0.02

0.02

0

0

0

−1 0 1

−1 0 1

−1 0 1

- Figure 6.1 Illustration of the construction of kernel functions starting from a corresponding set of basis functions. In each column the lower plot shows the kernel function k(x, x ) deﬁned by (6.10) plotted as a function of x for x = 0, while the upper plot shows the corresponding basis functions given by polynomials (left column), ‘Gaussians’ (centre column), and logistic sigmoids (right column).


If we take the particular case of a two-dimensional input space x = (x1,x2) we can expand out the terms and thereby identify the corresponding nonlinear feature mapping

k(x,z) = xTz 2 = (x1z1 + x2z2)2 = x21z12 + 2x1z1x2z2 + x22z22

√2x1x2,x22)(z12,

√2z1z2,z22)T

= (x21,

= φ(x)Tφ(z). (6.12)

We see that the feature mapping takes the form φ(x) = (x21,√2x1x2,x22)T and therefore comprises all possible second order terms, with a speciﬁc weighting between them.

More generally, however, we need a simple way to test whether a function constitutes a valid kernel without having to construct the function φ(x) explicitly. A necessary and sufﬁcient condition for a function k(x,x ) to be a valid kernel (ShaweTaylor and Cristianini, 2004) is that the Gram matrix K, whose elements are given by k(xn,xm), should be positive semideﬁnite for all possible choices of the set {xn}. Note that a positive semideﬁnite matrix is not the same thing as a matrix whose

Appendix C elements are nonnegative.

One powerful technique for constructing new kernels is to build them out of simpler kernels as building blocks. This can be done using the following properties:
