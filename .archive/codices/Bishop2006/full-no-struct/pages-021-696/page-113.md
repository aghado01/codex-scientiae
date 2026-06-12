[Page 113]

Appendix C

# Marginal and Conditional Gaussians

Given a marginal Gaussian distribution for x and a conditional Gaussian distribution for y given x in the form

$$
\begin{array} { c c c } p ( x ) & = & \mathcal { N } ( x | \mu , \Lambda ^ { - 1 } ) & & ( 2 . 1 1 3 ) \\ p ( x | x ) & = & \mathcal { N } ( x | A x + b \, I _ { 1 } ^ { - 1 } ) & & ( 2 . 1 1 4 ) \end{array}
$$

$$
p ( y | x ) \ = \ \mathcal { N } ( y | A x + b , L ^ { - 1 } ) \quad & ( 2 . 1 1 4 )
$$

the marginal distribution of y and the conditional distribution of x given y are given by

where

$$
\begin{array} { r c l } p ( y ) & = & \mathcal { N } ( y | A \mu + b , L ^ { - 1 } + A \Lambda ^ { - 1 } A ^ { T } ) & & ( 2 . 1 1 5 ) \\ p ( x | y ) & = & \mathcal { N } ( x | \Sigma \{ A ^ { T } L ( y - b ) + \Lambda \mu \} \, \Sigma ) & & ( 2 . 1 1 6 ) \end{array}
$$

$$
p ( x | y ) \ = \ \mathcal { N } ( x | \Sigma \{ A ^ { \top } L ( y - b ) + \Lambda \mu \} , \Sigma )
$$

$$
\Sigma = ( \Lambda + A ^ { \top } L A ) ^ { - 1 } .
$$

# 2.3.4 Maximum likelihood for the Gaussian

Given a data set X = ( x 1 ,..., x N ) T in which the observations { x n } are assumed to be drawn independently from a multivariate Gaussian distribution, we can estimate the parameters of the distribution by maximum likelihood. The log likelihood function is given by

$$
\ln p ( X | \mu , \Sigma ) = - \frac { N D } { 2 } \ln ( 2 \pi ) - \frac { N } { 2 } \ln | \Sigma | - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { T } \Sigma ^ { - 1 } ( x _ { n } - \mu ) . \ ( 2 . 1 1 8 ) \\ \\ \text {By simple rearrangement, we see that the likelihood function depends on the data set}
$$

By simple rearrangement, we see that the likelihood function depends on the data set only through the two quantities

$$
\sum _ { n = 1 } ^ { N } x _ { n } , & & \sum _ { n = 1 } ^ { N } x _ { n } x _ { n } ^ { T } . & & ( 2 . 1 1 9 ) \\ \intertext { w n a s t h e s t i c i t s } \intertext { w n a s t i c i t s for t h e Gaussian distribution }
$$

These are known as the sufﬁcient statistics for the Gaussian distribution. Using (C.19), the derivative of the log likelihood with respect to µ is given by

$$
\frac { \partial } { \partial \mu } \ln p ( X | \mu , \Sigma ) = \sum _ { n = 1 } ^ { N } \Sigma ^ { - 1 } ( x _ { n } - \mu ) \quad ( 2 . 1 2 0 ) \\ \intertext { t h i s d e r i v i t a v e t o r } \intertext { i n t h i s d e r i v i t a v e t o r } \intertext { e x t h i s d e r i v i t a v e t o r }
$$

and setting this derivative to zero, we obtain the solution for the maximum likelihood estimate of the mean given by

$$
\mu _ { M L } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n }
$$
