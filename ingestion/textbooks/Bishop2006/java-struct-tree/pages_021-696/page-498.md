[Page 498]

Identifying the terms on the right-hand side of (10.54) that depend on π, we have

�K

�K

�N

lnq�(π) = (α0 − 1)

lnπk +

rnk lnπk + const (10.56)

n=1

k=1

k=1

where we have used (10.50). Taking the exponential of both sides, we recognize q�(π) as a Dirichlet distribution

q�(π) = Dir(π|α) (10.57) where α has components αk given by

αk = α0 + Nk. (10.58)

Finally, the variational posterior distribution q�(µk,Λk) does not factorize into the product of the marginals, but we can always use the product rule to write it in the form q�(µk,Λk) = q�(µk|Λk)q�(Λk). The two factors can be found by inspecting (10.54) and reading off those terms that involve µk and Λk. The result, as expected,

Exercise 10.13 is a Gaussian-Wishart distribution and is given by

µk|mk,(βkΛk)−1� W(Λk|Wk,νk) (10.59) where we have deﬁned

q�(µk,Λk) = N �

βk = β0 + Nk (10.60) mk =

1 βk

(β0m0 + Nkxk) (10.61)

β0Nk β0 + Nk

W−1

k = W−1

(xk − m0)(xk − m0)T (10.62) νk = ν0 + Nk. (10.63)

0 + NkSk +

These update equations are analogous to the M-step equations of the EM algorithm for the maximum likelihood solution of the mixture of Gaussians. We see that the computations that must be performed in order to update the variational posterior distribution over the model parameters involve evaluation of the same sums over the data set, as arose in the maximum likelihood treatment.

In order to perform this variational M step, we need the expectations E[znk] = rnk representing the responsibilities. These are obtained by normalizing the ρnk that are given by (10.46). We see that this expression involves expectations with respect to the variational distributions of the parameters, and these are easily evaluated to

Exercise 10.14 give

�

�

(xn − µk)TΛk(xn − µk)

Eµ

k,Λk

= Dβk−1 + νk(xn − mk)TWk(xn − mk) (10.64) lnΛ�k ≡ E[ln|Λk|] =

� + D ln2 + ln|Wk| (10.65) lnπ�k ≡ E[lnπk] = ψ(αk) − ψ(α�) (10.66)

ψ �

�D

νk + 1 − i 2

i=1
