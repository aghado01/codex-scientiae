[Page 95]

0. So, for instance if we have a variable that can take K = 6 states and a particular observation of the variable happens to correspond to the state where x3 = 1, then x will be represented by

x = (0,0,1,0,0,0)T. (2.25)

Note that such vectors satisfy Kk=1 xk = 1. If we denote the probability of xk = 1 by the parameter µk, then the distribution of x is given

K

p(x|µ) =

k=1

µx

k (2.26)

k

where µ = (µ1,...,µK)T, and the parameters µk are constrained to satisfy µk 0 and k µk = 1, because they represent probabilities. The distribution (2.26) can be regarded as a generalization of the Bernoulli distribution to more than two outcomes. It is easily seen that the distribution is normalized

x

p(x|µ) =

K

µk = 1 (2.27)

k=1

and that

p(x|µ)x = (µ1,...,µM)T = µ. (2.28)

E[x|µ] =

x

Now consider a data set D of N independent observations x1,...,xN. The corresponding likelihood function takes the form

N

###### K

µx

p(D|µ) =

n=1

k=1

K

k =

nk

k=1

K

(P

n xnk) k =

µ

k=1

µm

k . (2.29)

k

We see that the likelihood function depends on the N data points only through the K quantities

mk =

xnk (2.30)

n

which represent the number of observations of xk = 1. These are called the sufﬁcient Section 2.4 statistics for this distribution.

In order to ﬁnd the maximum likelihood solution for µ, we need to maximize lnp(D|µ) with respect to µk taking account of the constraint that the µk must sum

Appendix E to one. This can be achieved using a Lagrange multiplier λ and maximizing

###### K

mk lnµk + λ

k=1

K

µk − 1 . (2.31)

k=1

Setting the derivative of (2.31) with respect to µk to zero, we obtain

µk = −mk/λ. (2.32)
