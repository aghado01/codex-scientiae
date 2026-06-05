[Page 74]

three constraints

∞

p(x)dx = 1 (1.105)

−∞

∞

xp(x)dx = µ (1.106)

−∞

∞

(x − µ)2p(x)dx = σ2. (1.107)

−∞

Appendix E The constrained maximization can be performed using Lagrange multipliers so that

we maximize the following functional with respect to p(x)

∞

∞

p(x)lnp(x)dx + λ1

p(x)dx − 1

−

−∞

−∞

∞

∞

+λ2

xp(x)dx − µ + λ3

(x − µ)2p(x)dx − σ2 .

−∞

−∞

Appendix D Using the calculus of variations, we set the derivative of this functional to zero giving p(x) = exp −1 + λ1 + λ2x + λ3(x − µ)2 . (1.108) The Lagrange multipliers can be found by back substitution of this result into the

- Exercise 1.34 three constraint equations, leading ﬁnally to the result

p(x) =

1 (2πσ2)1/2

exp −

(x − µ)2 2σ2

(1.109)

and so the distribution that maximizes the differential entropy is the Gaussian. Note that we did not constrain the distribution to be nonnegative when we maximized the entropy. However, because the resulting distribution is indeed nonnegative, we see with hindsight that such a constraint is not necessary.

- Exercise 1.35 If we evaluate the differential entropy of the Gaussian, we obtain


- 1

- 2


H[x] =

1 + ln(2πσ2) . (1.110)

Thus we see again that the entropy increases as the distribution becomes broader, i.e., as σ2 increases. This result also shows that the differential entropy, unlike the discrete entropy, can be negative, because H(x) < 0 in (1.110) for σ2 < 1/(2πe).

Suppose we have a joint distribution p(x,y) from which we draw pairs of values of x and y. If a value of x is already known, then the additional information needed to specify the corresponding value of y is given by −lnp(y|x). Thus the average additional information needed to specify y can be written as

###### H[y|x] = − p(y,x)lnp(y|x)dy dx (1.111)
