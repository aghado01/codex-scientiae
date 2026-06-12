[Page 487]

# Section 2.3.1

Exercise 10.2

optimal factor q 1 ( z 1 ) . In doing so it is useful to note that on the right-hand side we only need to retain those terms that have some functional dependence on z 1 because all other terms can be absorbed into the normalization constant. Thus we have

$$
\ln q _ { 1 } ^ { * } ( z _ { 1 } ) \ & = \ \mathbb { E } _ { z _ { 2 } } [ \ln p ( z ) ] + \text {const} \\ & = \ \mathbb { E } _ { z _ { 2 } } \left [ - \frac { 1 } { 2 } ( z _ { 1 } - \mu _ { 1 } ) ^ { 2 } \Lambda _ { 1 1 } - ( z _ { 1 } - \mu _ { 1 } ) \Lambda _ { 1 2 } ( z _ { 2 } - \mu _ { 2 } ) \right ] + \text {const} \\ & = \ \frac { 1 } { 2 } z _ { 1 } ^ { 2 } \Lambda _ { 1 1 } + z _ { 1 } \mu _ { 1 } \Lambda _ { 1 1 } - z _ { 1 } \Lambda _ { 1 2 } \left ( \mathbb { E } [ z _ { 2 } ] - \mu _ { 2 } \right ) + \text {const} . \quad ( 1 0 . 1 1 ) \\ \text {Next we observe that the right-hand side of this expression is a quadratic function of}
$$

Next we observe that the right-hand side of this expression is a quadratic function of z 1 , and so we can identify q ( z 1 ) as a Gaussian distribution. It is worth emphasizing that we did not assume that q ( z i ) is Gaussian, but rather we derived this result by variational optimization of the KL divergence over all possible distributions q ( z i ) . Note also that we do not need to consider the additive constant in (10.9) explicitly because it represents the normalization constant that can be found at the end by inspection if required. Using the technique of completing the square, we can identify the mean and precision of this Gaussian, giving

$$
q ^ { * } ( z _ { 1 } ) = \mathcal { N } ( z _ { 1 } | m _ { 1 } , \Lambda _ { 1 1 } ^ { - 1 } )
$$

where

$$
m _ { 1 } = \mu _ { 1 } - \Lambda _ { 1 1 } ^ { - 1 } \Lambda _ { 1 2 } \left ( \mathbb { E } [ z _ { 2 } ] - \mu _ { 2 } \right ) . \\ + \tilde { t } ( \cdot , \omega ) \colon _ { i , j } \L _ { \infty , i j } C _ { \infty , j i } \cdot _ { \omega , i j } \L _ { \infty , j i } \cdot _ { \omega , i j }
$$

By symmetry, q 2 ( z 2 ) is also Gaussian and can be written as

$$
q _ { 2 } ^ { * } ( z _ { 2 } ) = \mathcal { N } ( z _ { 2 } | m _ { 2 } , \Lambda _ { 2 2 } ^ { - 1 } )
$$

in which

$$
m _ { 2 } = \mu _ { 2 } - \Lambda _ { 2 2 } ^ { - 1 } \Lambda _ { 2 1 } \left ( \mathbb { E } [ z _ { 1 } ] - \mu _ { 1 } \right ) . \\ \\ \intertext { m _ { 2 } = \mu _ { 2 } - \Lambda _ { 2 2 } ^ { - 1 } \Lambda _ { 2 1 } \left ( \mathbb { E } [ z _ { 1 } ] - \mu _ { 1 } \right ) . }
$$

Note that these solutions are coupled, so that q ( z 1 ) depends on expectations computed with respect to q ( z 2 ) and vice versa. In general, we address this by treating the variational solutions as re-estimation equations and cycling through the variables in turn updating them until some convergence criterion is satisﬁed. We shall see an example of this shortly. Here, however, we note that the problem is sufﬁciently simple that a closed form solution can be found. In particular, because E [ z 1 ] = m 1 and E [ z 2 ] = m 2 , we see that the two equations are satisﬁed if we take E [ z 1 ] = µ 1 and E [ z 2 ] = µ 2 , and it is easily shown that this is the only solution provided the distribution is nonsingular. This result is illustrated in Figure 10.2(a). We see that the mean is correctly captured but that the variance of q ( z ) is controlled by the direction of smallest variance of p ( z ) , and that the variance along the orthogonal direction is signiﬁcantly under-estimated. It is a general result that a factorized variational approximation tends to give approximations to the posterior distribution that are too compact.

By way of comparison, suppose instead that we had been minimizing the reverse Kullback-Leibler divergence KL( p q ) . As we shall see, this form of KL divergence
