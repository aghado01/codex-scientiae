[Page 478]

9.18 (��) Consider a Bernoulli mixture model as discussed in Section 9.3.3, together

with a prior distribution p(µk|ak,bk) over each of the parameter vectors µk given by the beta distribution (2.13), and a Dirichlet prior p(π|α) given by (2.38). Derive the EM algorithm for maximizing the posterior probability p(µ,π|X).

9.19 (��) Consider a D-dimensional variable x each of whose components i is itself a

multinomial variable of degree M so that x is a binary vector with components xij where i = 1,...,D and j = 1,...,M, subject to the constraint that

�

j xij = 1 for all i. Suppose that the distribution of these variables is described by a mixture of the discrete multinomial distributions considered in Section 2.2 so that

�K

πkp(x|µk) (9.84)

p(x) =

k=1

where

�D

�M

µxkijij. (9.85)

p(x|µk) =

i=1

j=1

The parameters µkij represent the probabilities p(xij = 1|µk) and must satisfy 0 � µkij � 1 together with the constraint

�

j µkij = 1 for all values of k and i. Given an observed data set {xn}, where n = 1,...,N, derive the E and M step equations of the EM algorithm for optimizing the mixing coefﬁcients πk and the component parameters µkij of this distribution by maximum likelihood.

9.20 (�) www Show that maximization of the expected complete-data log likelihood function (9.62) for the Bayesian linear regression model leads to the M step reestimation result (9.63) for α.

9.21 (��) Using the evidence framework of Section 3.5, derive the M-step re-estimation equations for the parameter β in the Bayesian linear regression model, analogous to the result (9.63) for α.

9.22 (��) By maximization of the expected complete-data log likelihood deﬁned by (9.66), derive the M step equations (9.67) and (9.68) for re-estimating the hyperparameters of the relevance vector machine for regression.

9.23 (��) www In Section 7.2.1 we used direct maximization of the marginal likelihood to derive the re-estimation equations (7.87) and (7.88) for ﬁnding values of the hyperparameters α and β for the regression RVM. Similarly, in Section 9.3.4 we used the EM algorithm to maximize the same marginal likelihood, giving the re-estimation equations (9.67) and (9.68). Show that these two sets of re-estimation equations are formally equivalent.

9.24 (�) Verify the relation (9.70) in which L(q,θ) and KL(q�p) are deﬁned by (9.71)

and (9.72), respectively.
