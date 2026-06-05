[Page 713]

![image 350](../images/imageFile350.png)

# Von Mises

The von Mises distribution, also known as the circular normal or the circular Gaussian, is a univariate Gaussian-like periodic distribution for a variable θ ∈ [0 , 2 π ) .

$$
p ( \theta | \theta _ { 0 } , m ) \ = \ \frac { 1 } { 2 \pi I _ { 0 } ( m ) } \exp \left \{ m \cos ( \theta - \theta _ { 0 } ) \right \}
$$

where I 0 ( m ) is the zeroth-order Bessel function of the ﬁrst kind. The distribution has period 2 π so that p ( θ + 2 π ) = p ( θ ) for all θ . Care must be taken in interpreting this distribution because simple expectations will be dependent on the (arbitrary) choice of origin for the variable θ . The parameter θ 0 is analogous to the mean of a univariate Gaussian, and the parameter m > 0 , known as the concentration parameter, is analogous to the precision (inverse variance). For large m , the von Mises distribution is approximately a Gaussian centred on θ 0 .

# Wishart

The Wishart distribution is the conjugate prior for the precision matrix of a multivariate Gaussian.

$$
\text {variate Gaussian} . \\ \mathcal { W } ( \Lambda | W , \nu ) = B ( W , \nu ) | \Lambda | ^ { ( \nu - D - 1 ) / 2 } \exp \left ( - \frac { 1 } { 2 } T r ( W ^ { - 1 } \Lambda ) \right ) \\
$$

where

) )

(

(

-

1

D

∏

-

ν

-

i

-

-

ν/

νD/ 2

D

D

/

2

2

(

1.

4

≡

|

|

2

π

Γ

B

(

,ν )

)

(B.79)

2

W

W

i

=1

$$
\mathbb { E } [ \Lambda ] \ = \ \nu W
$$

$$
\mathbb { E } [ \Lambda ] \ & = \ \nu W \\ \mathbb { E } \left [ \ln | \Lambda | \right ] \ & = \ \sum _ { i = 1 } ^ { D } \psi \left ( \frac { \nu + 1 - i } { 2 } \right ) + D \ln 2 + \ln | W | \\ \\ H [ \Lambda ] \ & = \ \sum _ { i = 1 } ^ { D } B ( W _ { i } \, \mu ) \, \frac { ( \nu - D - 1 ) } { } \mathbb { F } \left [ \ln | \Lambda | \right ] + \frac { \nu D } { } \\
$$

$$
H [ \Lambda ] \ = \ - \ln B ( W , \nu ) - \frac { ( \nu - D - 1 ) } { 2 } \mathbb { E } \left [ \ln | \Lambda | \right ] + \frac { \nu D } { 2 } \quad ( B . 8 2 )
$$

where W is a D × D symmetric, positive deﬁnite matrix, and ψ ( · ) is the digamma function deﬁned by (B.25). The parameter ν is called the number of degrees of freedom of the distribution and is restricted to ν > D − 1 to ensure that the Gamma function in the normalization factor is well-deﬁned. In one dimension, the Wishart reduces to the gamma distribution Gam( λ | a,b ) given by (B.26) with parameters a = ν/ 2 and b = 1 / 2 W .
