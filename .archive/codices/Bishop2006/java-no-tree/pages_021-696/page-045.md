[Page 45]

Figure 1.13 Plot of the univariate Gaussian showing the mean µ and the standard deviation σ. N(x|µ,σ2)

2σ

x

µ

∞

N x|µ,σ2 dx = 1. (1.48)

−∞

Thus (1.46) satisﬁes the two requirements for a valid probability density. We can readily ﬁnd expectations of functions of x under the Gaussian distribu-

- Exercise 1.8 tion. In particular, the average value of x is given by

E[x] =

∞

−∞

N x|µ,σ2 xdx = µ. (1.49)

Because the parameter µ represents the average value of x under the distribution, it is referred to as the mean. Similarly, for the second order moment

E[x2] =

∞

−∞

N x|µ,σ2 x2 dx = µ2 + σ2. (1.50)

From (1.49) and (1.50), it follows that the variance of x is given by

var[x] = E[x2] − E[x]2 = σ2 (1.51) and hence σ2 is referred to as the variance parameter. The maximum of a distribution

- Exercise 1.9 is known as its mode. For a Gaussian, the mode coincides with the mean. We are also interested in the Gaussian distribution deﬁned over a D-dimensional


vector x of continuous variables, which is given by

1 |Σ|1/2

- 1

- 2


1 (2π)D/2

(x − µ)TΣ−1(x − µ) (1.52)

exp −

N(x|µ,Σ) =

where the D-dimensional vector µ is called the mean, the D × D matrix Σ is called the covariance, and |Σ| denotes the determinant of Σ. We shall make use of the multivariate Gaussian distribution brieﬂy in this chapter, although its properties will be studied in detail in Section 2.3.
