[Page 493]

qµ(µ) in the form

1 NE[τ]

E[µ] = x, E[µ2] = x2 +

. (10.32)

Exercise 10.9 We can now substitute these moments into (10.31) and then solve for E[τ] to give

1 E[τ]

1 N − 1

=

(x2 − x2)

�N

1 N − 1

(xn − x)2. (10.33)

=

n=1

We recognize the right-hand side as the familiar unbiased estimator for the variance of a univariate Gaussian distribution, and so we see that the use of a Bayesian ap-

Section 1.2.4 proach has avoided the bias of the maximum likelihood solution.

10.1.4 Model comparison

As well as performing inference over the hidden variables Z, we may also wish to compare a set of candidate models, labelled by the index m, and having prior probabilities p(m). Our goal is then to approximate the posterior probabilities p(m|X), where X is the observed data. This is a slightly more complex situation than that considered so far because different models may have different structure and indeed different dimensionality for the hidden variables Z. We cannot therefore simply consider a factorized approximation q(Z)q(m), but must instead recognize that the posterior over Z must be conditioned on m, and so we must consider q(Z,m) = q(Z|m)q(m). We can readily verify the following decomposition based

Exercise 10.10 on this variational distribution

q(Z|m)q(m)ln�

� (10.34)

lnp(X) = Lm − �

�

p(Z,m|X) q(Z|m)q(m)

m

Z

where the Lm is a lower bound on lnp(X) and is given by

q(Z|m)q(m)ln�

�. (10.35)

�

�

p(Z,X,m) q(Z|m)q(m)

Lm =

m

Z

Here we are assuming discrete Z, but the same analysis applies to continuous latent variables provided the summations are replaced with integrations. We can maximize

Exercise 10.11 Lm with respect to the distribution q(m) using a Lagrange multiplier, with the result q(m) ∝ p(m)exp{Lm}. (10.36)

However, if we maximize Lm with respect to the q(Z|m), we ﬁnd that the solutions for different m are coupled, as we expect because they are conditioned on m. We proceed instead by ﬁrst optimizing each of the q(Z|m) individually by optimization
