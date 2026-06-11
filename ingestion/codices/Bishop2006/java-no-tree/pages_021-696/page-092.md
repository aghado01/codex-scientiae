[Page 92]

- 0
- 1
- 2
- 3


- 0
- 1
- 2
- 3


|a = 1<br>b = 1<br><br><br>|
|---|


|a = 0.1<br>b = 0.1<br><br><br>|
|---|


0 0.5 µ 1

0 0.5 1

µ

- 0
- 1
- 2
- 3


- 0
- 1
- 2
- 3


|a = 2<br>b = 3<br><br><br>|
|---|


|a = 8<br>b = 4<br><br><br>|
|---|


0 0.5 1

0 0.5 1

µ

µ

- Figure 2.2 Plots of the beta distribution Beta(µ|a, b) given by (2.13) as a function of µ for various values of the hyperparameters a and b.


where l = N − m, and therefore corresponds to the number of ‘tails’ in the coin example. We see that (2.17) has the same functional dependence on µ as the prior distribution, reﬂecting the conjugacy properties of the prior with respect to the likelihood function. Indeed, it is simply another beta distribution, and its normalization coefﬁcient can therefore be obtained by comparison with (2.13) to give

Γ(m + a + l + b) Γ(m + a)Γ(l + b)

µm+a−1(1 − µ)l+b−1. (2.18)

p(µ|m,l,a,b) =

We see that the effect of observing a data set of m observations of x = 1 and l observations of x = 0 has been to increase the value of a by m, and the value of b by l, in going from the prior distribution to the posterior distribution. This allows us to provide a simple interpretation of the hyperparameters a and b in the prior as an effective number of observations of x = 1 and x = 0, respectively. Note that a and b need not be integers. Furthermore, the posterior distribution can act as the prior if we subsequently observe additional data. To see this, we can imagine taking observations one at a time and after each observation updating the current posterior
