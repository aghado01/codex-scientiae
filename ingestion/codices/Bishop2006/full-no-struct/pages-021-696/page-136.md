[Page 136]

which, after some simple rearrangement, can be cast in the standard exponential family form (2.194) with Exercise 2.57

$$
\eta \ = \ \left ( \begin{matrix} \mu / \sigma ^ { 2 } \\ - 1 / 2 \sigma ^ { 2 } \end{matrix} \right ) & & ( 2 . 2 0 ) \\ \intertext { \eta \ = \ } \left ( \begin{matrix} x \\ x \end{matrix} \right ) & &
$$

$$
u ( x ) \ = \ \begin{pmatrix} - 1 / 2 \sigma ^ { 2 } \end{pmatrix} & & ( - 1 / 2 \sigma ^ { 2 } ) \\ u ( x ) \ = \ \begin{pmatrix} x \\ x ^ { 2 } \end{pmatrix} & & ( 2 . 2 2 1 ) \\ h ( x ) \ = \ ( 2 \pi ) ^ { - 1 / 2 } & & ( 2 . 2 2 2 )
$$

$$
h ( \mathbf x ) \ = \ ( 2 \pi ) ^ { - 1 / 2 }
$$

$$
h ( x ) \ & = \ ( 2 \pi ) ^ { - 1 / 2 } & & ( 2 . 2 2 ) \\ g ( \eta ) \ & = \ ( - 2 \eta _ { 2 } ) ^ { 1 / 2 } \exp \left ( \frac { \eta _ { 1 } ^ { 2 } } { 4 \eta _ { 2 } } \right ) . & & ( 2 . 2 3 ) \\ \intertext { w i m u m o w l i k l i b o w l d e f u i t i o n t a t i o t i o n }
$$

# 2.4.1 Maximum likelihood and sufﬁcient statistics

Let us now consider the problem of estimating the parameter vector η in the general exponential family distribution (2.194) using the technique of maximum likelihood. Taking the gradient of both sides of (2.195) with respect to η , we have

$$
\text {Taking the gradient of both sides of (2.195) with respect to \eta, we have} \\ \nabla g ( \eta ) \int h ( x ) \exp \left \{ \eta ^ { \top } u ( x ) \right \} \, d x \\ + \ g ( \eta ) \int h ( x ) \exp \left \{ \eta ^ { \top } u ( x ) \right \} u ( x ) \, d x = 0 . \\ \text {ranging, and making use again of (2.195) then gives}
$$

Rearranging, and making use again of (2.195) then gives

$$
R e a r r a n g i g , & \text { and making use again of } ( 2 . 1 9 ) \text { then gives} \\ & - \frac { 1 } { g ( \eta ) } \nabla g ( \eta ) = g ( \eta ) \int h ( x ) \exp \left \{ \eta ^ { T } u ( x ) \right \} u ( x ) \, d x = \mathbb { E } [ u ( x ) ] \quad ( 2 . 2 2 5 ) \\ \text {where we have used } ( 2 . 1 9 4 ) . \text { We therefore obtain the result}
$$

where we have used (2.194). We therefore obtain the result

# Exercise 2.58

$$
- \nabla \ln g ( \eta ) = \mathbb { E } [ u ( x ) ] . \\
$$

Note that the covariance of u ( x ) can be expressed in terms of the second derivatives of g ( η ) , and similarly for higher order moments. Thus, provided we can normalize a distribution from the exponential family, we can always ﬁnd its moments by simple differentiation.

Now consider a set of independent identically distributed data denoted by X = { x 1 ,..., x n } , for which the likelihood function is given by

$$
\{ x _ { 1 } , \dots , x _ { n } \} , \text { for } \text { when the inner function is given by } \\ p ( X | \eta ) = \left ( \prod _ { n = 1 } ^ { N } h ( x _ { n } ) \right ) g ( \eta ) ^ { N } \exp \left \{ \eta ^ { T } \sum _ { n = 1 } ^ { N } u ( x _ { n } ) \right \} . \\ \text {Setting the gradient of } \text { in } p ( X | \eta ) \text { with respect to } \eta \text { to zero, we get the following }
$$

Setting the gradient of ln p ( X | η ) with respect to η to zero, we get the following condition to be satisﬁed by the maximum likelihood estimator η ML

$$
- \nabla \ln g ( \eta _ { M L } ) = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \mathbf u ( x _ { n } )
$$
