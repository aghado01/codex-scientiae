[Page 120]

![The image consists of three different diagrams, each with a red line. The line in each diagram is a straight line, and the points on the line are labeled as follows: 1. **Diagram 1**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is located at the top of the line. - Point D is located at the top of the line. 2. **Diagram 2**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is located at the top of the line. - Point D is located at the top of the line. 3. **Diagram 3**: - The line starts at point A and extends to point B. - Point B is located at the bottom of the line. - Point C is](../images/imageFile54.png)

2

2

2

a

=0

.

1

a

= 1

a

= 4

b

=0

.

1

b

= 1

b

= 6

1

1

1

0

0

0

λ

λ

λ

0

1

2

0

1

2

0

1

2

Figure 2.13 Plot of the gamma distribution Gam( λ | a, b ) deﬁned by (2.146) for various values of the parameters a and b .

The corresponding conjugate prior should therefore be proportional to the product of a power of λ and the exponential of a linear function of λ . This corresponds to the gamma distribution which is deﬁned by

$$
G a m ( \lambda | a , b ) = \frac { 1 } { \Gamma ( a ) } b ^ { a } \lambda ^ { a - 1 } \exp ( - b \lambda ) .
$$

Here Γ( a ) is the gamma function that is deﬁned by (1.141) and that ensures that (2.146) is correctly normalized. The gamma distribution has a ﬁnite integral if a > 0 , Exercise 2.41 and the distribution itself is ﬁnite if a 1 . It is plotted, for various values of a and b , in Figure 2.13. The mean and variance of the gamma distribution are given by Exercise 2.42

$$
\mathbb { E } [ \lambda ] \ = \ \frac { a } { b } \quad & & ( 2 . 1 4 7 )
$$

$$
\ v a r [ \lambda ] \ = \ \frac { \ a } { b ^ { 2 } } .
$$

Consider a prior distribution Gam( λ | a 0 ,b 0 ) . If we multiply by the likelihood function (2.145), then we obtain a posterior distribution

$$
\text {function} \left ( 2 . 1 4 5 \right ) , \text {with a position distribution} \\ p ( \lambda | X ) \otimes \lambda ^ { a _ { 0 } - 1 } \lambda ^ { N / 2 } \exp \left \{ - b _ { 0 } \lambda - \frac { \lambda } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right \} \\ \\ \text {which we recognize as a gamma distribution of the form} \text {Gam} ( \lambda | a _ { n } , b _ { n } ) \text { where}
$$

which we recognize as a gamma distribution of the form Gam( λ | a N ,b N ) where

$$
a _ { N } \ = \ a _ { 0 } + \frac { N } { 2 }
$$

$$
b _ { N } \ = \ b _ { 0 } + \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } = b _ { 0 } + \frac { N } { 2 } \sigma _ { M L } ^ { 2 } \quad ( 2 . 1 5 1 ) \\ a _ { 2 } ^ { 2 } \ \text {is the maximum likelihood of the union} \, , \, N \, , \, T \, \text {to } \, a _ { 2 } \, , \, N \, , \, T \, \text {that} \, \text {in} \, ( 2 . 1 4 0 )
$$
