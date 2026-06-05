[Page 320]

point. If the differential operator is isotropic then the Green’s functions depend only on the radial distance from the corresponding data point. Due to the presence of the regularizer, the solution no longer interpolates the training data exactly.

Another motivation for radial basis functions comes from a consideration of the interpolation problem when the input (rather than the target) variables are noisy (Webb, 1994; Bishop, 1995a). If the noise on the input variable x is described by a variable ξ having a distribution ν ( ξ ) , then the sum-of-squares error function becomes N

$$
E = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \int \{ y ( x _ { n } + \xi ) - t _ { n } \} ^ { 2 } \, \nu ( \xi ) \, d \xi . \\ \intertext { c a l c u l u s  o f v a r i t i m a s , w e c a n o t i m i z e w i t h e r s e p t o w }
$$

Using the calculus of variations, we can optimize with respect to the function f ( x ) to give

$$
y ( x _ { n } ) = \sum _ { n = 1 } ^ { N } t _ { n } h ( x - x _ { n } ) \\ \text {functions are given by}
$$

where the basis functions are given by

$$
h ( x - x _ { n } ) = \frac { \nu ( x - x _ { n } ) } { N } . \\ \intertext { i s one basis function centred on every data point. This is known as }
$$

We see that there is one basis function centred on every data point. This is known as the Nadaraya-Watson model and will be derived again from a different perspective in Section 6.3.1. If the noise distribution ν ( ξ ) is isotropic, so that it is a function only of ξ , then the basis functions will be radial. Note that the basis functions (6.41) are normalized, so that n h ( x − x n ) = 1

for any value of x . The effect of such normalization is shown in Figure 6.2. Normalization is sometimes used in practice as it avoids having regions of input space where all of the basis functions take small values, which would necessarily lead to predictions in such regions that are either small or controlled purely by the bias parameter.

Another situation in which expansions in normalized radial basis functions arise is in the application of kernel density estimation to the problem of regression, as we shall discuss in Section 6.3.1.

Because there is one basis function associated with every data point, the corresponding model can be computationally costly to evaluate when making predictions for new data points. Models have therefore been proposed (Broomhead and Lowe, 1988; Moody and Darken, 1989; Poggio and Girosi, 1990), which retain the expansion in radial basis functions but where the number M of basis functions is smaller than the number N of data points. Typically, the number of basis functions, and the locations µ i of their centres, are determined based on the input data { x n } alone. The basis functions are then kept ﬁxed and the coefﬁcients { w i } are determined by least squares by solving the usual set of linear equations, as discussed in Section 3.1.1.
