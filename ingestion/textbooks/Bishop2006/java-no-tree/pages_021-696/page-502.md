[Page 502]

- E[lnp(µ,Λ)] =

1 2

K

k=1

D ln(β0/2π) + ln Λk −

Dβ0 βk

−β0νk(mk − m0)TWk(mk − m0) + K lnB(W0,ν0)

+

(ν0 − D − 1) 2

K

k=1

ln Λk −

1 2

K

k=1

νkTr(W−1

0 Wk) (10.74)

- E[lnq(Z)] =


N

n=1

K

- E[lnq(π)] =


k=1

K

- E[lnq(µ,Λ)] =


k=1

###### K

rnk lnrnk (10.75)

k=1

(αk − 1)ln πk + lnC(α) (10.76)

1 2

D 2

ln Λk +

ln

βk 2π −

D 2 − H[q(Λk)] (10.77)

where D is the dimensionality of x, H[q(Λk)] is the entropy of the Wishart distribution given by (B.82), and the coefﬁcients C(α) and B(W,ν) are deﬁned by (B.23) and (B.79), respectively. Note that the terms involving expectations of the logs of the q distributions simply represent the negative entropies of those distributions. Some simpliﬁcations and combination of terms can be performed when these expressions are summed to give the lower bound. However, we have kept the expressions separate for ease of understanding.

Finally, it is worth noting that the lower bound provides an alternative approach for deriving the variational re-estimation equations obtained in Section 10.2.1. To do this we use the fact that, since the model has conjugate priors, the functional form of the factors in the variational posterior distribution is known, namely discrete for Z, Dirichlet for π, and Gaussian-Wishart for (µk,Λk). By taking general parametric forms for these distributions we can derive the form of the lower bound as a function of the parameters of the distributions. Maximizing the bound with respect to these

- Exercise 10.18 parameters then gives the required re-estimation equations.


###### 10.2.3 Predictive density

In applications of the Bayesian mixture of Gaussians model we will often be interested in the predictive density for a new value x of the observed variable. Associated with this observation will be a corresponding latent variable z, and the predictive density is then given by

###### p( x|X) =

bz

###### p( x| z,µ,Λ)p( z|π)p(π,µ,Λ|X)dπ dµdΛ (10.78)
