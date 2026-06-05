[Page 490]

Exercise 10.6

Section 2.3.6

Exercise 2.44

of divergences (Ali and Silvey, 1966; Amari, 1985; Minka, 2005) deﬁned by

$$
0 \, \text { and } \, & \sin ( 1 + \sin ( y ) , 1 ) , 2 , 1 , \sin ( x ) , 2 \, \text { and } \, 0 \, \text { by } \\ & D _ { \alpha } ( p | | q ) = \frac { 4 } { 1 - \alpha ^ { 2 } } \left ( 1 - \int p ( x ) ^ { ( 1 + \alpha ) / 2 } q ( x ) ^ { ( 1 - \alpha ) / 2 } \, d x \right ) \\ & \text {where } \, \alpha \, \leq \, \alpha \, \cdot \, \sin \alpha \, \text { among } \, \text { The } \, K \, \text {wall} \, \text { such } \, \text { light} \, \text { div $n$} \, \text { divergence} \, \text { } \\
$$

where −∞ < α < ∞ is a continuous parameter. The Kullback-Leibler divergence KL( p q ) corresponds to the limit α → 1 , whereas KL( q p ) corresponds to the limit α → − 1 . For all values of α we have D α ( p q ) 0 , with equality if, and only if, p ( x ) = q ( x ) . Suppose p ( x ) is a ﬁxed distribution, and we minimize D α ( p q ) with respect to some set of distributions q ( x ) . Then for α − 1 the divergence is zero forcing , so that any values of x for which p ( x ) = 0 will have q ( x ) = 0 , and typically q ( x ) will under-estimate the support of p ( x ) and will tend to seek the mode with the largest mass. Conversely for α 1 the divergence is zero-avoiding , so that values of x for which p ( x ) > 0 will have q ( x ) > 0 , and typically q ( x ) will stretch to cover all of p ( x ) , and will over-estimate the support of p ( x ) . When α = 0 we obtain a symmetric divergence that is linearly related to the Hellinger distance given by

$$
\text {degree that is nearly related to the Heller integer distance given by} \\ D _ { H } ( p | | q ) = \int \left ( p ( x ) ^ { 1 / 2 } - q ( x ) ^ { 1 / 2 } \right ) \, d x . \\ \intertext { o r t o f the Hellinger distance is a valid distance metric. }
$$

The square root of the Hellinger distance is a valid distance metric.

# 10.1.3 Example: The univariate Gaussian

We now illustrate the factorized variational approximation using a Gaussian distribution over a single variable x (MacKay, 2003). Our goal is to infer the posterior distribution for the mean µ and precision τ , given a data set D = { x 1 ,...,x N } of observed values of x which are assumed to be drawn independently from the Gaussian. The likelihood function is given by

$$
p ( \mathcal { D } | \mu , \tau ) = \left ( \frac { \tau } { 2 \pi } \right ) ^ { N / 2 } \exp \left \{ - \frac { \tau } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right \} .
$$

We now introduce conjugate prior distributions for µ and τ given by

$$
\ p ( \mu | \tau ) \ & = \ \mathcal { N } \left ( \mu | \mu _ { 0 } , ( \lambda _ { 0 } \tau ) ^ { - 1 } \right ) \\ \ p ( \tau ) \ & = \ \ G a m ( \tau | a _ { 0 } , b _ { 0 } ) \\
$$

where Gam( τ | a 0 ,b 0 ) is the gamma distribution deﬁned by (2.146). Together these distributions constitute a Gaussian-Gamma conjugate prior distribution.

For this simple problem the posterior distribution can be found exactly, and again takes the form of a Gaussian-gamma distribution. However, for tutorial purposes we will consider a factorized variational approximation to the posterior distribution given by

$$
q ( \mu , \tau ) = q _ { \mu } ( \mu ) q _ { \tau } ( \tau ) .
$$
