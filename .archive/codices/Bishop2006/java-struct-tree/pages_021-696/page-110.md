[Page 110]

1

xb

xb = 0.7

10

p(xa|xb = 0.7)

0.5

p(xa,xb)

5

p(xa)

0

0 0.5 1

xa

0

0 0.5 1

xa

Figure 2.9 The plot on the left shows the contours of a Gaussian distribution p(xa, xb) over two variables, and the plot on the right shows the marginal distribution p(xa) (blue curve) and the conditional distribution p(xa|xb) for xb = 0.7 (red curve).

Σ = �

Σaa Σab Σba Σbb�, Λ = �

Λaa Λab Λba Λbb�. (2.95)

Conditional distribution:

p(xa|xb) = N(x|µa|b,Λ−1

aa ) (2.96) µa|b = µa − Λ−1

aa Λab(xb − µb). (2.97) Marginal distribution:

p(xa) = N(xa|µa,Σaa). (2.98)

We illustrate the idea of conditional and marginal distributions associated with a multivariate Gaussian using an example involving two variables in Figure 2.9.

2.3.3 Bayes’ theorem for Gaussian variables

In Sections 2.3.1 and 2.3.2, we considered a Gaussian p(x) in which we partitioned the vector x into two subvectors x = (xa,xb) and then found expressions for the conditional distribution p(xa|xb) and the marginal distribution p(xa). We noted that the mean of the conditional distribution p(xa|xb) was a linear function of xb. Here we shall suppose that we are given a Gaussian marginal distribution p(x) and a Gaussian conditional distribution p(y|x) in which p(y|x) has a mean that is a linear function of x, and a covariance which is independent of x. This is an example of
