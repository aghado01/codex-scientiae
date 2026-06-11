[Page 150]

2.11 (�) www By expressing the expectation of lnµj under the Dirichlet distribution

(2.38) as a derivative with respect to αj, show that

E[lnµj] = ψ(αj) − ψ(α0) (2.276) where α0 is given by (2.39) and

d da

lnΓ(a) (2.277) is the digamma function.

ψ(a) ≡

2.12 (�) The uniform distribution for a continuous variable x is deﬁned by

1 b − a

, a � x � b. (2.278)

U(x|a,b) =

Verify that this distribution is normalized, and ﬁnd expressions for its mean and variance.

2.13 (��) Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians

p(x) = N(x|µ,Σ) and q(x) = N(x|m,L).

2.14 (��) www This exercise demonstrates that the multivariate distribution with maximum entropy, for a given covariance, is a Gaussian. The entropy of a distribution p(x) is given by

H[x] = −� p(x)lnp(x)dx. (2.279)

We wish to maximize H[x] over all distributions p(x) subject to the constraints that p(x) be normalized and that it have a speciﬁc mean and covariance, so that

� p(x)dx = 1 (2.280)

� p(x)xdx = µ (2.281)

� p(x)(x − µ)(x − µ)T dx = Σ. (2.282)

By performing a variational maximization of (2.279) and using Lagrange multipliers to enforce the constraints (2.280), (2.281), and (2.282), show that the maximum likelihood distribution is given by the Gaussian (2.43).

2.15 (��) Show that the entropy of the multivariate Gaussian N(x|µ,Σ) is given by

1 2

D 2

(1 + ln(2π)) (2.283) where D is the dimensionality of x.

ln|Σ| +

H[x] =
