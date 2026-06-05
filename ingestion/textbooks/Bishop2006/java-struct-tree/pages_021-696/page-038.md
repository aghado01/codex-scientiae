[Page 38]

Figure 1.12 The concept of probability for discrete variables can be extended to that of a probability density p(x) over a continuous variable x and is such that the probability of x lying in the interval (x, x+δx) is given by p(x)δx for δx → 0. The probability density can be expressed as the derivative of a cumulative distribution function P(x).

p(x) P(x)

δx x

Because probabilities are nonnegative, and because the value of x must lie somewhere on the real axis, the probability density p(x) must satisfy the two conditions

p(x) � 0 (1.25)

� ∞

p(x)dx = 1. (1.26)

−∞

Under a nonlinear change of variable, a probability density transforms differently from a simple function, due to the Jacobian factor. For instance, if we consider a change of variables x = g(y), then a function f(x) becomes f�(y) = f(g(y)). Now consider a probability density px(x) that corresponds to a density py(y) with respect to the new variable y, where the sufﬁces denote the fact that px(x) and py(y) are different densities. Observations falling in the range (x,x + δx) will, for small values of δx, be transformed into the range (y,y + δy) where px(x)δx � py(y)δy, and hence

py(y) = px(x)�

� � �

� � �

dx dy

= px(g(y))|g��(y)|. (1.27)

One consequence of this property is that the concept of the maximum of a probability Exercise 1.4 density is dependent on the choice of variable.

The probability that x lies in the interval (−∞,z) is given by the cumulative distribution function deﬁned by

P(z) = � z

p(x)dx (1.28)

−∞

which satisﬁes P�(x) = p(x), as shown in Figure 1.12.

If we have several continuous variables x1,...,xD, denoted collectively by the vector x, then we can deﬁne a joint probability density p(x) = p(x1,...,xD) such
