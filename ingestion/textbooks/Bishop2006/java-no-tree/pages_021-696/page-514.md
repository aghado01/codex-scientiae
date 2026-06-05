[Page 514]

y

y

f(x)

f(x)

−g(λ)

x

x

λx

λx − g(λ)

- Figure 10.11 In the left-hand plot the red curve shows a convex function f(x), and the blue line represents the linear function λx, which is a lower bound on f(x) because f(x) > λx for all x. For the given value of slope λ the contact point of the tangent line having the same slope is found by minimizing with respect to x the discrepancy (shown by the green dashed lines) given by f(x) − λx. This deﬁnes the dual function g(λ), which corresponds to the (negative of the) intercept of the tangent line having slope λ.


exp(−x), we therefore obtain the tangent line in the form y(x) = exp(−ξ) − exp(−ξ)(x − ξ) (10.126)

which is a linear function parameterized by ξ. For consistency with subsequent discussion, let us deﬁne λ = −exp(−ξ) so that

###### y(x,λ) = λx − λ + λln(−λ). (10.127)

Different values of λ correspond to different tangent lines, and because all such lines are lower bounds on the function, we have f(x) y(x,λ). Thus we can write the function in the form

f(x) = max

{λx − λ + λln(−λ)}. (10.128)

λ

We have succeeded in approximating the convex function f(x) by a simpler, linear function y(x,λ). The price we have paid is that we have introduced a variational parameter λ, and to obtain the tightest bound we must optimize with respect to λ.

We can formulate this approach more generally using the framework of convex duality (Rockafellar, 1972; Jordan et al., 1999). Consider the illustration of a convex function f(x) shown in the left-hand plot in Figure 10.11. In this example, the function λx is a lower bound on f(x) but it is not the best lower bound that can be achieved by a linear function having slope λ, because the tightest bound is given by the tangent line. Let us write the equation of the tangent line, having slope λ as λx − g(λ) where the (negative) intercept g(λ) clearly depends on the slope λ of the tangent. To determine the intercept, we note that the line must be moved vertically by an amount equal to the smallest vertical distance between the line and the function, as shown in Figure 10.11. Thus

g(λ) = −min

{f(x) − λx}

x

= max

{λx − f(x)}. (10.129)

x
