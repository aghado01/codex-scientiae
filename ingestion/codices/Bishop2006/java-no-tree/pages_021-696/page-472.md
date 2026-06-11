[Page 472]

- Figure 9.12 Illustration of the E step of the EM algorithm. The q distribution is set equal to the posterior distribution for the current parameter values θold, causing the lower bound to move up to the same value as the log likelihood function, with the KL divergence vanishing. L(q,θold) lnp(X|θold)

KL(q||p) = 0

shown in Figure 9.13. If we substitute q(Z) = p(Z|X,θold) into (9.71), we see that, after the E step, the lower bound takes the form

L(q,θ) =

Z

p(Z|X,θold)lnp(X,Z|θ) −

Z

p(Z|X,θold)lnp(Z|X,θold)

= Q(θ,θold) + const (9.74)

where the constant is simply the negative entropy of the q distribution and is therefore independent of θ. Thus in the M step, the quantity that is being maximized is the expectation of the complete-data log likelihood, as we saw earlier in the case of mixtures of Gaussians. Note that the variable θ over which we are optimizing appears only inside the logarithm. If the joint distribution p(Z,X|θ) comprises a member of the exponential family, or a product of such members, then we see that the logarithm will cancel the exponential and lead to an M step that will be typically much simpler than the maximization of the corresponding incomplete-data log likelihood function p(X|θ).

The operation of the EM algorithm can also be viewed in the space of parameters, as illustrated schematically in Figure 9.14. Here the red curve depicts the (in-

- Figure 9.13 Illustration of the M step of the EM algorithm. The distribution q(Z) is held ﬁxed and the lower bound L(q, θ) is maximized with respect to the parameter vector θ to give a revised value θnew. Because the KL divergence is nonnegative, this causes the log likelihood ln p(X|θ) to increase by at least as much as the lower bound does.


KL(q||p)

L(q,θnew) lnp(X|θnew)
