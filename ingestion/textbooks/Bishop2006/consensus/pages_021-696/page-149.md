[Page 149]

- 2.7 ( ) Consider a binomial random variable x given by (2.9), with prior distribution for µ given by the beta distribution (2.13), and suppose we have observed m occurrences of x = 1 and l occurrences of x = 0. Show that the posterior mean value of x lies between the prior mean and the maximum likelihood estimate for µ. To do this, show that the posterior mean can be written as λ times the prior mean plus (1 − λ) times the maximum likelihood estimate, where 0 λ 1. This illustrates the concept of the posterior distribution being a compromise between the prior distribution and the maximum likelihood solution.
- 2.8 ( ) Consider two variables x and y with joint distribution p(x,y). Prove the following two results

E[x] = Ey [Ex[x|y]] (2.270) var[x] = Ey [varx[x|y]] + vary [Ex[x|y]]. (2.271)

Here Ex[x|y] denotes the expectation of x under the conditional distribution p(x|y), with a similar notation for the conditional variance.

- 2.9 ( ) www . In this exercise, we prove the normalization of the Dirichlet distribution (2.38) using induction. We have already shown in Exercise 2.5 that the beta distribution, which is a special case of the Dirichlet for M = 2, is normalized. We now assume that the Dirichlet distribution is normalized for M − 1 variables and prove that it is normalized for M variables. To do this, consider the Dirichlet

distribution over M variables, and take account of the constraint Mk=1 µk = 1 by eliminating µM, so that the Dirichlet is written

pM(µ1,...,µM−1) = CM

M−1

k=1

µα

k−1

k 1 −

M−1

j=1

µj

αM−1

(2.272)

and our goal is to ﬁnd an expression for CM. To do this, integrate over µM−1, taking care over the limits of integration, and then make a change of variable so that this

integral has limits 0 and 1. By assuming the correct result for CM−1 and making use of (2.265), derive the expression for CM.

- 2.10 ( ) Using the property Γ(x + 1) = xΓ(x) of the gamma function, derive the following results for the mean, variance, and covariance of the Dirichlet distribution given by (2.38)


αj α0

E[µj] =

(2.273)

αj(α0 − αj) α02(α0 + 1)

var[µj] =

(2.274)

αjαl α02(α0 + 1)

, j = l (2.275)

cov[µjµl] = −

where α0 is deﬁned by (2.39).
