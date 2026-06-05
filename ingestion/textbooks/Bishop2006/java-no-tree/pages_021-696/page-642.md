[Page 642]

Figure 13.13 Illustration of the backward recursion (13.38) for evaluation of the β variables. In this fragment of the lattice, we see that the quantity β(zn1) is obtained by taking the components β(zn+1,k) of β(zn+1) at step n + 1 and summing them up with weights given by the products of A1k, corresponding to the values of p(zn+1|zn) and the corresponding values of the emission density p(xn|zn+1,k).

β(zn,1) β(zn+1,1)

A11

- k = 1
- k = 2
- k = 3


- p(xn|zn+1,1)

- p(xn|zn+1,2)

- p(xn|zn+1,3)


A12

- β(zn+1,2)
- β(zn+1,3)


A13

n n + 1

Making use of the deﬁnition (13.35) for β(zn), we then obtain

###### β(zn) =

###### β(zn+1)p(xn+1|zn+1)p(zn+1|zn). (13.38)

zn+1

Note that in this case we have a backward message passing algorithm that evaluates β(zn) in terms of β(zn+1). At each step, we absorb the effect of observation xn+1 through the emission probability p(xn+1|zn+1), multiply by the transition matrix p(zn+1|zn), and then marginalize out zn+1. This is illustrated in Figure 13.13.

Again we need a starting condition for the recursion, namely a value for β(zN). This can be obtained by setting n = N in (13.33) and replacing α(zN) with its deﬁnition (13.34) to give

p(X,zN)β(zN) p(X)

p(zN|X) =

(13.39)

which we see will be correct provided we take β(zN) = 1 for all settings of zN.

In the M step equations, the quantity p(X) will cancel out, as can be seen, for instance, in the M-step equation for µk given by (13.20), which takes the form

n

n

γ(znk)xn

α(znk)β(znk)xn

n=1

n=1

µk =

=

. (13.40)

n

n

γ(znk)

α(znk)β(znk)

n=1

n=1

However, the quantity p(X) represents the likelihood function whose value we typically wish to monitor during the EM optimization, and so it is useful to be able to evaluate it. If we sum both sides of (13.33) over zn, and use the fact that the left-hand side is a normalized distribution, we obtain

###### p(X) =

zn

###### α(zn)β(zn). (13.41)
