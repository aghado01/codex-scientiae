[Page 712]

$$
S t ( x | \mu , \lambda , \nu ) \ = \ \frac { \Gamma ( \nu / 2 + 1 / 2 ) } { \Gamma ( \nu / 2 ) } \left ( \frac { \lambda } { \pi \nu } \right ) ^ { 1 / 2 } \left [ 1 + \frac { \lambda ( x - \mu ) ^ { 2 } } { \nu } \right ] ^ { - \nu / 2 - 1 / 2 } \quad ( B . 6 4 ) \\ \mathbb { E } [ x ] \ = \ \mu \quad \text {for } \nu > 1
$$

$$
\mathbb { E } [ x ] \ = \ \mu \quad \text {for } \nu > 1
$$

$$
[ ] & = \frac { 1 } { \lambda } \frac { \nu } { \nu - 2 } \quad \text {for } \nu > 2 \\ \text {mode} [ x ] & \ = \ \mu .
$$

$$
\mod [ x ] \ = \ \mu .
$$

Here ν > 0 is called the number of degrees of freedom of the distribution. The particular case of ν = 1 is called the Cauchy distribution.

For a D -dimensional variable x , Student’s t-distribution corresponds to marginalizing the precision matrix of a multivariate Gaussian with respect to a conjugate Wishart prior and takes the form

$$
S t ( x | \mu , \Lambda , \nu ) \ & = \ \frac { \Gamma ( \nu / 2 + D / 2 ) } { \Gamma ( \nu / 2 ) } \frac { | \Lambda | ^ { 1 / 2 } } { ( \nu \pi ) ^ { D / 2 } } \left [ 1 + \frac { \Delta ^ { 2 } } { \nu } \right ] ^ { - \nu / 2 - D / 2 } \\ \mathbb { E } [ x ] & \ = \ \mu \quad \text {for } \nu > 1
$$

$$
\mathbb { E } [ x ] \ = \ \mu \quad \text {for } \nu > 1
$$

$$
\mathbb { E } [ x ] & = \mu ^ { \nu } \text { for } \nu > 1 \\ \text {cov} [ x ] & = \frac { \nu } { \nu - 2 } \Lambda ^ { - 1 } \quad \text {for } \nu > 2 \\ \text {mode} [ x ] & = \mu
$$

$$
\mod [ x ] \ = \ \mu
$$

where ∆ 2 is the squared Mahalanobis distance deﬁned by

$$
\Delta ^ { 2 } = ( x - \mu ) ^ { \text {T} } \Lambda ( x - \mu ) .
$$

In the limit ν → ∞ , the t-distribution reduces to a Gaussian with mean µ and precision Λ . Student’s t-distribution provides a generalization of the Gaussian whose maximum likelihood parameter values are robust to outliers.

![image 349](../images/imageFile349.png)

# Uniform

This is a simple distribution for a continuous variable x deﬁned over a ﬁnite interval x ∈ [ a,b ] where b > a .

$$
U ( x | a , b ) \ = \ \frac { 1 } { b - a } & & ( B . 7 3 ) \\ \mathbb { F } [ a ] & & ( b + a )
$$

$$
\mathbb { E } [ x ] \ = \ \frac { ( b + a ) } { 2 } \quad \\
$$

$$
\var { v } [ x ] \ = \ \frac { ( b - a ) ^ { 2 } } { 1 2 } & & ( B . 7 5 ) \\
$$

$$
H [ x ] \ = \ \ln ( b - a ) .
$$

If x has distribution U( x | 0 , 1) , then a + ( b − a ) x will have distribution U( x | a,b ) .
