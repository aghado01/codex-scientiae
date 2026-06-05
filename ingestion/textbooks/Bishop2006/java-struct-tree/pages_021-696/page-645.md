[Page 645]

Figure 13.14 A fragment of the factor graph representation for the hidden Markov model.

z1 zn−1 zn

χ ψn

g1 gn−1 gn

x1 xn−1 xn

Note that in (13.44), the inﬂuence of all data from x1 to xN is summarized in the K values of α(zN). Thus the predictive distribution can be carried forward indeﬁnitely using a ﬁxed amount of storage, as may be required for real-time applications.

Here we have discussed the estimation of the parameters of an HMM using maximum likelihood. This framework is easily extended to regularized maximum likelihood by introducing priors over the model parameters π, A and φ whose values are then estimated by maximizing their posterior probability. This can again be done using the EM algorithm in which the E step is the same as discussed above, and the M step involves adding the log of the prior distribution p(θ) to the function Q(θ,θold) before maximization and represents a straightforward application of the techniques developed at various points in this book. Furthermore, we can use variational meth-

Section 10.1 ods to give a fully Bayesian treatment of the HMM in which we marginalize over the parameter distributions (MacKay, 1997). As with maximum likelihood, this leads to a two-pass forward-backward recursion to compute posterior probabilities.

13.2.3 The sum-product algorithm for the HMM

The directed graph that represents the hidden Markov model, shown in Figure 13.5, is a tree and so we can solve the problem of ﬁnding local marginals for the

Section 8.4.4 hidden variables using the sum-product algorithm. Not surprisingly, this turns out to be equivalent to the forward-backward algorithm considered in the previous section, and so the sum-product algorithm therefore provides us with a simple way to derive the alpha-beta recursion formulae.

We begin by transforming the directed graph of Figure 13.5 into a factor graph, of which a representative fragment is shown in Figure 13.14. This form of the factor graph shows all variables, both latent and observed, explicitly. However, for the purpose of solving the inference problem, we shall always be conditioning on the variables x1,...,xN, and so we can simplify the factor graph by absorbing the emission probabilities into the transition probability factors. This leads to the simpliﬁed factor graph representation in Figure 13.15, in which the factors are given by

h(z1) = p(z1)p(x1|z1) (13.45) fn(zn−1,zn) = p(zn|zn−1)p(xn|zn). (13.46)
