[Page 152]

Mahalanobis distance ∆ is given by

VD|Σ|1/2∆D (2.286)

where VD is the volume of the unit sphere in D dimensions, and the Mahalanobis distance is deﬁned by (2.44).

2.24 (��) www Prove the identity (2.76) by multiplying both sides by the matrix

�

A B C D� (2.287)

and making use of the deﬁnition (2.77).

2.25 (��) In Sections 2.3.1 and 2.3.2, we considered the conditional and marginal distributions for a multivariate Gaussian. More generally, we can consider a partitioning of the components of x into three groups xa, xb, and xc, with a corresponding partitioning of the mean vector µ and of the covariance matrix Σ in the form

µ = �

�, Σ = �

�. (2.288)

Σaa Σab Σac Σba Σbb Σbc Σca Σcb Σcc

µa µb µc

By making use of the results of Section 2.3, ﬁnd an expression for the conditional distribution p(xa|xb) in which xc has been marginalized out.

2.26 (��) A very useful result from linear algebra is the Woodbury matrix inversion

formula given by

(A + BCD)−1 = A−1 − A−1B(C−1 + DA−1B)−1DA−1. (2.289) By multiplying both sides by (A + BCD) prove the correctness of this result.

2.27 (�) Let x and z be two independent random vectors, so that p(x,z) = p(x)p(z). Show that the mean of their sum y = x+z is given by the sum of the means of each of the variable separately. Similarly, show that the covariance matrix of y is given by the sum of the covariance matrices of x and z. Conﬁrm that this result agrees with that of Exercise 1.10.

2.28 (���) www Consider a joint distribution over the variable

z = �

x y� (2.290)

whose mean and covariance are given by (2.108) and (2.105) respectively. By making use of the results (2.92) and (2.93) show that the marginal distribution p(x) is given (2.99). Similarly, by making use of the results (2.81) and (2.82) show that the conditional distribution p(y|x) is given by (2.100).
