[Page 516]

![The image depicts a graph with two axes, labeled as x and y. The x-axis is labeled as 0 and the y-axis is labeled as 6. Both axes are marked with a dashed line that starts at the point (0, 0) and extends upwards to the right. The dashed line starts at the point (0, 0) and extends to the right, then it starts at the point (0, 0) and extends to the right again, and finally it starts at the point (0, 0) and extends to the right again. The dashed line is a straight line with a positive slope. The slope of the dashed line is 0.5. The dashed line starts at the point (0, 0) and extends to the right, then it starts at the point (0, 0) and extends to the right again, and finally it starts at the point (0, 0) and extends to](../images/imageFile245.png)

1

1

ξ

=2

.

5

λ

=0

.

2

0.5

0.5

λ

=0

.

7

0

0

-

ξ

ξ

-6

0

6

-6

0

6

Figure 10.12 The left-hand plot shows the logistic sigmoid function σ ( x ) deﬁned by (10.134) in red, together with two examples of the exponential upper bound (10.137) shown in blue. The right-hand plot shows the logistic sigmoid again in red together with the Gaussian lower bound (10.144) shown in blue. Here the parameter ξ = 2 . 5 , and the bound is exact at x = ξ and x = − ξ , denoted by the dashed green lines.

Exercise 10.31

and taking the exponential, we obtain an upper bound on the logistic sigmoid itself of the form

$$
\sigma ( x ) \leqslant \exp ( \lambda x - g ( \lambda ) ) \\ \intertext { t i v u l v o s f . } \text { } \sigma ( x ) \leqslant \exp ( \lambda x - g ( \lambda ) ) \\ \text { } \intertext { t i v u l v o s f . }
$$

which is plotted for two values of λ on the left-hand plot in Figure 10.12.

We can also obtain a lower bound on the sigmoid having the functional form of a Gaussian. To do this, we follow Jaakkola and Jordan (2000) and make transformations both of the input variable and of the function itself. First we take the log of the logistic function and then decompose it so that

$$
\log i s c u l f o n c o n d o p s c t h s o t a t h s o t & \\ & \quad \ln \sigma ( x ) \ = \ - \ln ( 1 + e ^ { - x } ) = - \ln \left \{ e ^ { - x / 2 } ( e ^ { x / 2 } + e ^ { - x / 2 } ) \right \} \\ & = \ x / 2 - \ln ( e ^ { x / 2 } + e ^ { - x / 2 } ) . \\ \intertext { W o n v o p t h a t h s o t f o n t i o n }
$$

We now note that the function f ( x ) = − ln( e x/ 2 + e − x/ 2 ) is a convex function of the variable x 2 , as can again be veriﬁed by ﬁnding the second derivative. This leads to a lower bound on f ( x ) , which is a linear function of x 2 whose conjugate function is given by √

$$
g ( \lambda ) = \max _ { x ^ { 2 } } \left \{ \lambda x ^ { 2 } - f \left ( \sqrt { x ^ { 2 } } \right ) \right \} . \\ \intertext { y c o d i t i o n l e d s t o n }
$$

The stationarity condition leads to

$$
0 = \lambda - \frac { d x } { d x ^ { 2 } } \frac { d } { d x } f ( x ) = \lambda + \frac { 1 } { 4 x } \tanh \left ( \frac { x } { 2 } \right ) . \\ \intertext { o n t e $ h e c k $ } \intertext { i n o t e $ h e c k $ } \intertext { o n t e $ d x $ } \intertext { e f f $ ( x ) = \lambda + \frac { 1 } { 4 x } \tanh \left ( \frac { x } { 2 } \right ) } .
$$

If we denote this value of x , corresponding to the contact point of the tangent line for this particular value of λ , by ξ , then we have

$$
\text {partial value of } \lambda , & \text {by $\zeta$, then we have} \\ & \lambda ( \xi ) = - \frac { 1 } { 4 \xi } \tanh \left ( \frac { \xi } { 2 } \right ) = - \frac { 1 } { 2 \xi } \left [ \sigma ( \xi ) - \frac { 1 } { 2 } \right ] .
$$
