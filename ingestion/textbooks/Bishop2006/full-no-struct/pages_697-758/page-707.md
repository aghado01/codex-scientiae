[Page 707]

![image 53](../images/imageFile53.png)

# Dirichlet

The Dirichlet is a multivariate distribution over K random variables 0 µ k 1 , where k = 1 ,...,K , subject to the constraints

$$
0 \leqslant \mu _ { k } \leqslant 1 , \quad \sum _ { k = 1 } ^ { K } \mu _ { k } = 1 . \\
$$

Denoting µ = ( µ 1 ,...,µ K ) T and α = ( α 1 ,...,α K ) T , we have

$$
D i r ( \mu | \alpha ) \ = \ C ( \alpha ) \prod _ { k = 1 } ^ { K } \mu _ { k } ^ { \alpha _ { k } - 1 } \\ \mathbb { E } [ \mu _ { k } ] \ = \ \frac { \alpha _ { k } } { \alpha } \, \Lambda _ { k }
$$

$$
\mathbb { E } [ \mu _ { k } ] \ = \ \frac { \alpha _ { k } } { \widehat { \alpha } } \sum _ { \substack { ( \widehat { \alpha } ) \\ ( \widehat { \beta } ) } } ^ { \infty } \, \Omega ( 1 - 1 )
$$

$$
\mathbb { E } [ \mu _ { k } ] \ & = \ \frac { \alpha _ { k } } { \widehat { \alpha } } \\ \quad & \quad \ \varbar { \alpha } [ \mu _ { k } ] \ = \ \frac { \alpha _ { k } ( \widehat { \alpha } - \alpha _ { k } ) } { \widehat { \alpha } ^ { 2 } ( \widehat { \alpha } + 1 ) } \\ \quad & \quad \ \cot [ \mu _ { j } \mu _ { k } ] \ = \ - \frac { \alpha _ { j } \alpha _ { k } } { \widehat { \alpha } ^ { 2 } ( \widehat { \alpha } + 1 ) }
$$

$$
\var { r } [ \mu _ { k } ] & = \ \frac { \alpha ^ { k } ( \alpha ^ { \sigma } + \alpha ^ { k } ) } { \widehat { \alpha } ^ { 2 } ( \widehat { \alpha } + 1 ) } \\ \cot [ \mu _ { j } \mu _ { k } ] & = \ - \frac { \alpha _ { j } \alpha _ { k } } { \widehat { \alpha } ^ { 2 } ( \widehat { \alpha } + 1 ) } \\ & = \ \alpha _ { k } - 1
$$

$$
\begin{array} { l c l } & & \text {cov} [ \mu _ { j } \mu _ { k } ] & = & - \frac { } { \widehat { \alpha } ^ { 2 } ( \widehat { \alpha } + 1 ) } \\ & & \\ & \text {mode} [ \mu _ { k } ] & = & \frac { \alpha _ { k } - 1 } { \widehat { \alpha } - K } \\ & & \mathbb { E } [ \ln \mu _ { k } ] & = & \psi ( \alpha _ { k } ) - \psi ( \widehat { \alpha } ) \end{array} \quad ( B . 1 )
$$

$$
\mod [ \mu _ { k } ] \ & = \ \frac { \alpha ^ { k } } { \widehat { \alpha } - K } \\ \mathbb { E } [ \ln \mu _ { k } ] \ & = \ \psi ( \alpha _ { k } ) - \psi ( \widehat { \alpha } ) \\ \\ H [ \mu ] \ & = \ - \sum _ { k } ^ { K } ( \alpha _ { k } - 1 ) \left \{ \psi ( \alpha _ { k } ) - \psi ( \widehat { \alpha } ) \right \} - \ln C ( \alpha )
$$

$$
\mathbb { E } [ \ln \mu _ { k } ] \ & = \ \psi ( \alpha _ { k } ) - \psi ( \widehat { \alpha } ) \\ H [ \mu ] \ & = \ - \sum _ { k = 1 } ^ { K } ( \alpha _ { k } - 1 ) \left \{ \psi ( \alpha _ { k } ) - \psi ( \widehat { \alpha } ) \right \} - \ln C ( \alpha ) \\ \intertext { r e } C ( \alpha _ { k } ) - \intertext { s u p l a r } \mathbb { E } ( B )
$$

where

$$
C ( \alpha ) = \frac { \Gamma ( \widehat { \alpha } ) } { \Gamma ( \alpha _ { 1 } ) \cdots \Gamma ( \alpha _ { K } ) } & & ( B . 2 3 ) \\
$$

and

$$
\widehat { \alpha } = \sum _ { k = 1 } ^ { K } \alpha _ { k } . \\ \\ \psi ( a ) = \frac { d } { } \ln \Gamma ( a )
$$

Here

$$
\psi ( a ) & \equiv \frac { d } { d a } \ln \Gamma ( a ) & ( B . 2 5 ) \\
$$

is known as the digamma function (Abramowitz and Stegun, 1965). The parameters α k are subject to the constraint α k > 0 in order to ensure that the distribution can be normalized.

The Dirichlet forms the conjugate prior for the multinomial distribution and represents a generalization of the beta distribution. In this case, the parameters α k can be interpreted as effective numbers of observations of the corresponding values of the K -dimensional binary observation vector x . As with the beta distribution, the Dirichlet has ﬁnite density everywhere provided α k 1 for all k .
