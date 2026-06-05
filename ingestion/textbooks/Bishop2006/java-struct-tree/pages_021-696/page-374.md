[Page 374]

where σ(·) is the logistic sigmoid function deﬁned by (4.59). If we introduce a Gaussian prior over the weight vector w, then we obtain the model that has been considered already in Chapter 4. The difference here is that in the RVM, this model uses the ARD prior (7.80) in which there is a separate precision hyperparameter associated with each weight parameter.

In contrast to the regression model, we can no longer integrate analytically over the parameter vector w. Here we follow Tipping (2001) and use the Laplace ap-

Section 4.4 proximation, which was applied to the closely related problem of Bayesian logistic

regression in Section 4.5.1.

We begin by initializing the hyperparameter vector α. For this given value of α, we then build a Gaussian approximation to the posterior distribution and thereby obtain an approximation to the marginal likelihood. Maximization of this approximate marginal likelihood then leads to a re-estimated value for α, and the process is repeated until convergence.

Let us consider the Laplace approximation for this model in more detail. For a ﬁxed value of α, the mode of the posterior distribution over w is obtained by maximizing

lnp(w|t,α) = ln{p(t|w)p(w|α)} − lnp(t|α)

�N

1 2

=

{tn lnyn + (1 − tn)ln(1 − yn)} −

wTAw + const (7.109)

n=1

where A = diag(αi). This can be done using iterative reweighted least squares (IRLS) as discussed in Section 4.3.3. For this, we need the gradient vector and

Exercise 7.18 Hessian matrix of the log posterior distribution, which from (7.109) are given by

∇lnp(w|t,α) = ΦT(t − y) − Aw (7.110) ∇∇lnp(w|t,α) = −�

�

ΦTBΦ + A

(7.111)

where B is an N × N diagonal matrix with elements bn = yn(1 − yn), the vector y = (y1,...,yN)T, and Φ is the design matrix with elements Φni = φi(xn). Here we have used the property (4.88) for the derivative of the logistic sigmoid function. At convergence of the IRLS algorithm, the negative Hessian represents the inverse covariance matrix for the Gaussian approximation to the posterior distribution.

The mode of the resulting approximation to the posterior distribution, corresponding to the mean of the Gaussian approximation, is obtained setting (7.110) to zero, giving the mean and covariance of the Laplace approximation in the form

w� = A−1ΦT(t − y) (7.112) Σ =

�

�−1

ΦTBΦ + A

. (7.113)

We can now use this Laplace approximation to evaluate the marginal likelihood. Using the general result (4.135) for an integral evaluated using the Laplace approxi-
