[Page 511]

10.4. Exponential Family Distributions 491

distribution that factorizes between the latent variables and the parameters, so that q(Z,η) = q(Z)q(η). Using the general result (10.9), we can solve for the two factors as follows

lnq�(Z) = Eη[lnp(X,Z|η)] + const

�N

�

�

=

lnh(xn,zn) + E[ηT]u(xn,zn)

+ const. (10.115)

n=1

Thus we see that this decomposes into a sum of independent terms, one for each value of� n, and hence the solution for q�(Z) will factorize over n so that q�(Z) =

Section 10.2.5 n q�(zn). This is an example of an induced factorization. Taking the exponential

of both sides, we have

�

�

q�(zn) = h(xn,zn)g (E[η])exp

E[ηT]u(xn,zn)

(10.116)

where the normalization coefﬁcient has been re-instated by comparison with the standard form for the exponential family.

Similarly, for the variational distribution over the parameters, we have

lnq�(η) = lnp(η|ν0,χ0) + EZ[lnp(X,Z|η)] + const (10.117)

�N

�

�

= ν0 lng(η) + ηTχ0 +

lng(η) + ηTEz

[u(xn,zn)]

+ const. (10.118)

n

n=1

Again, taking the exponential of both sides, and re-instating the normalization coefﬁcient by inspection, we have

�

�

q�(η) = f(νN,χN)g(η)νN exp

ηTχN

(10.119) where we have deﬁned

νN = ν0 + N (10.120)

�N

χN = χ0 +

[u(xn,zn)]. (10.121)

Ez

n

n=1

Note that the solutions for q�(zn) and q�(η) are coupled, and so we solve them iteratively in a two-stage procedure. In the variational E step, we evaluate the expected

sufﬁcient statistics E[u(xn,zn)] using the current posterior distribution q(zn) over the latent variables and use this to compute a revised posterior distribution q(η) over the parameters. Then in the subsequent variational M step, we use this revised parameter posterior distribution to ﬁnd the expected natural parameters E[ηT], which gives rise to a revised variational distribution over the latent variables.

10.4.1 Variational message passing

We have illustrated the application of variational methods by considering a speciﬁc model, the Bayesian mixture of Gaussians, in some detail. This model can be
