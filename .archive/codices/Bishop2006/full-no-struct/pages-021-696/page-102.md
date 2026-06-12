[Page 102]

as the product of its eigenvalues, and hence

$$
| \Sigma | ^ { 1 / 2 } = \prod _ { j = 1 } ^ { D } \lambda _ { j } ^ { 1 / 2 } . \\ \intertext { t e s t e m } \text { the Gaussian distribution takes the form }
$$

Thus in the y j coordinate system, the Gaussian distribution takes the form

$$
p ( y ) = p ( x ) | J | = \prod _ { j = 1 } ^ { D } \frac { 1 } { ( 2 \pi \lambda _ { j } ) ^ { 1 / 2 } } \exp \left \{ - \frac { y _ { j } ^ { 2 } } { 2 \lambda _ { j } } \right \} \\ \text {is the product of} \, D \, \text {independent univariate} \, \text {Gaussian distributions} \, \text {The eigen-}
$$

which is the product of D independent univariate Gaussian distributions. The eigenvectors therefore deﬁne a new set of shifted and rotated coordinates with respect to which the joint probability distribution factorizes into a product of independent distributions. The integral of the distribution in the y coordinate system is then

$$
\int p ( y ) \, d y = \prod _ { j = 1 } ^ { D } \int _ { - \infty } ^ { \infty } \frac { 1 } { ( 2 \pi \lambda _ { j } ) ^ { 1 / 2 } } \exp \left \{ - \frac { y _ { j } ^ { 2 } } { 2 \lambda _ { j } } \right \} \, d y _ { j } = 1 \\ \intertext { w h e v e h a v e s u d e t h e r s l u t i o n } \text {where we have used the result (1 4 8) for the normalization of the univariate Gaussian}
$$

where we have used the result (1.48) for the normalization of the univariate Gaussian. This conﬁrms that the multivariate Gaussian (2.43) is indeed normalized.

We now look at the moments of the Gaussian distribution and thereby provide an interpretation of the parameters µ and Σ . The expectation of x under the Gaussian distribution is given by

$$
d i t b u i n & \text { is given by} \\ & \mathbb { E } [ x ] \ = \ \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \int \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} x \, d x \\ & = \ \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \int \exp \left \{ - \frac { 1 } { 2 } z ^ { T } \Sigma ^ { - 1 } z \right \} ( z + \mu ) \, d z \\ \intertext { w h e v a g h e n d } \text {where we have changed variables using } z & = x - \mu . \text { We now note that the exponent }
$$

where we have changed variables using z = x − µ . We now note that the exponent is an even function of the components of z and, because the integrals over these are taken over the range ( −∞ , ∞ ) , the term in z in the factor ( z + µ ) will vanish by symmetry. Thus

$$
\mathbb { E } [ x ] = \mu
$$

and so we refer to µ as the mean of the Gaussian distribution.

We now consider second order moments of the Gaussian. In the univariate case, we considered the second order moment given by E [ x 2 ] . For the multivariate Gaussian, there are D 2 second order moments given by E [ x i x j ] , which we can group together to form the matrix E [ xx T ] . This matrix can be written as

$$
\text {together to form the matrix } & \mathbb { E } [ x x ^ { T } ] . \text { This matrix can be written as} \\ & \mathbb { E } [ x x ^ { T } ] = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \int \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} x x ^ { T } d x \\ & = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \int \exp \left \{ - \frac { 1 } { 2 } z ^ { T } \Sigma ^ { - 1 } z \right \} ( z + \mu ) ( z + \mu ) ^ { T } d z
$$
