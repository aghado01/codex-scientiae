[Page 531]

Figure 10.15 Illustration of the clutter problem for a data space dimensionality of D = 1. Training data points, denoted by the crosses, are drawn from a mixture of two Gaussians with components shown in red and green. The goal is to infer the mean of the green Gaussian from the observed data.

−5 0 θ 5 x 10

10.7.1 Example: The clutter problem

Following Minka (2001b), we illustrate the EP algorithm using a simple example in which the goal is to infer the mean θ of a multivariate Gaussian distribution over a variable x given a set of observations drawn from that distribution. To make the problem more interesting, the observations are embedded in background clutter, which itself is also Gaussian distributed, as illustrated in Figure 10.15. The distribution of observed values x is therefore a mixture of Gaussians, which we take to be of the form

p(x|θ) = (1 − w)N(x|θ,I) + wN(x|0,aI) (10.209)

where w is the proportion of background clutter and is assumed to be known. The prior over θ is taken to be Gaussian

p(θ) = N(θ|0,bI) (10.210)

and Minka (2001a) chooses the parameter values a = 10, b = 100 and w = 0.5. The joint distribution of N observations D = {x1,...,xN} and θ is given by

�N

p(xn|θ) (10.211)

p(D,θ) = p(θ)

n=1

and so the posterior distribution comprises a mixture of 2N Gaussians. Thus the computational cost of solving this problem exactly would grow exponentially with the size of the data set, and so an exact solution is intractable for moderately large N.

To apply EP to the clutter problem, we ﬁrst identify the factors f0(θ) = p(θ) and fn(θ) = p(xn|θ). Next we select an approximating distribution from the exponential family, and for this example it is convenient to choose a spherical Gaussian

q(θ) = N(θ|m,vI). (10.212)
