[Page 728]

Figure E.1 A geometrical picture of the technique of Lagrange multipliers in which we seek to maximize a function f(x), subject to the constraint g(x) = 0. If x is D dimensional, the constraint g(x) = 0 corresponds to a subspace of dimensionality D − 1, indicated by the red curve. The problem can be solved by optimizing the Lagrangian function L(x, λ) = f(x) + λg(x).

∇g(x)

∇f(x)

xA

g(x) = 0

then parallel to the constraint surface g(x) = 0, we see that the vector ∇g is normal to the surface.

Next we seek a point x� on the constraint surface such that f(x) is maximized. Such a point must have the property that the vector ∇f(x) is also orthogonal to the constraint surface, as illustrated in Figure E.1, because otherwise we could increase the value of f(x) by moving a short distance along the constraint surface. Thus ∇f and ∇g are parallel (or anti-parallel) vectors, and so there must exist a parameter λ such that

∇f + λ∇g = 0 (E.3) where λ �= 0 is known as a Lagrange multiplier. Note that λ can have either sign.

At this point, it is convenient to introduce the Lagrangian function deﬁned by

L(x,λ) ≡ f(x) + λg(x). (E.4)

The constrained stationarity condition (E.3) is obtained by setting ∇xL = 0. Furthermore, the condition ∂L/∂λ = 0 leads to the constraint equation g(x) = 0.

Thus to ﬁnd the maximum of a function f(x) subject to the constraint g(x) = 0, we deﬁne the Lagrangian function given by (E.4) and we then ﬁnd the stationary point of L(x,λ) with respect to both x and λ. For a D-dimensional vector x, this gives D+1 equations that determine both the stationary point x� and the value of λ. If we are only interested in x�, then we can eliminate λ from the stationarity equations without needing to ﬁnd its value (hence the term ‘undetermined multiplier’).

As a simple example, suppose we wish to ﬁnd the stationary point of the function

f(x1,x2) = 1 − x21 − x22 subject to the constraint g(x1,x2) = x1 + x2 − 1 = 0, as illustrated in Figure E.2. The corresponding Lagrangian function is given by

L(x,λ) = 1 − x21 − x22 + λ(x1 + x2 − 1). (E.5)

The conditions for this Lagrangian to be stationary with respect to x1, x2, and λ give the following coupled equations:

−2x1 + λ = 0 (E.6) −2x2 + λ = 0 (E.7)

x1 + x2 − 1 = 0. (E.8)
