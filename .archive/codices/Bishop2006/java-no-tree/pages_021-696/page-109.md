[Page 109]

- (2.70) that depend on xa, we obtain

- 1

- 2


[Λbbµb − Λba(xa − µa)]T Λ−1

bb [Λbbµb − Λba(xa − µa)] −

- 1

- 2


xTaΛaaxa + xTa(Λaaµa + Λabµb) + const

= −

- 1

- 2


xTa(Λaa − ΛabΛ−1

bb Λba)xa

+xTa(Λaa − ΛabΛ−1

bb Λba)−1µa + const (2.87) where ‘const’ denotes quantities independent of xa. Again, by comparison with

- (2.71), we see that the covariance of the marginal distribution of p(xa) is given by


Σa = (Λaa − ΛabΛ−1

bb Λba)−1. (2.88) Similarly, the mean is given by

Σa(Λaa − ΛabΛ−1

bb Λba)µa = µa (2.89)

where we have used (2.88). The covariance in (2.88) is expressed in terms of the partitioned precision matrix given by (2.69). We can rewrite this in terms of the corresponding partitioning of the covariance matrix given by (2.67), as we did for the conditional distribution. These partitioned matrices are related by

Λaa Λab Λba Λbb

−1

=

Σaa Σab Σba Σbb

(2.90)

Making use of (2.76), we then have

bb Λba −1 = Σaa. (2.91)

Λaa − ΛabΛ−1

Thus we obtain the intuitively satisfying result that the marginal distribution p(xa) has mean and covariance given by

E[xa] = µa (2.92) cov[xa] = Σaa. (2.93)

We see that for a marginal distribution, the mean and covariance are most simply expressed in terms of the partitioned covariance matrix, in contrast to the conditional distribution for which the partitioned precision matrix gives rise to simpler expressions.

Our results for the marginal and conditional distributions of a partitioned Gaus-

sian are summarized below. Partitioned Gaussians Given a joint Gaussian distribution N(x|µ,Σ) with Λ ≡ Σ−1 and

xa xb , µ = µa

x =

(2.94)

µb
