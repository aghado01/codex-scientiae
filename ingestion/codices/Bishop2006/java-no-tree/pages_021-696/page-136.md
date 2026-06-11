[Page 136]

which, after some simple rearrangement, can be cast in the standard exponential

- Exercise 2.57 family form (2.194) with

η = µ/σ2

−1/2σ2

(2.220)

u(x) = x x2

(2.221) h(x) = (2π)−1/2 (2.222) g(η) = (−2η2)1/2 exp

η12 4η2

. (2.223)

2.4.1 Maximum likelihood and sufﬁcient statistics

Let us now consider the problem of estimating the parameter vector η in the general exponential family distribution (2.194) using the technique of maximum likelihood. Taking the gradient of both sides of (2.195) with respect to η, we have

∇g(η) h(x)exp ηTu(x) dx

+ g(η) h(x)exp ηTu(x) u(x)dx = 0. (2.224)

Rearranging, and making use again of (2.195) then gives

−

1

g(η)∇g(η) = g(η) h(x)exp ηTu(x) u(x)dx = E[u(x)] (2.225) where we have used (2.194). We therefore obtain the result

−∇lng(η) = E[u(x)]. (2.226) Note that the covariance of u(x) can be expressed in terms of the second derivatives

- Exercise 2.58 of g(η), and similarly for higher order moments. Thus, provided we can normalize a distribution from the exponential family, we can always ﬁnd its moments by simple differentiation.


Now consider a set of independent identically distributed data denoted by X = {x1,...,xn}, for which the likelihood function is given by

N

N

h(xn) g(η)N exp ηT

u(xn) . (2.227)

p(X|η) =

n=1

n=1

Setting the gradient of lnp(X|η) with respect to η to zero, we get the following condition to be satisﬁed by the maximum likelihood estimator ηML

1 N

−∇lng(ηML) =

N

u(xn) (2.228)

n=1
