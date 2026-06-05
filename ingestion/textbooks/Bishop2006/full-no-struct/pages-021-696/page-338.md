[Page 338]

Appendix A

The terms arising from the explicit dependence on θ can be found by using (6.80) together with the results (C.21) and (C.22), and are given by

$$
\frac { \partial \ln p ( t _ { N } | \theta ) } { \partial \theta _ { j } } \ & = \ \frac { 1 } { 2 } a _ { N } ^ { * } C _ { N } ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { j } } C _ { N } ^ { - 1 } a _ { N } ^ { * } \\ & - \frac { 1 } { 2 } T r \left [ ( I + C _ { N } W _ { N } ) ^ { - 1 } W _ { N } \frac { \partial C _ { N } } { \partial \theta _ { j } } \right ] . \\ \intertext { To compute the terms arising from the dependence of a * _ { s } on \theta , we note that }
$$

To compute the terms arising from the dependence of a N on θ , we note that the Laplace approximation has been constructed such that Ψ( a N ) has zero gradient at a N = a N , and so Ψ( a N ) gives no contribution to the gradient as a result of its dependence on a N . This leaves the following contribution to the derivative with respect to a component θ j of θ

$$
- \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \frac { \partial \ln | W _ { N } + C _ { N } ^ { - 1 } | \partial a _ { n } ^ { * } } { \partial a _ { n } ^ { * } } \frac { | \partial a _ { n } ^ { * } } { \partial \theta _ { j } } \\ = - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \left [ ( I + C _ { N } W _ { N } ) ^ { - 1 } C _ { N } \right ] _ { n n } \sigma _ { n } ^ { * } ( 1 - \sigma _ { n } ^ { * } ) ( 1 - 2 \sigma _ { n } ^ { * } ) \frac { \partial a _ { n } ^ { * } } { \partial \theta _ { j } } \quad ( 6 . 9 2 ) \\ \text {where } \sigma _ { n } ^ { * } = \sigma ( a _ { n } ^ { * } ) , \text { and again we have used the result (C.22) together with the }
$$

where σ n = σ ( a n ) , and again we have used the result (C.22) together with the deﬁnition of W N . We can evaluate the derivative of a N with respect to θ j by differentiating the relation (6.84) with respect to θ j to give

$$
\frac { \partial a _ { n } ^ { * } } { \partial \theta _ { j } } = \frac { \partial C _ { N } } { \partial \theta _ { j } } ( \mathfrak { t } _ { N } - \sigma _ { N } ) - C _ { N } W _ { N } \frac { \partial a _ { n } ^ { * } } { \partial \theta _ { j } } .
$$

Rearranging then gives

$$
\frac { \partial a _ { n } ^ { * } } { \partial \theta _ { j } } = ( I + \mathbf W _ { N } C _ { N } ) ^ { - 1 } \frac { \partial C _ { N } } { \partial \theta _ { j } } ( \mathbf t _ { N } - \sigma _ { N } ) .
$$

Combining (6.91), (6.92), and (6.94), we can evaluate the gradient of the log likelihood function, which can be used with standard nonlinear optimization algorithms in order to determine a value for θ .

We can illustrate the application of the Laplace approximation for Gaussian processes using the synthetic two-class data set shown in Figure 6.12. Extension of the Laplace approximation to Gaussian processes involving K > 2 classes, using the softmax activation function, is straightforward (Williams and Barber, 1998).
