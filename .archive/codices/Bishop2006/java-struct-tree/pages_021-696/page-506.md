[Page 506]

is satisﬁed. We can test to see if this relation does hold, for any choice of A and B by making use of the d-separation criterion.

To illustrate this, consider again the Bayesian mixture of Gaussians represented by the directed graph in Figure 10.5, in which we are assuming a variational factorization given by (10.42). We can see immediately that the variational posterior distribution over the parameters must factorize between π and the remaining parameters µ and Λ because all paths connecting π to either µ or Λ must pass through one of the nodes zn all of which are in the conditioning set for our conditional independence test and all of which are head-to-tail with respect to such paths.

10.3. Variational Linear Regression

As a second illustration of variational inference, we return to the Bayesian linear regression model of Section 3.3. In the evidence framework, we approximated the integration over α and β by making point estimates obtained by maximizing the log marginal likelihood. A fully Bayesian approach would integrate over the hyperparameters as well as over the parameters. Although exact integration is intractable, we can use variational methods to ﬁnd a tractable approximation. In order to simplify the discussion, we shall suppose that the noise precision parameter β is known, and is ﬁxed to its true value, although the framework is easily extended to include

Exercise 10.26 the distribution over β. For the linear regression model, the variational treatment will turn out to be equivalent to the evidence framework. Nevertheless, it provides a good exercise in the use of variational methods and will also lay the foundation for variational treatment of Bayesian logistic regression in Section 10.6.

Recall that the likelihood function for w, and the prior over w, are given by

�N

N(tn|wTφn,β−1) (10.87) p(w|α) = N(w|0,α−1I) (10.88)

p(t|w) =

n=1

where φn = φ(xn). We now introduce a prior distribution over α. From our discussion in Section 2.3.6, we know that the conjugate prior for the precision of a Gaussian is given by a gamma distribution, and so we choose

p(α) = Gam(α|a0,b0) (10.89)

where Gam(·|·,·) is deﬁned by (B.26). Thus the joint distribution of all the variables is given by

p(t,w,α) = p(t|w)p(w|α)p(α). (10.90) This can be represented as a directed graphical model as shown in Figure 10.8.

10.3.1 Variational distribution

Our ﬁrst goal is to ﬁnd an approximation to the posterior distribution p(w,α|t). To do this, we employ the variational framework of Section 10.1, with a variational
