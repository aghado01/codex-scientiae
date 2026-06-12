[Page 470]

1 m2i + Σii

αinew =

(9.67)

�

(βnew)−1 = �t − ΦmN�2 + β−1

i γi N

(9.68)

These re-estimation equations are formally equivalent to those obtained by direct Exercise 9.23 maxmization.

9.4. The EM Algorithm in General

The expectation maximization algorithm, or EM algorithm, is a general technique for ﬁnding maximum likelihood solutions for probabilistic models having latent variables (Dempster et al., 1977; McLachlan and Krishnan, 1997). Here we give a very general treatment of the EM algorithm and in the process provide a proof that the EM algorithm derived heuristically in Sections 9.2 and 9.3 for Gaussian mixtures does indeed maximize the likelihood function (Csiszar and Tusn` ady, 1984; Hath-` away, 1986; Neal and Hinton, 1999). Our discussion will also form the basis for the

Section 10.1 derivation of the variational inference framework.

Consider a probabilistic model in which we collectively denote all of the observed variables by X and all of the hidden variables by Z. The joint distribution p(X,Z|θ) is governed by a set of parameters denoted θ. Our goal is to maximize the likelihood function that is given by

�

p(X,Z|θ). (9.69)

p(X|θ) =

Z

Here we are assuming Z is discrete, although the discussion is identical if Z comprises continuous variables or a combination of discrete and continuous variables, with summation replaced by integration as appropriate.

We shall suppose that direct optimization of p(X|θ) is difﬁcult, but that optimization of the complete-data likelihood function p(X,Z|θ) is signiﬁcantly easier. Next we introduce a distribution q(Z) deﬁned over the latent variables, and we observe that, for any choice of q(Z), the following decomposition holds

lnp(X|θ) = L(q,θ) + KL(q�p) (9.70) where we have deﬁned

q(Z)ln�

� (9.71)

�

p(X,Z|θ) q(Z)

L(q,θ) =

Z

q(Z)ln�

�. (9.72)

KL(q�p) = −�

p(Z|X,θ) q(Z)

Z

Note that L(q,θ) is a functional (see Appendix D for a discussion of functionals) of the distribution q(Z), and a function of the parameters θ. It is worth studying
