[Page 503]

where p(π,µ,Λ|X) is the (unknown) true posterior distribution of the parameters. Using (10.37) and (10.38) we can ﬁrst perform the summation over �z to give

��� πkN �

�K

�

x�|µk,Λ−1

p(x�|X) =

p(π,µ,Λ|X)dπ dµdΛ. (10.79)

k

k=1

Because the remaining integrations are intractable, we approximate the predictive density by replacing the true posterior distribution p(π,µ,Λ|X) with its variational approximation q(π)q(µ,Λ) to give

��� πkN �

�K

�

x�|µk,Λ−1

p(x�|X) =

q(π)q(µk,Λk)dπ dµk dΛk (10.80)

k

k=1

where we have made use of the factorization (10.55) and in each term we have implicitly integrated out all variables {µj,Λj} for j �= k The remaining integrations

Exercise 10.19 can now be evaluated analytically giving a mixture of Student’s t-distributions

�K

1 α�

p(x�|X) =

αkSt(x�|mk,Lk,νk + 1 − D) (10.81)

k=1

in which the kth component has mean mk, and the precision is given by

(νk + 1 − D)βk (1 + βk)

Lk =

Wk (10.82) in which νk is given by (10.63). When the size N of the data set is large the predictive

Exercise 10.20 distribution (10.81) reduces to a mixture of Gaussians.

10.2.4 Determining the number of components

We have seen that the variational lower bound can be used to determine a pos-

Section 10.1.4 terior distribution over the number K of components in the mixture model. There is, however, one subtlety that needs to be addressed. For any given setting of the parameters in a Gaussian mixture model (except for speciﬁc degenerate settings), there will exist other parameter settings for which the density over the observed variables will be identical. These parameter values differ only through a re-labelling of the components. For instance, consider a mixture of two Gaussians and a single observed variable x, in which the parameters have the values π1 = a, π2 = b, µ1 = c, µ2 = d, σ1 = e, σ2 = f. Then the parameter values π1 = b, π2 = a, µ1 = d, µ2 = c, σ1 = f, σ2 = e, in which the two components have been exchanged, will by symmetry give rise to the same value of p(x). If we have a mixture model comprising K components, then each parameter setting will be a member of a family of

Exercise 10.21 K! equivalent settings.

In the context of maximum likelihood, this redundancy is irrelevant because the parameter optimization algorithm (for example EM) will, depending on the initialization of the parameters, ﬁnd one speciﬁc solution, and the other equivalent solutions play no role. In a Bayesian setting, however, we marginalize over all possible
