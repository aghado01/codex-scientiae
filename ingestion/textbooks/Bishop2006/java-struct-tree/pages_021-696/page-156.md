[Page 156]

where � denotes the real part, prove (2.178). Finally, by using sin(A − B) = �exp{i(A − B)}, where � denotes the imaginary part, prove the result (2.183).

2.52 (��) For large m, the von Mises distribution (2.179) becomes sharply peaked

around the mode θ0. By deﬁning ξ = m1/2(θ − θ0) and making the Taylor expansion of the cosine function given by

α2 2

+ O(α4) (2.299) show that as m → ∞, the von Mises distribution tends to a Gaussian.

cosα = 1 −

2.53 (�) Using the trigonometric identity (2.183), show that solution of (2.182) for θ0 is

given by (2.184).

2.54 (�) By computing ﬁrst and second derivatives of the von Mises distribution (2.179), and using I0(m) > 0 for m > 0, show that the maximum of the distribution occurs when θ = θ0 and that the minimum occurs when θ = θ0 + π (mod2π).

2.55 (�) By making use of the result (2.168), together with (2.184) and the trigonometric identity (2.178), show that the maximum likelihood solution mML for the concentration of the von Mises distribution satisﬁes A(mML) = r where r is the radius of the mean of the observations viewed as unit vectors in the two-dimensional Euclidean plane, as illustrated in Figure 2.17.

2.56 (��) www Express the beta distribution (2.13), the gamma distribution (2.146), and the von Mises distribution (2.179) as members of the exponential family (2.194) and thereby identify their natural parameters.

2.57 (�) Verify that the multivariate Gaussian distribution can be cast in exponential family form (2.194) and derive expressions for η, u(x), h(x) and g(η) analogous to (2.220)–(2.223).

2.58 (�) The result (2.226) showed that the negative gradient of lng(η) for the exponential family is given by the expectation of u(x). By taking the second derivatives of (2.195), show that

−∇∇lng(η) = E[u(x)u(x)T] − E[u(x)]E[u(x)T] = cov[u(x)]. (2.300) 2.59 (�) By changing variables using y = x/σ, show that the density (2.236) will be

correctly normalized, provided f(x) is correctly normalized.

2.60 (��) www Consider a histogram-like density model in which the space x is divided into ﬁxed regions for which the density p(x) takes the constant value hi over the ith region, and that the volume of region i is denoted ∆i. Suppose we have a set of N observations of x such that ni of these observations fall in region i. Using a Lagrange multiplier to enforce the normalization constraint on the density, derive an expression for the maximum likelihood estimator for the {hi}.

2.61 (�) Show that the K-nearest-neighbour density model deﬁnes an improper distribu-

tion whose integral over all space is divergent.
