[Page 348]

does not depend on n . Direct solution of this optimization problem would be very complex, and so we shall convert it into an equivalent problem that is much easier to solve. To do this we note that if we make the rescaling w → κ w and b → κb , then the distance from any point x n to the decision surface, given by t n y ( x n ) / w , is unchanged. We can use this freedom to set

$$
\int \lim i t s _ { \ } r e e d o m \int \lim i t s _ { \ } r e e d o m & \int \lim i t s _ { n } \int \lim i t s _ { n } \int \lim i t s _ { n } \\ t _ { n } \left ( w ^ { T } \phi ( x _ { n } ) + b \right ) & = 1 \\ \intertext { c o n s t o t h s c r . I n f u s c a , a l l $ d a t i o n $ w i l l s a s i f y $ t h e r }
$$

for the point that is closest to the surface. In this case, all data points will satisfy the constraints T

t n w φ ( x n ) + b 1 , n = 1 ,...,N. (7.5) This is known as the canonical representation of the decision hyperplane. In the case of data points for which the equality holds, the constraints are said to be active , whereas for the remainder they are said to be inactive . By deﬁnition, there will always be at least one active constraint, because there will always be a closest point, and once the margin has been maximized there will be at least two active constraints. The optimization problem then simply requires that we maximize w − 1 , which is equivalent to minimizing w 2 , and so we have to solve the optimization problem 1

$$
\arg \min _ { w , b } \frac { 1 } { 2 } \| w \| ^ { 2 } \\
$$

subject to the constraints given by (7.5). The factor of 1 / 2 in (7.6) is included for later convenience. This is an example of a quadratic programming problem in which we are trying to minimize a quadratic function subject to a set of linear inequality constraints. It appears that the bias parameter b has disappeared from the optimization. However, it is determined implicitly via the constraints, because these require that changes to w be compensated by changes to b . We shall see how this works shortly.

In order to solve this constrained optimization problem, we introduce Lagrange multipliers a n 0 , with one multiplier a n for each of the constraints in (7.5), giving the Lagrangian function

$$
L ( w , b , a ) = \frac { 1 } { 2 } \| w \| ^ { 2 } - \sum _ { n = 1 } ^ { N } a _ { n } \left \{ t _ { n } ( w ^ { T } \phi ( x _ { n } ) + b ) - 1 \right \} \\ \text {where } a = ( a _ { 1 } , \dots , a _ { N } ) ^ { T } , \text { Note the minus sign in front of the Lagrange multiplier}
$$

where a = ( a 1 ,...,a N ) T . Note the minus sign in front of the Lagrange multiplier term, because we are minimizing with respect to w and b , and maximizing with respect to a . Setting the derivatives of L ( w ,b, a ) with respect to w and b equal to zero, we obtain the following two conditions

$$
w \ = \ \sum _ { n = 1 } ^ { N } a _ { n } t _ { n } \phi ( x _ { n } )
$$

$$
0 \ = \ \sum _ { n = 1 } ^ { N } a _ { n } t _ { n } .
$$
