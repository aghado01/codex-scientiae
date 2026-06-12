[Page 473]

Figure 9.14 The EM algorithm involves alternately computing a lower bound on the log likelihood for the current parameter values and then maximizing this bound to obtain the new parameter values. See the text for a full discussion.

lnp(X|θ)

θold θnew

L (q,θ)

complete data) log likelihood function whose value we wish to maximize. We start with some initial parameter value θold, and in the ﬁrst E step we evaluate the posterior distribution over latent variables, which gives rise to a lower bound L(θ,θ(old)) whose value equals the log likelihood at θ(old), as shown by the blue curve. Note that the bound makes a tangential contact with the log likelihood at θ(old), so that both

Exercise 9.25 curves have the same gradient. This bound is a convex function having a unique maximum (for mixture components from the exponential family). In the M step, the bound is maximized giving the value θ(new), which gives a larger value of log likelihood than θ(old). The subsequent E step then constructs a bound that is tangential at θ(new) as shown by the green curve.

For the particular case of an independent, identically distributed data set, X will comprise N data points {xn} while Z will comprise N corresponding latent variables {zn}, where n = 1,...,N. From the independence assumption, we have p(X,Z) =

� � n p(xn,zn) and, by marginalizing over the {zn} we have p(X) =

n p(xn). Using the sum and product rules, we see that the posterior probability that is evaluated in the E step takes the form

�N

p(xn,zn|θ)

�N

p(X,Z|θ)

n=1

p(Z|X,θ) =

=

p(zn|xn,θ) (9.75)

=

�

�N

�

p(X,Z|θ)

n=1

p(xn,zn|θ)

Z

n=1

Z

and so the posterior distribution also factorizes with respect to n. In the case of the Gaussian mixture model this simply says that the responsibility that each of the mixture components takes for a particular data point xn depends only on the value of xn and on the parameters θ of the mixture components, not on the values of the other data points.

We have seen that both the E and the M steps of the EM algorithm are increasing the value of a well-deﬁned bound on the log likelihood function and that the
