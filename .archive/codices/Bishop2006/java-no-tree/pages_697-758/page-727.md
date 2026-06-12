[Page 727]

###### Appendix E. Lagrange Multipliers

Lagrange multipliers, also sometimes called undetermined multipliers, are used to ﬁnd the stationary points of a function of several variables subject to one or more constraints.

Consider the problem of ﬁnding the maximum of a function f(x1,x2) subject to a constraint relating x1 and x2, which we write in the form

###### g(x1,x2) = 0. (E.1)

One approach would be to solve the constraint equation (E.1) and thus express x2 as a function of x1 in the form x2 = h(x1). This can then be substituted into f(x1,x2) to give a function of x1 alone of the form f(x1,h(x1)). The maximum with respect to x1 could then be found by differentiation in the usual way, to give the stationary value x 1, with the corresponding value of x2 given by x 2 = h(x 1).

One problem with this approach is that it may be difﬁcult to ﬁnd an analytic solution of the constraint equation that allows x2 to be expressed as an explicit function of x1. Also, this approach treats x1 and x2 differently and so spoils the natural symmetry between these variables.

A more elegant, and often simpler, approach is based on the introduction of a parameter λ called a Lagrange multiplier. We shall motivate this technique from a geometrical perspective. Consider a D-dimensional variable x with components x1,...,xD. The constraint equation g(x) = 0 then represents a (D−1)-dimensional surface in x-space as indicated in Figure E.1.

We ﬁrst note that at any point on the constraint surface the gradient ∇g(x) of the constraint function will be orthogonal to the surface. To see this, consider a point x that lies on the constraint surface, and consider a nearby point x + that also lies on the surface. If we make a Taylor expansion around x, we have

g(x + ) g(x) + T∇g(x). (E.2)

Because both x and x+ lie on the constraint surface, we have g(x) = g(x+ ) and hence T∇g(x) 0. In the limit → 0 we have T∇g(x) = 0, and because is

###### 707
