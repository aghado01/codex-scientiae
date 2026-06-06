[Page 154]

distribution, by starting with the maximum likelihood expression

1 N

σML2 =

N

(xn − µ)2. (2.292)

n=1

Verify that substituting the expression for a Gaussian distribution into the RobbinsMonro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients aN.

- 2.37 ( ) Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the covariance of a multivariate Gaussian distribution, by starting with the maximum likelihood expression (2.122). Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients aN.
- 2.38 ( ) Use the technique of completing the square for the quadratic form in the exponent to derive the results (2.141) and (2.142).
- 2.39 ( ) Starting from the results (2.141) and (2.142) for the posterior distribution of the mean of a Gaussian random variable, dissect out the contributions from the ﬁrst N − 1 data points and hence obtain expressions for the sequential update of

µN and σN2 . Now derive the same results starting from the posterior distribution p(µ|x1,...,xN−1) = N(µ|µN−1,σN2 −1) and multiplying by the likelihood function p(xN|µ) = N(xN|µ,σ2) and then completing the square and normalizing to obtain the posterior distribution after N observations.

- 2.40 ( ) www Consider a D-dimensional Gaussian random variable x with distribution N(x|µ,Σ) in which the covariance Σ is known and for which we wish to infer the mean µ from a set of observations X = {x1,...,xN}. Given a prior distribution p(µ) = N(µ|µ0,Σ0), ﬁnd the corresponding posterior distribution p(µ|X).

- 2.41 ( ) Use the deﬁnition of the gamma function (1.141) to show that the gamma distribution (2.146) is normalized.
- 2.42 ( ) Evaluate the mean, variance, and mode of the gamma distribution (2.146).
- 2.43 ( ) The following distribution


|x|q 2σ2

q 2(2σ2)1/qΓ(1/q)

exp −

p(x|σ2,q) =

(2.293)

is a generalization of the univariate Gaussian distribution. Show that this distribution is normalized so that ∞

p(x|σ2,q)dx = 1 (2.294)

−∞

and that it reduces to the Gaussian when q = 2. Consider a regression model in which the target variable is given by t = y(x,w) + and is a random noise
