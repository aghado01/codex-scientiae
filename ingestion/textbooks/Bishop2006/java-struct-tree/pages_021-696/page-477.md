[Page 477]

9.11 (�) In Section 9.3.2, we obtained a relationship between K means and EM for Gaussian mixtures by considering a mixture model in which all components have covariance �I. Show that in the limit � → 0, maximizing the expected completedata log likelihood for this model, given by (9.40), is equivalent to minimizing the distortion measure J for the K-means algorithm given by (9.1).

9.12 (�) www Consider a mixture distribution of the form

�K

πkp(x|k) (9.82)

p(x) =

k=1

where the elements of x could be discrete or continuous or a combination of these. Denote the mean and covariance of p(x|k) by µk and Σk, respectively. Show that the mean and covariance of the mixture distribution are given by (9.49) and (9.50).

9.13 (��) Using the re-estimation equations for the EM algorithm, show that a mixture of Bernoulli distributions, with its parameters set to values corresponding to a maximum of the likelihood function, has the property that

�N

1 N

E[x] =

xn ≡ x. (9.83)

n=1

Hence show that if the parameters of this model are initialized such that all components have the same mean µk = µ� for k = 1,...,K, then the EM algorithm will converge after one iteration, for any choice of the initial mixing coefﬁcients, and that this solution has the property µk = x. Note that this represents a degenerate case of the mixture model in which all of the components are identical, and in practice we try to avoid such solutions by using an appropriate initialization.

9.14 (�) Consider the joint distribution of latent and observed variables for the Bernoulli distribution obtained by forming the product of p(x|z,µ) given by (9.52) and p(z|π) given by (9.53). Show that if we marginalize this joint distribution with respect to z, then we obtain (9.47).

9.15 (�) www Show that if we maximize the expected complete-data log likelihood

function (9.55) for a mixture of Bernoulli distributions with respect to µk, we obtain the M step equation (9.59).

9.16 (�) Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to the mixing coefﬁcients πk, using a Lagrange multiplier to enforce the summation constraint, we obtain the M step equation (9.60).

9.17 (�) www Show that as a consequence of the constraint 0 � p(xn|µk) � 1 for the discrete variable xn, the incomplete-data log likelihood function for a mixture of Bernoulli distributions is bounded above, and hence that there are no singularities for which the likelihood goes to inﬁnity.
