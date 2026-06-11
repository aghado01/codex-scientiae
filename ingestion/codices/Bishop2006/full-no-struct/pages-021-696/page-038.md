[Page 38]

# 1. INTRODUCTION

Figure 1.12

The concept of probability for discrete variables can be extended to that of a probability density p ( x ) over a continuous variable x and is such that the probability of x lying in the interval ( x, x + δx ) is given by p ( x ) δx for δx → 0 . The probability density can be expressed as the derivative of a cumulative distribution function P ( x ) .

![The image consists of a graph with two lines. The graph is titled P(x) and P(x). The x-axis is labeled as dz and the y-axis is labeled as η. The graph shows two lines, one blue line and another red line. The blue line is a straight line, while the red line is a curved line. The blue line starts at the point (0, 0) and extends upwards, while the red line starts at the point (0, 0) and extends downwards. The graph shows that the blue line is a straight line, while the red line is a curved line. The blue line has a higher value than the red line. This means that the blue line is more likely to be a straight line than the red line. The graph also shows that the blue line is not a straight line, but rather a curved line. This means that the blue line is not a straight line,](../images/imageFile15.png)

P

(

x

)

p

(

x

)

x

δx

# Exercise 1.4

Because probabilities are nonnegative, and because the value of x must lie somewhere on the real axis, the probability density p ( x ) must satisfy the two conditions

$$
p ( x ) \ \geq \ 0
$$

$$
p ( x ) \ \geq \ 0 & & ( 1 . 2 5 ) \\ \int _ { - \infty } ^ { \infty } p ( x ) \, d x \ = \ 1 . & & ( 1 . 2 6 ) \\
$$

Under a nonlinear change of variable, a probability density transforms differently from a simple function, due to the Jacobian factor. For instance, if we consider a change of variables x = g ( y ) , then a function f ( x ) becomes f ( y ) = f ( g ( y )) . Now consider a probability density p x ( x ) that corresponds to a density p y ( y ) with respect to the new variable y , where the sufﬁces denote the fact that p x ( x ) and p y ( y ) are different densities. Observations falling in the range ( x,x + δx ) will, for small values of δx , be transformed into the range ( y,y + δy ) where p x ( x ) δx p y ( y ) δy , and hence

$$
\ p _ { y } ( y ) \ = \ p _ { x } ( x ) \left | \frac { d x } { d y } \right | \\ = \ p _ { x } ( g ( y ) ) \left | g ^ { \prime } ( y ) \right | . \\ \text {of this property is that the concept of the maximum of a probability}
$$

One consequence of this property is that the concept of the maximum of a probability density is dependent on the choice of variable.

The probability that x lies in the interval ( −∞ ,z ) is given by the cumulative distribution function deﬁned by

$$
P ( z ) & = \int _ { - \infty } ^ { z } p ( x ) \, d x \\
$$

which satisﬁes P ( x ) = p ( x ) , as shown in Figure 1.12.
