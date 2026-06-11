[Page 476]

9.3 (�) www Consider a Gaussian mixture model in which the marginal distribution p(z) for the latent variable is given by (9.10), and the conditional distribution p(x|z) for the observed variable is given by (9.11). Show that the marginal distribution p(x), obtained by summing p(z)p(x|z) over all possible values of z, is a Gaussian mixture of the form (9.7).

9.4 (�) Suppose we wish to use the EM algorithm to maximize the posterior distribution over parameters p(θ|X) for a model containing latent variables, where X is the observed data set. Show that the E step remains the same as in the maximum likelihood case, whereas in the M step the quantity to be maximized is given by Q(θ,θold) + lnp(θ) where Q(θ,θold) is deﬁned by (9.30).

9.5 (�) Consider the directed graph for a Gaussian mixture model shown in Figure 9.6. By making use of the d-separation criterion discussed in Section 8.2, show that the posterior distribution of the latent variables factorizes with respect to the different data points so that

�N

p(zn|xn,µ,Σ,π). (9.80)

p(Z|X,µ,Σ,π) =

n=1

9.6 (��) Consider a special case of a Gaussian mixture model in which the covari-

ance matrices Σk of the components are all constrained to have a common value Σ. Derive the EM equations for maximizing the likelihood function under such a model.

9.7 (�) www Verify that maximization of the complete-data log likelihood (9.36) for a Gaussian mixture model leads to the result that the means and covariances of each component are ﬁtted independently to the corresponding group of data points, and the mixing coefﬁcients are given by the fractions of points in each group.

9.8 (�) www Show that if we maximize (9.40) with respect to µk while keeping the

responsibilities γ(znk) ﬁxed, we obtain the closed form solution given by (9.17).

9.9 (�) Show that if we maximize (9.40) with respect to Σk and πk while keeping the responsibilities γ(znk) ﬁxed, we obtain the closed form solutions given by (9.19) and (9.22).

9.10 (��) Consider a density model given by a mixture distribution

�K

p(x) =

πkp(x|k) (9.81)

k=1

and suppose that we partition the vector x into two parts so that x = (xa,xb). Show that the conditional density p(xb|xa) is itself a mixture distribution and ﬁnd expressions for the mixing coefﬁcients and for the component densities.
