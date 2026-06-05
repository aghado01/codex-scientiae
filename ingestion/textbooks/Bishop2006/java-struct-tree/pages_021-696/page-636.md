[Page 636]

exponentially with the length of the chain. In fact, the summation in (13.11) corresponds to summing over exponentially many paths through the lattice diagram in Figure 13.7.

We have already encountered a similar difﬁculty when we considered the inference problem for the simple chain of variables in Figure 8.32. There we were able to make use of the conditional independence properties of the graph to re-order the summations in order to obtain an algorithm whose cost scales linearly, instead of exponentially, with the length of the chain. We shall apply a similar technique to the hidden Markov model.

A further difﬁculty with the expression (13.11) for the likelihood function is that, because it corresponds to a generalization of a mixture distribution, it represents a summation over the emission models for different settings of the latent variables. Direct maximization of the likelihood function will therefore lead to complex ex-

Section 9.2 pressions with no closed-form solutions, as was the case for simple mixture models

(recall that a mixture model for i.i.d. data is a special case of the HMM).

We therefore turn to the expectation maximization algorithm to ﬁnd an efﬁcient framework for maximizing the likelihood function in hidden Markov models. The EM algorithm starts with some initial selection for the model parameters, which we denote by θold. In the E step, we take these parameter values and ﬁnd the posterior distribution of the latent variables p(Z|X,θold). We then use this posterior distribution to evaluate the expectation of the logarithm of the complete-data likelihood function, as a function of the parameters θ, to give the function Q(θ,θold) deﬁned by

�

Q(θ,θold) =

p(Z|X,θold)lnp(X,Z|θ). (13.12)

Z

At this point, it is convenient to introduce some notation. We shall use γ(zn) to denote the marginal posterior distribution of a latent variable zn, and ξ(zn−1,zn) to denote the joint posterior distribution of two successive latent variables, so that

γ(zn) = p(zn|X,θold) (13.13) ξ(zn−1,zn) = p(zn−1,zn|X,θold). (13.14)

For each value of n, we can store γ(zn) using a set of K nonnegative numbers that sum to unity, and similarly we can store ξ(zn−1,zn) using a K × K matrix of nonnegative numbers that again sum to unity. We shall also use γ(znk) to denote the conditional probability of znk = 1, with a similar use of notation for ξ(zn−1,j,znk) and for other probabilistic variables introduced later. Because the expectation of a binary random variable is just the probability that it takes the value 1, we have

�

γ(znk) = E[znk] =

γ(z)znk (13.15)

z

�

ξ(zn−1,j,znk) = E[zn−1,jznk] =

γ(z)zn−1,jznk. (13.16)

z

If we substitute the joint distribution p(X,Z|θ) given by (13.10) into (13.12),
