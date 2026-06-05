[Page 233]

Thus y and η must related, and we denote this relation through η = ψ(y).

Following Nelder and Wedderburn (1972), we deﬁne a generalized linear model to be one for which y is a nonlinear function of a linear combination of the input (or feature) variables so that

y = f(wTφ) (4.120)

where f(·) is known as the activation function in the machine learning literature, and f−1(·) is known as the link function in statistics.

Now consider the log likelihood function for this model, which, as a function of η, is given by

lnp(t|η,s) =

N

N

lnp(tn|η,s) =

n=1

n=1

ηntn s

lng(ηn) +

+ const (4.121)

where we are assuming that all observations share a common scale parameter (which corresponds to the noise variance for a Gaussian distribution for instance) and so s is independent of n. The derivative of the log likelihood with respect to the model parameters w is then given by

∇w lnp(t|η,s) =

=

N

d dηn

dηn dyn

dyn dan∇an

tn s

lng(ηn) +

n=1

N

1 s {tn − yn}ψ (yn)f (an)φn (4.122)

n=1

where an = wTφn, and we have used yn = f(an) together with the result (4.119) for E[t|η]. We now see that there is a considerable simpliﬁcation if we choose a particular form for the link function f−1(y) given by

###### f−1(y) = ψ(y) (4.123)

which gives f(ψ(y)) = y and hence f (ψ)ψ (y) = 1. Also, because a = f−1(y), we have a = ψ and hence f (a)ψ (y) = 1. In this case, the gradient of the error function reduces to

N

1 s

∇lnE(w) =

{yn − tn}φn. (4.124)

n=1

For the Gaussian s = β−1, whereas for the logistic model s = 1.

###### 4.4. The Laplace Approximation

In Section 4.5 we shall discuss the Bayesian treatment of logistic regression. As we shall see, this is more complex than the Bayesian treatment of linear regression models, discussed in Sections 3.3 and 3.5. In particular, we cannot integrate exactly
