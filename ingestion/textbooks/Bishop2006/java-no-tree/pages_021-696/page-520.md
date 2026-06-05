[Page 520]

This is a quadratic function of w, and so we can obtain the corresponding variational approximation to the posterior distribution by identifying the linear and quadratic terms in w, giving a Gaussian variational posterior of the form

q(w) = N(w|mN,SN) (10.156) where

N

mN = SN S−1

0 m0 +

(tn − 1/2)φn (10.157)

n=1

N

S−1

N = S−1

0 + 2

λ(ξn)φnφTn. (10.158)

n=1

As with the Laplace framework, we have again obtained a Gaussian approximation to the posterior distribution. However, the additional ﬂexibility provided by the variational parameters {ξn} leads to improved accuracy in the approximation (Jaakkola and Jordan, 2000).

Here we have considered a batch learning context in which all of the training data is available at once. However, Bayesian methods are intrinsically well suited to sequential learning in which the data points are processed one at a time and then discarded. The formulation of this variational approach for the sequential case is

- Exercise 10.32 straightforward. Note that the bound given by (10.149) applies only to the two-class problem and


so this approach does not directly generalize to classiﬁcation problems with K > 2 classes. An alternative bound for the multiclass case has been explored by Gibbs (1997).

###### 10.6.2 Optimizing the variational parameters

We now have a normalized Gaussian approximation to the posterior distribution, which we shall use shortly to evaluate the predictive distribution for new data points. First, however, we need to determine the variational parameters {ξn} by maximizing the lower bound on the marginal likelihood.

To do this, we substitute the inequality (10.152) back into the marginal likelihood to give

lnp(t) = ln p(t|w)p(w)dw ln h(w,ξ)p(w)dw = L(ξ). (10.159)

As with the optimization of the hyperparameter α in the linear regression model of Section 3.5, there are two approaches to determining the ξn. In the ﬁrst approach, we recognize that the function L(ξ) is deﬁned by an integration over w and so we can view w as a latent variable and invoke the EM algorithm. In the second approach, we integrate over w analytically and then perform a direct maximization over ξ. Let us begin by considering the EM approach.

The EM algorithm starts by choosing some initial values for the parameters {ξn}, which we denote collectively by ξold. In the E step of the EM algorithm,
