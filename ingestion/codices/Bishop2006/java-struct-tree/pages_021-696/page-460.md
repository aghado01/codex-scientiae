[Page 460]

family, the marginal distribution p(X|θ) typically does not as a result of this summation. The presence of the sum prevents the logarithm from acting directly on the joint distribution, resulting in complicated expressions for the maximum likelihood solution.

Now suppose that, for each observation in X, we were told the corresponding value of the latent variable Z. We shall call {X,Z} the complete data set, and we shall refer to the actual observed data X as incomplete, as illustrated in Figure 9.5. The likelihood function for the complete data set simply takes the form lnp(X,Z|θ), and we shall suppose that maximization of this complete-data log likelihood function is straightforward.

In practice, however, we are not given the complete data set {X,Z}, but only the incomplete data X. Our state of knowledge of the values of the latent variables in Z is given only by the posterior distribution p(Z|X,θ). Because we cannot use the complete-data log likelihood, we consider instead its expected value under the posterior distribution of the latent variable, which corresponds (as we shall see) to the E step of the EM algorithm. In the subsequent M step, we maximize this expectation. If the current estimate for the parameters is denoted θold, then a pair of successive E and M steps gives rise to a revised estimate θnew. The algorithm is initialized by choosing some starting value for the parameters θ0. The use of the expectation may seem somewhat arbitrary. However, we shall see the motivation for this choice when we give a deeper treatment of EM in Section 9.4.

In the E step, we use the current parameter values θold to ﬁnd the posterior distribution of the latent variables given by p(Z|X,θold). We then use this posterior distribution to ﬁnd the expectation of the complete-data log likelihood evaluated for some general parameter value θ. This expectation, denoted Q(θ,θold), is given by

�

Q(θ,θold) =

p(Z|X,θold)lnp(X,Z|θ). (9.30)

Z

In the M step, we determine the revised parameter estimate θnew by maximizing this function

θnew = arg max

Q(θ,θold). (9.31)

θ

Note that in the deﬁnition of Q(θ,θold), the logarithm acts directly on the joint distribution p(X,Z|θ), and so the corresponding M-step maximization will, by supposition, be tractable.

The general EM algorithm is summarized below. It has the property, as we shall show later, that each cycle of EM will increase the incomplete-data log likelihood

Section 9.4 (unless it is already at a local maximum). The General EM Algorithm

Given a joint distribution p(X,Z|θ) over observed variables X and latent variables Z, governed by parameters θ, the goal is to maximize the likelihood function p(X|θ) with respect to θ.

1. Choose an initial setting for the parameters θold.
