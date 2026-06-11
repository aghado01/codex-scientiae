[Page 122]

Figure 2.14 Contour plot of the normal-gamma distribution (2.154) for parameter values µ0 = 0, β = 2, a = 5 and b = 6.

λ

- 0
- 1
- 2


| |
|---|


−2 0 2

µ

In the case of the multivariate Gaussian distribution N x|µ,Λ−1 for a Ddimensional variable x, the conjugate prior distribution for the mean µ, assuming the precision is known, is again a Gaussian. For known mean and unknown precision

- Exercise 2.45 matrix Λ, the conjugate prior is the Wishart distribution given by

W(Λ|W,ν) = B|Λ|(ν−D−1)/2 exp −

- 1

- 2


Tr(W−1Λ) (2.155)

where ν is called the number of degrees of freedom of the distribution, W is a D×D scale matrix, and Tr(·) denotes the trace. The normalization constant B is given by

B(W,ν) = |W|−ν/2 2νD/2 πD(D−1)/4

D

i=1

Γ

ν + 1 − i 2

−1

. (2.156)

Again, it is also possible to deﬁne a conjugate prior over the covariance matrix itself, rather than over the precision matrix, which leads to the inverse Wishart distribution, although we shall not discuss this further. If both the mean and the precision are unknown, then, following a similar line of reasoning to the univariate case, the conjugate prior is given by

p(µ,Λ|µ0,β,W,ν) = N(µ|µ0,(βΛ)−1)W(Λ|W,ν) (2.157) which is known as the normal-Wishart or Gaussian-Wishart distribution.

2.3.7 Student’s t-distribution

We have seen that the conjugate prior for the precision of a Gaussian is given Section 2.3.6 by a gamma distribution. If we have a univariate Gaussian N(x|µ,τ−1) together

with a Gamma prior Gam(τ|a,b) and we integrate out the precision, we obtain the

- Exercise 2.46 marginal distribution of x in the form
