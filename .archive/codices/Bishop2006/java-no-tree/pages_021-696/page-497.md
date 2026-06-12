[Page 497]

where

ρnk K

rnk =

. (10.49)

ρnj

j=1

We see that the optimal solution for the factor q(Z) takes the same functional form as the prior p(Z|π). Note that because ρnk is given by the exponential of a real quantity, the quantities rnk will be nonnegative and will sum to one, as required.

For the discrete distribution q (Z) we have the standard result

###### E[znk] = rnk (10.50)

from which we see that the quantities rnk are playing the role of responsibilities. Note that the optimal solution for q (Z) depends on moments evaluated with respect to the distributions of other variables, and so again the variational update equations are coupled and must be solved iteratively.

At this point, we shall ﬁnd it convenient to deﬁne three statistics of the observed data set evaluated with respect to the responsibilities, given by

N

Nk =

rnk (10.51)

n=1

N

1 Nk

xk =

rnkxn (10.52)

n=1

N

1 Nk

Sk =

rnk(xn − xk)(xn − xk)T. (10.53)

n=1

Note that these are analogous to quantities evaluated in the maximum likelihood EM algorithm for the Gaussian mixture model.

Now let us consider the factor q(π,µ,Λ) in the variational posterior distribution. Again using the general result (10.9) we have

K

lnq (π,µ,Λ) = lnp(π) +

lnp(µk,Λk) + EZ [lnp(Z|π)]

k=1

K

###### N

E[znk]lnN xn|µk,Λ−1

k + const. (10.54)

+

n=1

k=1

We observe that the right-hand side of this expression decomposes into a sum of terms involving only π together with terms only involving µ and Λ, which implies that the variational posterior q(π,µ,Λ) factorizes to give q(π)q(µ,Λ). Furthermore, the terms involving µ and Λ themselves comprise a sum over k of terms involving µk and Λk leading to the further factorization

q(π,µ,Λ) = q(π)

K

q(µk,Λk). (10.55)
