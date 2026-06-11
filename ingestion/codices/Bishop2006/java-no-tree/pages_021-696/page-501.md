[Page 501]

Indeed, these singularities are removed if we simply introduce a prior and then use a MAP estimate instead of maximum likelihood. Furthermore, there is no over-ﬁtting if we choose a large number K of components in the mixture, as we saw in Figure 10.6. Finally, the variational treatment opens up the possibility of determining the optimal number of components in the mixture without resorting to techniques

Section 10.2.4 such as cross validation.

###### 10.2.2 Variational lower bound

We can also straightforwardly evaluate the lower bound (10.3) for this model. In practice, it is useful to be able to monitor the bound during the re-estimation in order to test for convergence. It can also provide a valuable check on both the mathematical expressions for the solutions and their software implementation, because at each step of the iterative re-estimation procedure the value of this bound should not decrease. We can take this a stage further to provide a deeper test of the correctness of both the mathematical derivation of the update equations and of their software implementation by using ﬁnite differences to check that each update does indeed give a (constrained) maximum of the bound (Svens´en and Bishop, 2004).

For the variational mixture of Gaussians, the lower bound (10.3) is given by

p(X,Z,π,µ,Λ) q(Z,π,µ,Λ)

q(Z,π,µ,Λ)ln

dπ dµdΛ

L =

Z

= E[lnp(X,Z,π,µ,Λ)] − E[lnq(Z,π,µ,Λ)]

= E[lnp(X|Z,µ,Λ)] + E[lnp(Z|π)] + E[lnp(π)] + E[lnp(µ,Λ)] −E[lnq(Z)] − E[lnq(π)] − E[lnq(µ,Λ)] (10.70)

where, to keep the notation uncluttered, we have omitted the superscript on the q distributions, along with the subscripts on the expectation operators because each expectation is taken with respect to all of the random variables in its argument. The

- Exercise 10.16 various terms in the bound are easily evaluated to give the following results


1 2

E[lnp(X|Z,µ,Λ)] =

K

Nk ln Λk − Dβk−1 − νkTr(SkWk)

k=1

−νk(xk − mk)TWk(xk − mk) − D ln(2π) (10.71)

N

###### K

rnk ln πk (10.72)

- E[lnp(Z|π)] =


n=1

k=1

K

- E[lnp(π)] = lnC(α0) + (α0 − 1)


ln πk (10.73)

k=1
