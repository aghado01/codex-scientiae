[Page 482]

analytical solutions, while the dimensionality of the space and the complexity of the integrand may prohibit numerical integration. For discrete variables, the marginalizations involve summing over all possible conﬁgurations of the hidden variables, and though this is always possible in principle, we often ﬁnd in practice that there may be exponentially many hidden states so that exact calculation is prohibitively expensive.

In such situations, we need to resort to approximation schemes, and these fall broadly into two classes, according to whether they rely on stochastic or deterministic approximations. Stochastic techniques such as Markov chain Monte Carlo, described in Chapter 11, have enabled the widespread use of Bayesian methods across many domains. They generally have the property that given inﬁnite computational resource, they can generate exact results, and the approximation arises from the use of a ﬁnite amount of processor time. In practice, sampling methods can be computationally demanding, often limiting their use to small-scale problems. Also, it can be difﬁcult to know whether a sampling scheme is generating independent samples from the required distribution.

In this chapter, we introduce a range of deterministic approximation schemes, some of which scale well to large applications. These are based on analytical approximations to the posterior distribution, for example by assuming that it factorizes in a particular way or that it has a speciﬁc parametric form such as a Gaussian. As such, they can never generate exact results, and so their strengths and weaknesses are complementary to those of sampling methods.

In Section 4.4, we discussed the Laplace approximation, which is based on a local Gaussian approximation to a mode (i.e., a maximum) of the distribution. Here we turn to a family of approximation techniques called variational inference or variational Bayes, which use more global criteria and which have been widely applied. We conclude with a brief introduction to an alternative variational framework known as expectation propagation.

10.1. Variational Inference

Variational methods have their origins in the 18th century with the work of Euler, Lagrange, and others on the calculus of variations. Standard calculus is concerned with ﬁnding derivatives of functions. We can think of a function as a mapping that takes the value of a variable as the input and returns the value of the function as the output. The derivative of the function then describes how the output value varies as we make inﬁnitesimal changes to the input value. Similarly, we can deﬁne a functional as a mapping that takes a function as the input and that returns the value of the functional as the output. An example would be the entropy H[p], which takes a probability distribution p(x) as the input and returns the quantity

H[p] = � p(x)lnp(x)dx (10.1)
