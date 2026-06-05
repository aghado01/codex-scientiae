[Page 556]

evaluated directly using the original samples together with the weights, because

E[f(z)] = f(z)p(z)dz

=

f(z)[ p(z)/q(z)]q(z)dz

[ p(z)/q(z)]q(z)dz

L

wlf(zl). (11.27)

l=1

###### 11.1.6 Sampling and the EM algorithm

In addition to providing a mechanism for direct implementation of the Bayesian framework, Monte Carlo methods can also play a role in the frequentist paradigm, for example to ﬁnd maximum likelihood solutions. In particular, sampling methods can be used to approximate the E step of the EM algorithm for models in which the E step cannot be performed analytically. Consider a model with hidden variables Z, visible (observed) variables X, and parameters θ. The function that is optimized with respect to θ in the M step is the expected complete-data log likelihood, given by

Q(θ,θold) = p(Z|X,θold)lnp(Z,X|θ)dZ. (11.28)

We can use sampling methods to approximate this integral by a ﬁnite sum over samples {Z(l)}, which are drawn from the current estimate for the posterior distribution p(Z|X,θold), so that

L

1 L

Q(θ,θold)

lnp(Z(l),X|θ). (11.29)

l=1

The Q function is then optimized in the usual way in the M step. This procedure is called the Monte Carlo EM algorithm.

It is straightforward to extend this to the problem of ﬁnding the mode of the posterior distribution over θ (the MAP estimate) when a prior distribution p(θ) has been deﬁned, simply by adding lnp(θ) to the function Q(θ,θold) before performing the M step.

A particular instance of the Monte Carlo EM algorithm, called stochastic EM, arises if we consider a ﬁnite mixture model, and draw just one sample at each E step. Here the latent variable Z characterizes which of the K components of the mixture is responsible for generating each data point. In the E step, a sample of Z is taken from the posterior distribution p(Z|X,θold) where X is the data set. This effectively makes a hard assignment of each data point to one of the components in the mixture. In the M step, this sampled approximation to the posterior distribution is used to update the model parameters in the usual way.
