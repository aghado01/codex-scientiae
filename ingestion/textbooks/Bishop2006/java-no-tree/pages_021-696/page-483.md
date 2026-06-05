[Page 483]

as the output. We can the introduce the concept of a functional derivative, which expresses how the value of the functional changes in response to inﬁnitesimal changes to the input function (Feynman et al., 1964). The rules for the calculus of variations mirror those of standard calculus and are discussed in Appendix D. Many problems can be expressed in terms of an optimization problem in which the quantity being optimized is a functional. The solution is obtained by exploring all possible input functions to ﬁnd the one that maximizes, or minimizes, the functional. Variational methods have broad applicability and include such areas as ﬁnite element methods (Kapur, 1989) and maximum entropy (Schwarz, 1988).

Although there is nothing intrinsically approximate about variational methods, they do naturally lend themselves to ﬁnding approximate solutions. This is done by restricting the range of functions over which the optimization is performed, for instance by considering only quadratic functions or by considering functions composed of a linear combination of ﬁxed basis functions in which only the coefﬁcients of the linear combination can vary. In the case of applications to probabilistic inference, the restriction may for example take the form of factorization assumptions (Jordan et al., 1999; Jaakkola, 2001).

Now let us consider in more detail how the concept of variational optimization can be applied to the inference problem. Suppose we have a fully Bayesian model in which all parameters are given prior distributions. The model may also have latent variables as well as parameters, and we shall denote the set of all latent variables and parameters by Z. Similarly, we denote the set of all observed variables by X. For example, we might have a set of N independent, identically distributed data, for which X = {x1,...,xN} and Z = {z1,...,zN}. Our probabilistic model speciﬁes the joint distribution p(X,Z), and our goal is to ﬁnd an approximation for the posterior distribution p(Z|X) as well as for the model evidence p(X). As in our discussion of EM, we can decompose the log marginal probability using

lnp(X) = L(q) + KL(q p) (10.2) where we have deﬁned

p(X,Z) q(Z)

L(q) = q(Z)ln

dZ (10.3)

p(Z|X) q(Z)

KL(q p) = − q(Z)ln

dZ. (10.4)

This differs from our discussion of EM only in that the parameter vector θ no longer appears, because the parameters are now stochastic variables and are absorbed into Z. Since in this chapter we will mainly be interested in continuous variables we have used integrations rather than summations in formulating this decomposition. However, the analysis goes through unchanged if some or all of the variables are discrete simply by replacing the integrations with summations as required. As before, we can maximize the lower bound L(q) by optimization with respect to the distribution q(Z), which is equivalent to minimizing the KL divergence. If we allow any possible choice for q(Z), then the maximum of the lower bound occurs when the KL divergence vanishes, which occurs when q(Z) equals the posterior distribution p(Z|X).
