[Page 523]

Speciﬁcally, we consider once again a simple isotropic Gaussian prior distribution of the form

p(w|α) = N(w|0,α−1I). (10.165) Our analysis is readily extended to more general Gaussian priors, for instance if we wish to associate a different hyperparameter with different subsets of the parameters wj. As usual, we consider a conjugate hyperprior over α given by a gamma distribution

p(α) = Gam(α|a0,b0) (10.166) governed by the constants a0 and b0.

The marginal likelihood for this model now takes the form

###### p(t) = p(w,α,t)dw dα (10.167)

where the joint distribution is given by

###### p(w,α,t) = p(t|w)p(w|α)p(α). (10.168)

We are now faced with an analytically intractable integration over w and α, which we shall tackle by using both the local and global variational approaches in the same model

To begin with, we introduce a variational distribution q(w,α), and then apply the decomposition (10.2), which in this instance takes the form

###### lnp(t) = L(q) + KL(q p) (10.169)

where the lower bound L(q) and the Kullback-Leibler divergence KL(q p) are deﬁned by

p(w,α,t) q(w,α)

L(q) = q(w,α)ln

dw dα (10.170)

p(w,α|t)) q(w,α)

KL(q p) = − q(w,α)ln

dw dα. (10.171)

At this point, the lower bound L(q) is still intractable due to the form of the likelihood factor p(t|w). We therefore apply the local variational bound to each of the logistic sigmoid factors as before. This allows us to use the inequality (10.152) and place a lower bound on L(q), which will therefore also be a lower bound on the log marginal likelihood

lnp(t) L(q) L(q,ξ) = q(w,α)ln

h(w,ξ)p(w|α)p(α) q(w,α)

dw dα. (10.172)

Next we assume that the variational distribution factorizes between parameters and hyperparameters so that

###### q(w,α) = q(w)q(α). (10.173)
