[Page 496]

We now consider a variational distribution which factorizes between the latent variables and the parameters so that

q(Z,π,µ,Λ) = q(Z)q(π,µ,Λ). (10.42)

It is remarkable that this is the only assumption that we need to make in order to obtain a tractable practical solution to our Bayesian mixture model. In particular, the functional form of the factors q(Z) and q(π,µ,Λ) will be determined automatically by optimization of the variational distribution. Note that we are omitting the subscripts on the q distributions, much as we do with the p distributions in (10.41), and are relying on the arguments to distinguish the different distributions.

The corresponding sequential update equations for these factors can be easily derived by making use of the general result (10.9). Let us consider the derivation of the update equation for the factor q(Z). The log of the optimized factor is given by

lnq�(Z) = Eπ,µ,Λ[lnp(X,Z,π,µ,Λ)] + const. (10.43)

We now make use of the decomposition (10.41). Note that we are only interested in the functional dependence of the right-hand side on the variable Z. Thus any terms that do not depend on Z can be absorbed into the additive normalization constant, giving

lnq�(Z) = Eπ[lnp(Z|π)] + Eµ,Λ[lnp(X|Z,µ,Λ)] + const. (10.44)

Substituting for the two conditional distributions on the right-hand side, and again absorbing any terms that are independent of Z into the additive constant, we have

�N

�K

lnq�(Z) =

znk lnρnk + const (10.45)

n=1

k=1

where we have deﬁned

1 2

D 2

lnρnk = E[lnπk] +

E[ln|Λk|] −

ln(2π) −

1 2

�

�

(xn − µk)TΛk(xn − µk)

(10.46)

Eµ

k,Λk

where D is the dimensionality of the data variable x. Taking the exponential of both sides of (10.45) we obtain

�N

�K

ρz

q�(Z) ∝

nk . (10.47)

nk

n=1

k=1

Requiring that this distribution be normalized, and noting that for each value of n Exercise 10.12 the quantities znk are binary and sum to 1 over all values of k, we obtain

�N

q�(Z) =

n=1

�K

rz

nk (10.48)

nk
