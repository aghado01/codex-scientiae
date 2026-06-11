[Page 688]

Figure 14.7 Probabilistic directed graph representing a mixture of

linear regression models, deﬁned by (14.35).

###### zn

φn

###### π

β

tn

W N

The EM algorithm begins by ﬁrst choosing an initial value θold for the model parameters. In the E step, these parameter values are then used to evaluate the posterior probabilities, or responsibilities, of each component k for every data point n given by

πkN(tn|wkTφn,β−1) j πjN(tn|wjTφn,β−1)

γnk = E[znk] = p(k|φn,θold) =

. (14.37)

The responsibilities are then used to determine the expectation, with respect to the posterior distribution p(Z|t,θold), of the complete-data log likelihood, which takes the form

N

Q(θ,θold) = EZ [lnp(t,Z|θ)] =

n=1

###### K

γnk lnπk + lnN(tn|wkTφn,β−1) .

k=1

In the M step, we maximize the function Q(θ,θold) with respect to θ, keeping the γnk ﬁxed. For the optimization with respect to the mixing coefﬁcients πk we need to take account of the constraint k πk = 1, which can be done with the aid of a

- Exercise 14.14 Lagrange multiplier, leading to an M-step re-estimation equation for πk in the form


1 N

πk =

N

γnk. (14.38)

n=1

Note that this has exactly the same form as the corresponding result for a simple mixture of unconditional Gaussians given by (9.22).

Next consider the maximization with respect to the parameter vector wk of the kth linear regression model. Substituting for the Gaussian distribution, we see that the function Q(θ,θold), as a function of the parameter vector wk, takes the form

N

β 2

Q(θ,θold) =

γnk −

n=1

tn − wkTφn 2 + const (14.39)

where the constant term includes the contributions from other weight vectors wj for

- j = k. Note that the quantity we are maximizing is similar to the (negative of the) standard sum-of-squares error (3.12) for a single linear regression model, but with the inclusion of the responsibilities γnk. This represents a weighted least squares
