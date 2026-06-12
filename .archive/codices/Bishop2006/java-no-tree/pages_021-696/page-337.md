[Page 337]

maximum. The posterior distribution is not Gaussian, however, because the Hessian is a function of aN.

Using the Newton-Raphson formula (4.92), the iterative update equation for aN

- Exercise 6.25 is given by

anewN = CN(I + WNCN)−1 {tN − σN + WNaN}. (6.83) These equations are iterated until they converge to the mode which we denote by a N. At the mode, the gradient ∇Ψ(aN) will vanish, and hence a N will satisfy

a N = CN(tN − σN). (6.84)

Once we have found the mode a N of the posterior, we can evaluate the Hessian matrix given by

H = −∇∇Ψ(aN) = WN + C−1

N (6.85)

where the elements of WN are evaluated using a N. This deﬁnes our Gaussian approximation to the posterior distribution p(aN|tN) given by

q(aN) = N(aN|a N,H−1). (6.86)

We can now combine this with (6.78) and hence evaluate the integral (6.77). Because this corresponds to a linear-Gaussian model, we can use the general result (2.115) to

- Exercise 6.26 give


E[aN+1|tN] = kT(tN − σN) (6.87) var[aN+1|tN] = c − kT(W−1

N + CN)−1k. (6.88)

Now that we have a Gaussian distribution for p(aN+1|tN), we can approximate the integral (6.76) using the result (4.153). As with the Bayesian logistic regression model of Section 4.5, if we are only interested in the decision boundary corresponding to p(tN+1|tN) = 0.5, then we need only consider the mean and we can ignore the effect of the variance.

We also need to determine the parameters θ of the covariance function. One approach is to maximize the likelihood function given by p(tN|θ) for which we need expressions for the log likelihood and its gradient. If desired, suitable regularization terms can also be added, leading to a penalized maximum likelihood solution. The likelihood function is deﬁned by

###### p(tN|θ) = p(tN|aN)p(aN|θ)daN. (6.89)

This integral is analytically intractable, so again we make use of the Laplace approximation. Using the result (4.135), we obtain the following approximation for the log of the likelihood function

lnp(tN|θ) = Ψ(a N) −

1 2

ln|WN + C−1

N | +

N 2

ln(2π) (6.90)
