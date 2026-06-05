[Page 322]

the input variable, which is given by

∞

y(x) = E[t|x] =

−∞

tp(x,t)dt

=

p(x,t)dt

tp(t|x)dt

tf(x − xn,t − tn)dt

= n

. (6.43)

f(x − xm,t − tm)dt

m

We now assume for simplicity that the component density functions have zero mean so that ∞

f(x,t)tdt = 0 (6.44) for all values of x. Using a simple change of variable, we then obtain

−∞

g(x − xn)tn

y(x) = n

g(x − xm)

m

=

k(x,xn)tn (6.45)

n

where n,m = 1,...,N and the kernel function k(x,xn) is given by

g(x − xn)

k(x,xn) =

g(x − xm)

m

(6.46)

and we have deﬁned

∞

f(x,t)dt. (6.47)

g(x) =

−∞

The result (6.45) is known as the Nadaraya-Watson model, or kernel regression (Nadaraya, 1964; Watson, 1964). For a localized kernel function, it has the property of giving more weight to the data points xn that are close to x. Note that the kernel (6.46) satisﬁes the summation constraint

###### N

k(x,xn) = 1.

n=1
