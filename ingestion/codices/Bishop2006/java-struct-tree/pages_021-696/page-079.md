[Page 79]

1.6 (�) Show that if two variables x and y are independent, then their covariance is

zero.

1.7 (��) www In this exercise, we prove the normalization condition (1.48) for the

univariate Gaussian. To do this consider, the integral

exp�−

x2� dx (1.124)

I = � ∞ −∞

1 2σ2

which we can evaluate by ﬁrst writing its square in the form

exp�−

y2� dxdy. (1.125)

I2 = � ∞ −∞

� ∞

1 2σ2

1 2σ2

x2 −

−∞

Now make the transformation from Cartesian coordinates (x,y) to polar coordinates (r,θ) and then substitute u = r2. Show that, by performing the integrals over θ and u, and then taking the square root of both sides, we obtain

�

�1/2

2πσ2

I =

. (1.126)

Finally, use this result to show that the Gaussian distribution N(x|µ,σ2) is normalized.

1.8 (��) www By using a change of variables, verify that the univariate Gaussian distribution given by (1.46) satisﬁes (1.49). Next, by differentiating both sides of the normalization condition

� ∞

N �

�

dx = 1 (1.127)

x|µ,σ2

−∞

with respect to σ2, verify that the Gaussian satisﬁes (1.50). Finally, show that (1.51) holds.

1.9 (�) www Show that the mode (i.e. the maximum) of the Gaussian distribution (1.46) is given by µ. Similarly, show that the mode of the multivariate Gaussian (1.52) is given by µ.

1.10 (�) www Suppose that the two variables x and z are statistically independent.

Show that the mean and variance of their sum satisﬁes

E[x + z] = E[x] + E[z] (1.128) var[x + z] = var[x] + var[z]. (1.129)

1.11 (�) By setting the derivatives of the log likelihood function (1.54) with respect to µ

and σ2 equal to zero, verify the results (1.55) and (1.56).
