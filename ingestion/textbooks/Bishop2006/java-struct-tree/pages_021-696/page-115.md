[Page 115]

Figure 2.10 A schematic illustration of two correlated random variables z and θ, together with the regression function f(θ) given by the conditional expectation E[z|θ]. The RobbinsMonro algorithm provides a general sequential procedure for ﬁnding the root θ� of such functions. θ

f(θ)

θ�

dissect out the contribution from the ﬁnal data point xN, we obtain

�N

1 N

µ(MLN) =

xn

n=1

N�−1

1 N

1 N

=

xN +

xn

n=1

1 N

N − 1 N

µ(MLN−1)

=

xN +

1 N

(xN − µML(N−1)). (2.126) This result has a nice interpretation, as follows. After observing N − 1 data points we have estimated µ by µ(MLN−1). We now observe data point xN, and we obtain our revised estimate µ(MLN) by moving the old estimate a small amount, proportional to 1/N, in the direction of the ‘error signal’ (xN −µML(N−1)). Note that, as N increases, so the contribution from successive data points gets smaller.

= µ(MLN−1) +

The result (2.126) will clearly give the same answer as the batch result (2.121) because the two formulae are equivalent. However, we will not always be able to derive a sequential algorithm by this route, and so we seek a more general formulation of sequential learning, which leads us to the Robbins-Monro algorithm. Consider a pair of random variables θ and z governed by a joint distribution p(z,θ). The conditional expectation of z given θ deﬁnes a deterministic function f(θ) that is given by

f(θ) ≡ E[z|θ] = � zp(z|θ)dz (2.127)

and is illustrated schematically in Figure 2.10. Functions deﬁned in this way are called regression functions.

Our goal is to ﬁnd the root θ� at which f(θ�) = 0. If we had a large data set of observations of z and θ, then we could model the regression function directly and then obtain an estimate of its root. Suppose, however, that we observe values of z one at a time and we wish to ﬁnd a corresponding sequential estimation scheme for θ�. The following general procedure for solving such problems was given by
