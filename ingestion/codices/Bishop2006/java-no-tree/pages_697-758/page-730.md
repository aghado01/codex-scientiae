[Page 730]

problem of maximizing f(x) subject to g(x) 0 is obtained by optimizing the Lagrange function (E.4) with respect to x and λ subject to the conditions

g(x) 0 (E.9) λ 0 (E.10) λg(x) = 0 (E.11)

These are known as the Karush-Kuhn-Tucker (KKT) conditions (Karush, 1939; Kuhn and Tucker, 1951).

Note that if we wish to minimize (rather than maximize) the function f(x) subject to an inequality constraint g(x) 0, then we minimize the Lagrangian function L(x,λ) = f(x) − λg(x) with respect to x, again subject to λ 0.

Finally, it is straightforward to extend the technique of Lagrange multipliers to the case of multiple equality and inequality constraints. Suppose we wish to maximize f(x) subject to gj(x) = 0 for j = 1,...,J, and hk(x) 0 for k = 1,...,K. We then introduce Lagrange multipliers {λj} and {µk}, and then optimize the Lagrangian function given by

L(x,{λj},{µk}) = f(x) +

J

λjgj(x) +

j=1

K

µkhk(x) (E.12)

k=1

subject to µk 0 and µkhk(x) = 0 for k = 1,...,K. Extensions to constrained Appendix D functional derivatives are similarly straightforward. For a more detailed discussion

of the technique of Lagrange multipliers, see Nocedal and Wright (1999).
