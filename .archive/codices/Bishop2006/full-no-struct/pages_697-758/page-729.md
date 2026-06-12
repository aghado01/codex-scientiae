[Page 729]

Figure E.2 A simple example of the use of Lagrange multipliers in which the aim is to maximize f ( x 1 , x 2 ) = 1 − x 2 1 − x 2 2 subject to the constraint g ( x 1 , x 2 ) = 0 where g ( x 1 , x 2 ) = x 1 + x 2 − 1 . The circles show contours of the function f ( x 1 , x 2 ) , and the diagonal line shows the constraint surface g ( x 1 , x 2 ) = 0 .

![The image depicts a diagram with a circle and a point labeled as point A. The circle is centered at point A. There is a line segment labeled as line segment AB that connects point A to point B. Point B is located on the circumference of the circle.](../images/imageFile353.png)

x

2

/star

/star

(

x

,x

)

1

2

x

1

g

(

x

,x 2

= 0

1

2

Solution of these equations then gives the stationary point as ( x 1 ,x 2 ) = ( 1 2 , 1 2 ) , and the corresponding value for the Lagrange multiplier is λ = 1 .

So far, we have considered the problem of maximizing a function subject to an equality constraint of the form g ( x ) = 0 . We now consider the problem of maximizing f ( x ) subject to an inequality constraint of the form g ( x ) 0 , as illustrated in Figure E.3.

There are now two kinds of solution possible, according to whether the constrained stationary point lies in the region where g ( x ) > 0 , in which case the constraint is inactive , or whether it lies on the boundary g ( x ) = 0 , in which case the constraint is said to be active . In the former case, the function g ( x ) plays no role and so the stationary condition is simply ∇ f ( x ) = 0 . This again corresponds to a stationary point of the Lagrange function (E.4) but this time with λ = 0 . The latter case, where the solution lies on the boundary, is analogous to the equality constraint discussed previously and corresponds to a stationary point of the Lagrange function (E.4) with λ = 0 . Now, however, the sign of the Lagrange multiplier is crucial, because the function f ( x ) will only be at a maximum if its gradient is oriented away from the region g ( x ) > 0 , as illustrated in Figure E.3. We therefore have ∇ f ( x ) = − λ ∇ g ( x ) for some value of λ > 0 . For either of these two cases, the product λg ( x ) = 0 . Thus the solution to the

/negationslash

For either of these two cases, the product λg ( x ) = 0 . Thus the solution to the

Figure E.3 Illustration of the problem of maximizing f ( x ) subject to the inequality constraint g ( x ) 0 .

![The image contains a geometric figure with a central point labeled as (\triangle g(x)). The figure consists of two sides and two angles. The sides are labeled as (g(x)) and (x). The angles are labeled as (f(x)) and (g(x)). The figure is a circle with a radius labeled as (r).](../images/imageFile354.png)

∇

f

(

)

x

A

x

∇

g

(

)

x

B

x

g

(

) = 0

g

(

)

>

0

x

x
