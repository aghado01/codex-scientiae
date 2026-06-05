[Page 729]

###### E. LAGRANGE MULTIPLIERS 709

- Figure E.2 A simple example of the use of Lagrange multipliers in which the aim is to maximize f(x1, x2) = 1 − x21 − x22 subject to the constraint g(x1, x2) = 0 where g(x1, x2) = x1 + x2 − 1. The circles show contours of the function f(x1, x2), and the diagonal line shows the constraint surface g(x1, x2) = 0.

|x2|(x 1,x 2)|
|---|---|
| |g(x1,x2)<br><br>x1|


= 0

Solution of these equations then gives the stationary point as (x 1,x 2) = (12, 12), and the corresponding value for the Lagrange multiplier is λ = 1.

So far, we have considered the problem of maximizing a function subject to an equality constraint of the form g(x) = 0. We now consider the problem of maximizing f(x) subject to an inequality constraint of the form g(x) 0, as illustrated in Figure E.3.

There are now two kinds of solution possible, according to whether the constrained stationary point lies in the region where g(x) > 0, in which case the constraint is inactive, or whether it lies on the boundary g(x) = 0, in which case the constraint is said to be active. In the former case, the function g(x) plays no role and so the stationary condition is simply ∇f(x) = 0. This again corresponds to a stationary point of the Lagrange function (E.4) but this time with λ = 0. The latter case, where the solution lies on the boundary, is analogous to the equality constraint discussed previously and corresponds to a stationary point of the Lagrange function (E.4) with λ = 0. Now, however, the sign of the Lagrange multiplier is crucial, because the function f(x) will only be at a maximum if its gradient is oriented away from the region g(x) > 0, as illustrated in Figure E.3. We therefore have ∇f(x) = −λ∇g(x) for some value of λ > 0.

For either of these two cases, the product λg(x) = 0. Thus the solution to the

- Figure E.3 Illustration of the problem of maximizing f(x) subject to the inequality constraint g(x) 0.


∇f(x)

xA

∇g(x)

xB

g(x) = 0 g(x) > 0
