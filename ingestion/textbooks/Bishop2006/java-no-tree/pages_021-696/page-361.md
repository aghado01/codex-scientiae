[Page 361]

Figure 7.7 Illustration of SVM regression, showing the regression curve together with the insensitive ‘tube’. Also shown are examples of the slack variables ξ and bξ. Points above the -tube have ξ > 0 and bξ = 0, points below the -tube have ξ = 0 and bξ > 0, and points inside the -tube have ξ = bξ = 0.

y(x)

y +

ξ > 0

y

y −

ξ > 0

x

The error function for support vector regression can then be written as

N

1 2

(ξn + ξn) +

C

n=1

w 2 (7.55)

which must be minimized subject to the constraints ξn 0 and ξn 0 as well as (7.53) and (7.54). This can be achieved by introducing Lagrange multipliers an 0, an 0, µn 0, and µn 0 and optimizing the Lagrangian

L = C

−

N

N

1 2

(ξn + ξn) +

w 2 −

n=1

n=1

N

an( + ξn + yn − tn) −

n=1

(µnξn + µn ξn)

N

an( + ξn − yn + tn). (7.56)

n=1

We now substitute for y(x) using (7.1) and then set the derivatives of the Lagrangian with respect to w, b, ξn, and ξn to zero, giving

N

∂L ∂w

(an − an)φ(xn) (7.57)

= 0 ⇒ w =

n=1

N

∂L ∂b

(an − an) = 0 (7.58)

= 0 ⇒

n=1

∂L ∂ξn

= 0 ⇒ an + µn = C (7.59)

∂L ∂ ξn

= 0 ⇒ an + µn = C. (7.60)

Using these results to eliminate the corresponding variables from the Lagrangian, we

- Exercise 7.7 see that the dual problem involves maximizing
