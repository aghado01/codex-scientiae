[Page 662]

###### 13.3.2 Learning in LDS

So far, we have considered the inference problem for linear dynamical systems, assuming that the model parameters θ = {A,Γ,C,Σ,µ0,V0} are known. Next, we consider the determination of these parameters using maximum likelihood (Ghahramani and Hinton, 1996b). Because the model has latent variables, this can be addressed using the EM algorithm, which was discussed in general terms in Chapter 9.

We can derive the EM algorithm for the linear dynamical system as follows. Let us denote the estimated parameter values at some particular cycle of the algorithm by θold. For these parameter values, we can run the inference algorithm to determine the posterior distribution of the latent variables p(Z|X,θold), or more precisely those local posterior marginals that are required in the M step. In particular, we shall require the following expectations

E[zn] = µn (13.105) E znzTn−1 = Jn−1 Vn + µn µTn−1 (13.106)

E znzTn = Vn + µn µTn (13.107) where we have used (13.104).

Now we consider the complete-data log likelihood function, which is obtained by taking the logarithm of (13.6) and is therefore given by

N

lnp(X,Z|θ) = lnp(z1|µ0,V0) +

lnp(zn|zn−1,A,Γ)

n=2

N

lnp(xn|zn,C,Σ) (13.108)

+

n=1

in which we have made the dependence on the parameters explicit. We now take the expectation of the complete-data log likelihood with respect to the posterior distribution p(Z|X,θold) which deﬁnes the function

Q(θ,θold) = EZ|θold [lnp(X,Z|θ)]. (13.109) In the M step, this function is maximized with respect to the components of θ.

Consider ﬁrst the parameters µ0 and V0. If we substitute for p(z1|µ0,V0) in (13.108) using (13.77), and then take the expectation with respect to Z, we obtain

1 2

Q(θ,θold) = −

ln|V0| − EZ|θold

1 2

(z1 − µ0)TV−1

0 (z1 − µ0) + const

where all terms not dependent on µ0 or V0 have been absorbed into the additive constant. Maximization with respect to µ0 and V0 is easily performed by making use of the maximum likelihood solution for a Gaussian distribution discussed in

- Exercise 13.32 Section 2.3.4, giving
