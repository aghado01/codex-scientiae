[Page 709]

$$
\text {positive-demin.} \\ \mathcal { N } ( x | \mu , \Sigma ) \ = \ \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} ( B . 3 7 ) \\ \mathbb { E } [ x ] \ = \ \mu
$$

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
c o v [ x ] \ = \ \Sigma
$$

$$
\mod [ x ] \ = \ \mu
$$

$$
H [ x ] \ = \ \frac { 1 } { 2 } \ln | \Sigma | + \frac { D } { 2 } \left ( 1 + \ln ( 2 \pi ) \right ) .
$$

The inverse of the covariance matrix Λ = Σ − 1 is the precision matrix, which is also symmetric and positive deﬁnite. Averages of random variables tend to a Gaussian, by the central limit theorem, and the sum of two Gaussian variables is again Gaussian. The Gaussian is the distribution that maximizes the entropy for a given variance (or covariance). Any linear transformation of a Gaussian random variable is again Gaussian. The marginal distribution of a multivariate Gaussian with respect to a subset of the variables is itself Gaussian, and similarly the conditional distribution is also Gaussian. The conjugate prior for µ is the Gaussian, the conjugate prior for Λ is the Wishart, and the conjugate prior for ( µ , Λ ) is the Gaussian-Wishart.

If we have a marginal Gaussian distribution for x and a conditional Gaussian distribution for y given x in the form

$$
\begin{array} { c c c } p ( x ) & = & \mathcal { N } ( x | \mu , \Lambda ^ { - 1 } ) & & ( B . 4 2 ) \\ p ( x | x ) & = & \mathcal { N } ( x | A x + b \ L ^ { - 1 } ) & & ( B . 4 3 ) \end{array}
$$

$$
p ( y | x ) \ = \ \mathcal { N } ( y | A x + b , L ^ { - 1 } ) \\ \\ \ t w _ { 0 } \ t w _ { 1 } = \ \mathcal { N } ( y | A x + b , L ^ { - 1 } )
$$

then the marginal distribution of y , and the conditional distribution of x given y , are given by

$$
\begin{array} { r c l } p ( y ) & = & \mathcal { N } ( y | A \mu + b , L ^ { - 1 } + A \Lambda ^ { - 1 } A ^ { T } ) \\ p ( x | y ) & = & \mathcal { N } ( x | \Sigma \{ A ^ { T } L ( y - b ) + \Lambda \mu \} \ \Sigma ) \end{array}
$$

$$
p ( x | y ) \ = \ \mathcal { N } ( x | \Sigma \{ A ^ { \top } L ( y - b ) + \Lambda \mu \} , \Sigma )
$$

where

$$
\Sigma = ( \Lambda + A ^ { T } L A ) ^ { - 1 } .
$$

If we have a joint Gaussian distribution N ( x | µ , Σ ) with Λ ≡ Σ − 1 and we deﬁne the following partitions

$$
x & = \begin{pmatrix} x _ { a } \\ x _ { b } \end{pmatrix} , \quad \mu = \begin{pmatrix} \mu _ { a } \\ \mu _ { b } \end{pmatrix} \\
$$

$$
\Sigma = \begin{pmatrix} \Sigma _ { a a } & \Sigma _ { a b } \\ \Sigma _ { b a } & \Sigma _ { b b } \end{pmatrix} , \quad \Lambda = \begin{pmatrix} \Lambda _ { a a } & \Lambda _ { a b } \\ \Lambda _ { b a } & \Lambda _ { b b } \end{pmatrix} \\ \text {conditional distribution} \, p ( x _ { a } | x _ { b } ) \, \text {is given by}
$$

then the conditional distribution p ( x a | x b ) is given by 1

$$
p ( x _ { a } | x _ { b } ) \ = \ \mathcal { N } ( x | \mu _ { a | b } , \Lambda _ { a a } ^ { - 1 } ) \\ \\
$$

$$
\mu _ { a | b } \ = \ \mu _ { a } - \Lambda _ { a a } ^ { - 1 } \Lambda _ { a b } ( x _ { b } - \mu _ { b } )
$$
