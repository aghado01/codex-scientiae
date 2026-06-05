[Page 723]

###### Appendix D. Calculus of Variations

We can think of a function y(x) as being an operator that, for any input value x, returns an output value y. In the same way, we can deﬁne a functional F[y] to be an operator that takes a function y(x) and returns an output value F. An example of a functional is the length of a curve drawn in a two-dimensional plane in which the path of the curve is deﬁned in terms of a function. In the context of machine learning, a widely used functional is the entropy H[x] for a continuous variable x because, for any choice of probability density function p(x), it returns a scalar value representing the entropy of x under that density. Thus the entropy of p(x) could equally well have been written as H[p].

A common problem in conventional calculus is to ﬁnd a value of x that maximizes (or minimizes) a function y(x). Similarly, in the calculus of variations we seek a function y(x) that maximizes (or minimizes) a functional F[y]. That is, of all possible functions y(x), we wish to ﬁnd the particular function for which the functional F[y] is a maximum (or minimum). The calculus of variations can be used, for instance, to show that the shortest path between two points is a straight line or that the maximum entropy distribution is a Gaussian.

If we weren’t familiar with the rules of ordinary calculus, we could evaluate a conventional derivative dy/dx by making a small change to the variable x and then expanding in powers of , so that

dy dx

+ O( 2) (D.1)

y(x + ) = y(x) +

and ﬁnally taking the limit → 0. Similarly, for a function of several variables y(x1,...,xD), the corresponding partial derivatives are deﬁned by

D

y(x1 + 1,...,xD + D) = y(x1,...,xD) +

i=1

∂y ∂xi i

+ O( 2). (D.2)

The analogous deﬁnition of a functional derivative arises when we consider how much a functional F[y] changes when we make a small change  η(x) to the function

###### 703
