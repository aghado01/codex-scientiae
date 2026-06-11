[Page 532]

Exercise 10.37

Exercise 10.38

Exercise 10.39

The factor approximations will therefore take the form of exponential-quadratic functions of the form

f n ( θ ) = s n N ( θ | m n ,v n I ) (10.213) where n = 1 ,...,N , and we set f 0 ( θ ) equal to the prior p ( θ ) . Note that the use of N ( θ |· , · ) does not imply that the right-hand side is a well-deﬁned Gaussian density (in fact, as we shall see, the variance parameter v n can be negative) but is simply a convenient shorthand notation. The approximations f n ( θ ) , for n = 1 ,...,N , can be initialized to unity, corresponding to s n = (2 πv n ) D/ 2 , v n → ∞ and m n = 0 , where D is the dimensionality of x and hence of θ . The initial q ( θ ) , deﬁned by (10.191), is therefore equal to the prior.

We then iteratively reﬁne the factors by taking one factor f n ( θ ) at a time and applying (10.205), (10.206), and (10.207). Note that we do not need to revise the term f 0 ( θ ) because an EP update will leave this term unchanged. Here we state the results and leave the reader to ﬁll in the details.

First we remove the current estimate f n ( θ ) from q ( θ ) by division using (10.205) to give q \ n ( θ ) , which has mean and inverse variance given by m \ n = m + v \ n v − 1 ( m m n ) (10.214)

$$
\mathbf m ^ { \langle n } \ = \ \mathbf m + v ^ { \langle n } v _ { n } ^ { - 1 } ( \mathbf m - \mathbf m _ { n } ) \quad & ( 1 0 . 2 1 4 ) \\ ( v _ { n } ) ^ { \langle n } - 1 \ = \ v ^ { - 1 } \ v _ { n } ^ { - 1 } \ v ^ { - 1 } \quad & ( 1 0 . 2 1 5 )
$$

$$
( v ^ { \wedge n } ) ^ { - 1 } \ = \ v ^ { - 1 } - v _ { n } ^ { - 1 } .
$$

Next we evaluate the normalization constant Z n using (10.206) to give

$$
Z _ { n } = ( 1 - w ) \mathcal { N } ( x _ { n } | \mathbf m ^ { \ \langle n \, } , ( v ^ { \ \langle n \, } + 1 ) I ) + w \mathcal { N } ( x _ { n } | 0 , a I ) . \quad \\
$$

Similarly, we compute the mean and variance of q new ( θ ) by ﬁnding the mean and variance of q \ n ( θ ) f n ( θ ) to give

$$
m \ = \ m ^ { \wedge n } + \rho _ { n } \frac { v ^ { \wedge n } } { v ^ { \wedge n } + 1 } ( x _ { n } - m ^ { \wedge n } ) \\
$$

$$
v \ = \ v ^ { \langle n } - \rho _ { n } \frac { ( v ^ { \langle n } ) ^ { 2 } } { v ^ { \langle n } + 1 } + \rho _ { n } ( 1 - \rho _ { n } ) \frac { ( v ^ { \langle n } ) ^ { 2 } \| x _ { n } - \mathbf m ^ { \langle n } \| ^ { 2 } } { D ( v ^ { \langle n } + 1 ) ^ { 2 } } \ \ ( 1 0 . 2 1 8 )
$$

where the quantity

$$
\rho _ { n } = 1 - \frac { w } { Z _ { n } } \mathcal { N } ( x _ { n } | 0 , a \mathbf I )
$$

has a simple interpretation as the probability of the point x n not being clutter. Then we use (10.207) to compute the reﬁned factor f n ( θ ) whose parameters are given by

$$
s \ a \, \text {simple interpretation as the probability of the point } x _ { n } \, \text {hot being checker.} \\ \text {use } ( 1 0 . 2 7 ) \, \text {to compute the refined factor } \widetilde { f } _ { n } ( \theta ) \, \text { whose parameters are given by} \\ v _ { n } ^ { - 1 } \ = \ ( v ^ { \text {new} } ) ^ { - 1 } - ( v ^ { \text {n} } ) ^ { - 1 } & & ( 1 0 . 2 2 0 ) \\ m _ { n } \ = \ m ^ { \text {n} } + ( v _ { n } + v ^ { \text {n} } ) ( v ^ { \text {n} } ) ^ { - 1 } ( m ^ { \text {new} } - m ^ { \text {n} } ) & & ( 1 0 . 2 2 1 )
$$

$$
\mathbf m _ { n } \ = \ \mathbf m ^ { \langle n } + ( v _ { n } + v ^ { \langle n } ) ( v ^ { \langle n } ) ^ { - 1 } ( \mathbf m ^ { n e w } - \mathbf m ^ { \langle n } ) \quad ( 1 0 . 2 2 1 ) \\ Z _ { n }
$$

$$
s _ { n } \ = \ \frac { Z _ { n } } { ( 2 \pi v _ { n } ) ^ { D / 2 } \mathcal { N } ( m _ { n } | m ^ { \vee } , ( v _ { n } + v ^ { \vee } ) I ) } . \\ \intertext { s i n g o n t p o r s i n o t o d u t i l o s u i t i o n g t a m p e r i o n i s e t i f f o d }
$$

This reﬁnement process is repeated until a suitable termination criterion is satisﬁed, for instance that the maximum change in parameter values resulting from a complete
