[Page 320]

point. If the differential operator is isotropic then the Green’s functions depend only on the radial distance from the corresponding data point. Due to the presence of the regularizer, the solution no longer interpolates the training data exactly.

Another motivation for radial basis functions comes from a consideration of the interpolation problem when the input (rather than the target) variables are noisy (Webb, 1994; Bishop, 1995a). If the noise on the input variable x is described by a variable ξ having a distribution ν(ξ), then the sum-of-squares error function becomes

N

1 2

{y(xn + ξ) − tn}2 ν(ξ)dξ. (6.39)

E =

n=1

Appendix D Using the calculus of variations, we can optimize with respect to the function f(x)

- Exercise 6.17 to give


N

y(xn) =

tnh(x − xn) (6.40)

n=1

where the basis functions are given by

ν(x − xn) N

h(x − xn) =

. (6.41)

ν(x − xn)

n=1

We see that there is one basis function centred on every data point. This is known as the Nadaraya-Watson model and will be derived again from a different perspective in Section 6.3.1. If the noise distribution ν(ξ) is isotropic, so that it is a function only of ξ , then the basis functions will be radial.

Note that the basis functions (6.41) are normalized, so that n h(x − xn) = 1 for any value of x. The effect of such normalization is shown in Figure 6.2. Normalization is sometimes used in practice as it avoids having regions of input space where all of the basis functions take small values, which would necessarily lead to predictions in such regions that are either small or controlled purely by the bias parameter.

Another situation in which expansions in normalized radial basis functions arise is in the application of kernel density estimation to the problem of regression, as we shall discuss in Section 6.3.1.

Because there is one basis function associated with every data point, the corresponding model can be computationally costly to evaluate when making predictions for new data points. Models have therefore been proposed (Broomhead and Lowe, 1988; Moody and Darken, 1989; Poggio and Girosi, 1990), which retain the expansion in radial basis functions but where the number M of basis functions is smaller than the number N of data points. Typically, the number of basis functions, and the locations µi of their centres, are determined based on the input data {xn} alone. The basis functions are then kept ﬁxed and the coefﬁcients {wi} are determined by least squares by solving the usual set of linear equations, as discussed in Section 3.1.1.
