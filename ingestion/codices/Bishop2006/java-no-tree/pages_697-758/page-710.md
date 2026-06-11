[Page 710]

and the marginal distribution p(xa) is given by

p(xa) = N(xa|µa,Σaa). (B.51)

###### Gaussian-Gamma

| |
|---|


This is the conjugate prior distribution for a univariate Gaussian N(x|µ,λ−1) in which the mean µ and the precision λ are both unknown and is also called the normal-gamma distribution. It comprises the product of a Gaussian distribution for µ, whose precision is proportional to λ, and a gamma distribution over λ.

p(µ,λ|µ0,β,a,b) = N µ|µo,(βλ)−1 Gam(λ|a,b). (B.52)

###### Gaussian-Wishart

This is the conjugate prior distribution for a multivariate Gaussian N(x|µ,Λ) in which both the mean µ and the precision Λ are unknown, and is also called the normal-Wishart distribution. It comprises the product of a Gaussian distribution for µ, whose precision is proportional to Λ, and a Wishart distribution over Λ.

p(µ,Λ|µ0,β,W,ν) = N µ|µ0,(βΛ)−1 W(Λ|W,ν). (B.53)

For the particular case of a scalar x, this is equivalent to the Gaussian-gamma distribution.

###### Multinomial

If we generalize the Bernoulli distribution to an K-dimensional binary variable x with components xk ∈ {0,1} such that k xk = 1, then we obtain the following discrete distribution

K

µx

p(x) =

k (B.54) E[xk] = µk (B.55)

k

k=1

var[xk] = µk(1 − µk) (B.56) cov[xjxk] = Ijkµk (B.57)

M

H[x] = −

µk lnµk (B.58)

k=1
