[Page 154]

distribution, by starting with the maximum likelihood expression

$$
\sigma _ { M L } ^ { 2 } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } . \\ \intertext { t i n g t h e x p r e s s } \text {using the expression for a Gaussian distribution into the R o bins} \
$$

Verify that substituting the expression for a Gaussian distribution into the RobbinsMonro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients a N .

2.37 ( ) Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the covariance of a multivariate Gaussian distribution, by starting with the maximum likelihood expression (2.122). Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients a N .

2.38 ( ) Use the technique of completing the square for the quadratic form in the exponent to derive the results (2.141) and (2.142).

2.39 ( ) Starting from the results (2.141) and (2.142) for the posterior distribution of the mean of a Gaussian random variable, dissect out the contributions from the ﬁrst N − 1 data points and hence obtain expressions for the sequential update of µ N and σ 2 N . Now derive the same results starting from the posterior distribution p ( µ | x 1 ,...,x N − 1 ) = N ( µ | µ N − 1 ,σ 2 N − 1 ) and multiplying by the likelihood function p ( x N | µ ) = N ( x N | µ,σ 2 ) and then completing the square and normalizing to obtain the posterior distribution after N observations.

2.40 ( ) www Consider a D -dimensional Gaussian random variable x with distribution N ( x | µ , Σ ) in which the covariance Σ is known and for which we wish to infer the mean µ from a set of observations X = { x 1 ,..., x N } . Given a prior distribution p ( µ ) = N ( µ | µ 0 , Σ 0 ) , ﬁnd the corresponding posterior distribution p ( µ | X ) .

2.41 ( ) Use the deﬁnition of the gamma function (1.141) to show that the gamma distribution (2.146) is normalized.

2.42 ( ) Evaluate the mean, variance, and mode of the gamma distribution (2.146).

2.43 ( ) The following distribution

$$
p ( x | \sigma ^ { 2 } , q ) = \frac { q } { 2 ( 2 \sigma ^ { 2 } ) ^ { 1 / q } \Gamma ( 1 / q ) } \exp \left ( - \frac { | x | ^ { q } } { 2 \sigma ^ { 2 } } \right ) \quad ( 2 . 2 9 3 ) \\ \intertext { o r l i z i o n } p ( x | \sigma ^ { 2 } , q ) = \frac { q } { 2 ( 2 \sigma ^ { 2 } ) ^ { 1 / q } \Gamma ( 1 / q ) } \exp \left ( - \frac { | x | ^ { q } } { 2 \sigma ^ { 2 } } \right ) \quad ( 2 . 2 9 3 ) \\
$$

is a generalization of the univariate Gaussian distribution. Show that this distribution is normalized so that ∞

$$
\int _ { - \infty } ^ { \infty } p ( x | \sigma ^ { 2 } , q ) \, d x & = 1 \\ \intertext { o } \int _ { - \infty } ^ { \infty } p ( x | \sigma ^ { 2 } , q ) \, d x & = 2 . \ \text { Consider a regression model in}
$$

and that it reduces to the Gaussian when q = 2 . Consider a regression model in which the target variable is given by t = y ( x , w ) + and is a random noise
