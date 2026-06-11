[Page 155]

variable drawn from the distribution (2.293). Show that the log likelihood function over w and σ2, for an observed data set of input vectors X = {x1,...,xN} and corresponding target variables t = (t1,...,tN)T, is given by

- 1

- 2σ2


lnp(t|X,w,σ2) = −

N

N q

|y(xn,w) − tn|q −

n=1

ln(2σ2) + const (2.295)

where ‘const’ denotes terms independent of both w and σ2. Note that, as a function of w, this is the Lq error function considered in Section 1.5.5.

- 2.44 ( ) Consider a univariate Gaussian distribution N(x|µ,τ−1) having conjugate

Gaussian-gamma prior given by (2.154), and a data set x = {x1,...,xN} of i.i.d. observations. Show that the posterior distribution is also a Gaussian-gamma distribution of the same functional form as the prior, and write down expressions for the parameters of this posterior distribution.

- 2.45 ( ) Verify that the Wishart distribution deﬁned by (2.155) is indeed a conjugate prior for the precision matrix of a multivariate Gaussian.
- 2.46 ( ) www Verify that evaluating the integral in (2.158) leads to the result (2.159).

- 2.47 ( ) www Show that in the limit ν → ∞, the t-distribution (2.159) becomes a Gaussian. Hint: ignore the normalization coefﬁcient, and simply look at the dependence on x.

- 2.48 ( ) By following analogous steps to those used to derive the univariate Student’s t-distribution (2.159), verify the result (2.162) for the multivariate form of the Student’s t-distribution, by marginalizing over the variable η in (2.161). Using the deﬁnition (2.161), show by exchanging integration variables that the multivariate t-distribution is correctly normalized.
- 2.49 ( ) By using the deﬁnition (2.161) of the multivariate Student’s t-distribution as a convolution of a Gaussian with a gamma distribution, verify the properties (2.164), (2.165), and (2.166) for the multivariate t-distribution deﬁned by (2.162).
- 2.50 ( ) Show that in the limit ν → ∞, the multivariate Student’s t-distribution (2.162) reduces to a Gaussian with mean µ and precision Λ.
- 2.51 ( ) www The various trigonometric identities used in the discussion of periodic variables in this chapter can be proven easily from the relation


exp(iA) = cosA + isinA (2.296) in which i is the square root of minus one. By considering the identity

exp(iA)exp(−iA) = 1 (2.297) prove the result (2.177). Similarly, using the identity

###### cos(A − B) = exp{i(A − B)} (2.298)
