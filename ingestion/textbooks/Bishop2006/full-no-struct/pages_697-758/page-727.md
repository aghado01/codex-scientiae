[Page 727]

# Appendix E. Lagrange Multipliers

Lagrange multipliers , also sometimes called undetermined multipliers , are used to ﬁnd the stationary points of a function of several variables subject to one or more constraints.

Consider the problem of ﬁnding the maximum of a function f ( x 1 ,x 2 ) subject to a constraint relating x 1 and x 2 , which we write in the form

$$
g ( x _ { 1 } , x _ { 2 } ) = 0 .
$$

One approach would be to solve the constraint equation (E.1) and thus express x 2 as a function of x 1 in the form x 2 = h ( x 1 ) . This can then be substituted into f ( x 1 ,x 2 ) to give a function of x 1 alone of the form f ( x 1 ,h ( x 1 )) . The maximum with respect to x 1 could then be found by differentiation in the usual way, to give the stationary value x 1 , with the corresponding value of x 2 given by x 2 = h ( x 1 ) .

One problem with this approach is that it may be difﬁcult to ﬁnd an analytic solution of the constraint equation that allows x 2 to be expressed as an explicit function of x 1 . Also, this approach treats x 1 and x 2 differently and so spoils the natural symmetry between these variables.

A more elegant, and often simpler, approach is based on the introduction of a parameter λ called a Lagrange multiplier. We shall motivate this technique from a geometrical perspective. Consider a D -dimensional variable x with components x 1 ,...,x D . The constraint equation g ( x ) = 0 then represents a ( D − 1) -dimensional surface in x -space as indicated in Figure E.1.

We ﬁrst note that at any point on the constraint surface the gradient ∇ g ( x ) of the constraint function will be orthogonal to the surface. To see this, consider a point x that lies on the constraint surface, and consider a nearby point x + that also lies on the surface. If we make a Taylor expansion around x , we have

$$
g ( x + \epsilon ) \simeq g ( x ) + \epsilon ^ { \mathrm T } \nabla g ( x ) .
$$

Because both x and x + /epsilon1 lie on the constraint surface, we have g ( x ) = g ( x + /epsilon1 ) and hence /epsilon1 T ∇ g ( x ) /similarequal 0 . In the limit ‖ /epsilon1 ‖ → 0 we have /epsilon1 T ∇ g ( x ) = 0 , and because /epsilon1 is A geometrical picture of the technique of Lagrange multipliers in which we seek to maximize a function f ( x ) , subject to the constraint g ( x ) = 0 . If x is D dimensional, the constraint g ( x ) = 0 corresponds to a subspace of dimensionality D -1 , indicated by the red curve. The problem can be solved by optimizing the Lagrangian function L ( x , λ ) = f ( x ) + λg ( x ) .
