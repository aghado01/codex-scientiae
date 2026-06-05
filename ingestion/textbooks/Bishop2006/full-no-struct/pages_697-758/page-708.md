[Page 708]

![image 345](../images/imageFile345.png)

# Gamma

The Gamma is a probability distribution over a positive random variable τ > 0 governed by parameters a and b that are subject to the constraints a > 0 and b > 0 to ensure that the distribution can be normalized.

$$
\ G a m ( \tau | a , b ) \ = \ \frac { 1 } { \Gamma ( a ) } b ^ { a } \tau ^ { a - 1 } e ^ { - b \tau } & & ( B . 2 6 )
$$

$$
\mathbb { E } [ \tau ] \ = \ \frac { a } { \bar { b } } \quad & & \quad ( B . 2 7 )
$$

$$
\var { v } [ \tau ] \ = \ \frac { a } { b ^ { 2 } } & & ( B . 2 8 )
$$

$$
\mod [ \tau ] \ = \ \frac { a - 1 } { b } \quad \text {for } \alpha \geqslant 1 \\ \mod [ \tau ] \ = \ \frac { a - 1 } { b } \quad \text {for } \alpha \geqslant 1
$$

$$
\mathbb { E } [ \ln \tau ] \ & = \ \psi ( a ) - \ln b & ( B . 3 0 ) \\ \mathbb { H } [ \tau ] \ & = \ \ln \Gamma ( a ) = ( a - 1 ) v ( a ) - \ln b + a & ( B . 3 1 )
$$

$$
H [ \tau ] \ = \ \ln \Gamma ( a ) - ( a - 1 ) \psi ( a ) - \ln b + a
$$

where ψ ( · ) is the digamma function deﬁned by (B.25). The gamma distribution is the conjugate prior for the precision (inverse variance) of a univariate Gaussian. For a 1 the density is everywhere ﬁnite, and the special case of a = 1 is known as the exponential distribution.

![image 346](../images/imageFile346.png)

# Gaussian

The Gaussian is the most widely used distribution for continuous variables. It is also known as the normal distribution. In the case of a single variable x ∈ ( −∞ , ∞ ) it is governed by two parameters, the mean µ ∈ ( −∞ , ∞ ) and the variance σ 2 > 0 .

$$
\mathcal { N } ( x | \mu , \sigma ^ { 2 } ) \ = \ \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } } ( x - \mu ) ^ { 2 } \right \} \\ \mathbb { E } [ x ] \ = \ \mu
$$

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
\ v a r [ x ] \ = \ \sigma ^ { 2 }
$$

$$
\mod [ x ] \ = \ \mu
$$

$$
H [ x ] \ = \ \frac { 1 } { 2 } \ln \sigma ^ { 2 } + \frac { 1 } { 2 } \left ( 1 + \ln ( 2 \pi ) \right ) .
$$

The inverse of the variance τ = 1 /σ 2 is called the precision, and the square root of the variance σ is called the standard deviation. The conjugate prior for µ is the Gaussian, and the conjugate prior for τ is the gamma distribution. If both µ and τ are unknown, their joint conjugate prior is the Gaussian-gamma distribution.

For a D -dimensional vector x , the Gaussian is governed by a D -dimensional mean vector µ and a D × D covariance matrix Σ that must be symmetric and
