[Page 105]

such complex distributions is that of probabilistic graphical models, which will form the subject of Chapter 8.

2.3.1 Conditional Gaussian distributions

An important property of the multivariate Gaussian distribution is that if two sets of variables are jointly Gaussian, then the conditional distribution of one set conditioned on the other is again Gaussian. Similarly, the marginal distribution of either set is also Gaussian.

Consider ﬁrst the case of conditional distributions. Suppose x is a D-dimensional

vector with Gaussian distribution N(x|µ,Σ) and that we partition x into two disjoint subsets xa and xb. Without loss of generality, we can take xa to form the ﬁrst M components of x, with xb comprising the remaining D − M components, so that

x = �

xa xb�. (2.65)

We also deﬁne corresponding partitions of the mean vector µ given by

µ = �

� (2.66)

µa µb

and of the covariance matrix Σ given by

Σ = �

Σaa Σab Σba Σbb�. (2.67)

Note that the symmetry ΣT = Σ of the covariance matrix implies that Σaa and Σbb are symmetric, while Σba = ΣTab.

In many situations, it will be convenient to work with the inverse of the covariance matrix

Λ ≡ Σ−1 (2.68)

which is known as the precision matrix. In fact, we shall see that some properties of Gaussian distributions are most naturally expressed in terms of the covariance, whereas others take a simpler form when viewed in terms of the precision. We therefore also introduce the partitioned form of the precision matrix

Λ = �

Λaa Λab Λba Λbb� (2.69)

corresponding to the partitioning (2.65) of the vector x. Because the inverse of a

Exercise 2.22 symmetric matrix is also symmetric, we see that Λaa and Λbb are symmetric, while ΛTab = Λba. It should be stressed at this point that, for instance, Λaa is not simply given by the inverse of Σaa. In fact, we shall shortly examine the relation between the inverse of a partitioned matrix and the inverses of its partitions.

Let us begin by ﬁnding an expression for the conditional distribution p(xa|xb). From the product rule of probability, we see that this conditional distribution can be
