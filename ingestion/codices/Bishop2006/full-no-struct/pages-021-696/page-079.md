[Page 79]

1.6 ( ) Show that if two variables x and y are independent, then their covariance is zero.

1.7 ( ) www In this exercise, we prove the normalization condition (1.48) for the univariate Gaussian. To do this consider, the integral

$$
I & = \int _ { - \infty } ^ { \infty } \exp \left ( - \frac { 1 } { 2 \sigma ^ { 2 } } x ^ { 2 } \right ) \, d x & & ( 1 . 1 2 4 ) \\
$$

which we can evaluate by ﬁrst writing its square in the form

$$
I ^ { 2 } = \int _ { - \infty } ^ { \infty } \int _ { - \infty } ^ { \infty } \exp \left ( - \frac { 1 } { 2 \sigma ^ { 2 } } x ^ { 2 } - \frac { 1 } { 2 \sigma ^ { 2 } } y ^ { 2 } \right ) \, d x \, d y . \\
$$

Now make the transformation from Cartesian coordinates ( x,y ) to polar coordinates ( r,θ ) and then substitute u = r 2 . Show that, by performing the integrals over θ and u , and then taking the square root of both sides, we obtain

$$
I & = ( 2 \pi \sigma ^ { 2 } ) ^ { 1 / 2 } \, . & ( 1 . 1 2 6 ) \\ \intertext { s o w t h a t h e the Gaussian distribution }
$$

Finally, use this result to show that the Gaussian distribution N ( x | µ,σ 2 ) is normalized.

1.8 ( ) www By using a change of variables, verify that the univariate Gaussian distribution given by (1.46) satisﬁes (1.49). Next, by differentiating both sides of the normalization condition

$$
\int _ { - \infty } ^ { \infty } \mathcal { N } \left ( x | \mu , \sigma ^ { 2 } \right ) \, d x & = 1 & ( 1 . 1 2 7 ) \\ \intertext { v i r f y } \text { verify that the Gaussian satisfies } ( 1 . 5 0 ) . \text { Finally, show that } ( 1 . 5 1 )
$$

with respect to σ 2 , verify that the Gaussian satisﬁes (1.50). Finally, show that (1.51) holds.

1.9 ( ) www Show that the mode (i.e. the maximum) of the Gaussian distribution (1.46) is given by µ . Similarly, show that the mode of the multivariate Gaussian (1.52) is given by µ .

1.10 ( ) www Suppose that the two variables x and z are statistically independent. Show that the mean and variance of their sum satisﬁes

$$
\mathbb { E } [ x + z ] \ = \ \mathbb { E } [ x ] + \mathbb { E } [ z ]
$$

$$
\ v a r [ x + z ] \ = \ v a r [ x ] + v a r [ z ] .
$$

1.11 ( ) By setting the derivatives of the log likelihood function (1.54) with respect to µ and σ 2 equal to zero, verify the results (1.55) and (1.56).
