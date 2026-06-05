[Page 348]

does not depend on n. Direct solution of this optimization problem would be very complex, and so we shall convert it into an equivalent problem that is much easier to solve. To do this we note that if we make the rescaling w → κw and b → κb, then the distance from any point xn to the decision surface, given by tny(xn)/�w�, is unchanged. We can use this freedom to set

�

�

wTφ(xn) + b

= 1 (7.4)

tn

for the point that is closest to the surface. In this case, all data points will satisfy the constraints

�

�

� 1, n = 1,...,N. (7.5)

wTφ(xn) + b

tn

This is known as the canonical representation of the decision hyperplane. In the case of data points for which the equality holds, the constraints are said to be active, whereas for the remainder they are said to be inactive. By deﬁnition, there will always be at least one active constraint, because there will always be a closest point, and once the margin has been maximized there will be at least two active constraints. The optimization problem then simply requires that we maximize �w�−1, which is equivalent to minimizing �w�2, and so we have to solve the optimization problem

1 2�w�2 (7.6)

arg min

w,b

subject to the constraints given by (7.5). The factor of 1/2 in (7.6) is included for later convenience. This is an example of a quadratic programming problem in which we are trying to minimize a quadratic function subject to a set of linear inequality constraints. It appears that the bias parameter b has disappeared from the optimization. However, it is determined implicitly via the constraints, because these require that changes to �w� be compensated by changes to b. We shall see how this works shortly.

In order to solve this constrained optimization problem, we introduce Lagrange Appendix E multipliers an � 0, with one multiplier an for each of the constraints in (7.5), giving

the Lagrangian function

�N

1 2�w�2 −

�

�

tn(wTφ(xn) + b) − 1

L(w,b,a) =

(7.7)

an

n=1

where a = (a1,...,aN)T. Note the minus sign in front of the Lagrange multiplier term, because we are minimizing with respect to w and b, and maximizing with respect to a. Setting the derivatives of L(w,b,a) with respect to w and b equal to zero, we obtain the following two conditions

w =

0 =

�N

antnφ(xn) (7.8)

n=1

�N

antn. (7.9)

n=1
