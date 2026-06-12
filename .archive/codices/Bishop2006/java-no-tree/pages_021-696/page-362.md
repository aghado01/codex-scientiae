[Page 362]

1 2

L(a, a) = −

−

N

###### N

(an − an)(am − am)k(xn,xm)

n=1

m=1

N

N

(an + an) +

(an − an)tn (7.61)

n=1

n=1

with respect to {an} and { an}, where we have introduced the kernel k(x,x ) = φ(x)Tφ(x ). Again, this is a constrained maximization, and to ﬁnd the constraints

we note that an 0 and an 0 are both required because these are Lagrange multipliers. Also µn 0 and µn 0 together with (7.59) and (7.60), require an C and an C, and so again we have the box constraints

0 an C (7.62) 0 an C (7.63)

together with the condition (7.58).

Substituting (7.57) into (7.1), we see that predictions for new inputs can be made using

N

(an − an)k(x,xn) + b (7.64)

y(x) =

n=1

which is again expressed in terms of the kernel function.

The corresponding Karush-Kuhn-Tucker (KKT) conditions, which state that at the solution the product of the dual variables and the constraints must vanish, are given by

an( + ξn + yn − tn) = 0 (7.65) an( + ξn − yn + tn) = 0 (7.66)

(C − an)ξn = 0 (7.67) (C − an) ξn = 0. (7.68)

From these we can obtain several useful results. First of all, we note that a coefﬁcient an can only be nonzero if + ξn + yn − tn = 0, which implies that the data point either lies on the upper boundary of the -tube (ξn = 0) or lies above the upper boundary (ξn > 0). Similarly, a nonzero value for an implies + ξn − yn + tn = 0, and such points must lie either on or below the lower boundary of the -tube.

Furthermore, the two constraints +ξn +yn −tn = 0 and + ξn −yn +tn = 0 are incompatible, as is easily seen by adding them together and noting that ξn and ξn are nonnegative while is strictly positive, and so for every data point xn, either an or an (or both) must be zero.

The support vectors are those data points that contribute to predictions given by

(7.64), in other words those for which either an = 0 or an = 0. These are points that lie on the boundary of the -tube or outside the tube. All points within the tube have
