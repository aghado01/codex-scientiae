[Page 353]

where {an � 0} and {µn � 0} are Lagrange multipliers. The corresponding set of Appendix E KKT conditions are given by

an � 0 (7.23) tny(xn) − 1 + ξn � 0 (7.24)

an (tny(xn) − 1 + ξn) = 0 (7.25) µn � 0 (7.26) ξn � 0 (7.27)

µnξn = 0 (7.28) where n = 1,...,N.

We now optimize out w, b, and {ξn} making use of the deﬁnition (7.1) of y(x) to give

�N

∂L ∂w

antnφ(xn) (7.29)

= 0 ⇒ w =

n=1

�N

∂L ∂b

= 0 ⇒

antn = 0 (7.30)

n=1

∂L ∂ξn

= 0 ⇒ an = C − µn. (7.31)

Using these results to eliminate w, b, and {ξn} from the Lagrangian, we obtain the dual Lagrangian in the form

�N

�N

�N

1 2

L�(a) =

anamtntmk(xn,xm) (7.32)

an −

n=1

n=1

m=1

which is identical to the separable case, except that the constraints are somewhat different. To see what these constraints are, we note that an � 0 is required because these are Lagrange multipliers. Furthermore, (7.31) together with µn � 0 implies an � C. We therefore have to minimize (7.32) with respect to the dual variables {an} subject to

0 � an � C (7.33) �N

antn = 0 (7.34)

n=1

for n = 1,...,N, where (7.33) are known as box constraints. This again represents a quadratic programming problem. If we substitute (7.29) into (7.1), we see that predictions for new data points are again made by using (7.13).

We can now interpret the resulting solution. As before, a subset of the data points may have an = 0, in which case they do not contribute to the predictive
