[Page 45]

Figure 1.13 Plot of the univariate Gaussian showing the mean µ and the standard deviation σ .

![The image is a graph titled Vocals and it is a line graph. The graph has a horizontal axis labeled N and a vertical axis labeled O(r,r^2). The graph shows a horizontal line that starts at the point (0,0) and extends upwards to the right. The line then starts at the point (20,0) and extends upwards to the right. The line then starts at the point (0,0) and extends upwards to the right again. The line then starts at the point (0,0) and extends upwards to the right again. The line then starts at the point (0,0) and extends upwards to the right again. The line then starts at the point (0,0) and extends upwards to the right again. The line then starts at the point (0,0) and extends upwards to the right again. The line then starts at the point (0,0) and extends upwards](../images/imageFile18.png)

2

N

|

(

x

µ,σ 2

)

2

σ

x

µ

# Exercise 1.8

# Exercise 1.9

$$
\int _ { - \infty } ^ { \infty } \mathcal { N } \left ( x | \mu , \sigma ^ { 2 } \right ) \, d x = 1 . \\ \intertext { s t w o r i u r e m e n t s for a valid probability density }
$$

Thus (1.46) satisﬁes the two requirements for a valid probability density.

We can readily ﬁnd expectations of functions of x under the Gaussian distribution. In particular, the average value of x is given by

$$
\mathbb { E } [ x ] & = \int _ { - \infty } ^ { \infty } \mathcal { N } \left ( x | \mu , \sigma ^ { 2 } \right ) x \, d x = \mu . \\ \intertext { a r $ p $ r e p r e s $ \mu $ r e p r e s $ the a v e rage $ value of $ x $ u r d e r $ the distribution, $ it $ }
$$

Because the parameter µ represents the average value of x under the distribution, it is referred to as the mean. Similarly, for the second order moment

$$
\mathbb { E } [ x ^ { 2 } ] & = \int _ { - \infty } ^ { \infty } \mathcal { N } \left ( x | \mu , \sigma ^ { 2 } \right ) x ^ { 2 } \, d x = \mu ^ { 2 } + \sigma ^ { 2 } . \\ . . & \, \text { and } ( 1 . 5 0 ) , \, \text { it follows that the variance of } x \text { is given by }
$$

From (1.49) and (1.50), it follows that the variance of x is given by

$$
v a r [ x ] = \mathbb { E } [ x ^ { 2 } ] - \mathbb { E } [ x ] ^ { 2 } = \sigma ^ { 2 }
$$

and hence σ 2 is referred to as the variance parameter. The maximum of a distribution is known as its mode. For a Gaussian, the mode coincides with the mean.

We are also interested in the Gaussian distribution deﬁned over a D -dimensional vector x of continuous variables, which is given by

$$
\text {vector of coordinates} \, \forall \, \text {a} \, \text {a} , \, \text {where} \, \intertext { \mathcal { N } ( x | \mu , \Sigma ) = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} } \\ \text {where} \, \intertext { \mathcal { W } ( x | \mu , \Sigma ) = \frac { 1 } { ( 2 \pi ) ^ { D } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} }
$$

where the D -dimensional vector µ is called the mean, the D × D matrix Σ is called the covariance, and | Σ | denotes the determinant of Σ . We shall make use of the multivariate Gaussian distribution brieﬂy in this chapter, although its properties will be studied in detail in Section 2.3.
