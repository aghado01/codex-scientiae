[Page 107]

Now consider all of the terms in (2.70) that are linear in xa

xTa {Λaaµa − Λab(xb − µb)} (2.74)

where we have used ΛTba = Λab. From our discussion of the general form (2.71), the coefﬁcient of xa in this expression must equal Σ−1

a|bµa|b and hence µa|b = Σa|b {Λaaµa − Λab(xb − µb)}

= µa − Λ−1

aa Λab(xb − µb) (2.75) where we have made use of (2.73).

The results (2.73) and (2.75) are expressed in terms of the partitioned precision

matrix of the original joint distribution p(xa,xb). We can also express these results in terms of the corresponding partitioned covariance matrix. To do this, we make use

Exercise 2.24 of the following identity for the inverse of a partitioned matrix

−1

A B C D

M −MBD−1

=

(2.76)

−D−1CM D−1 + D−1CMBD−1

where we have deﬁned

###### M = (A − BD−1C)−1. (2.77)

The quantity M−1 is known as the Schur complement of the matrix on the left-hand side of (2.76) with respect to the submatrix D. Using the deﬁnition

Σaa Σab Σba Σbb

−1

=

Λaa Λab Λba Λbb

(2.78)

and making use of (2.76), we have

Λaa = (Σaa − ΣabΣ−1

bb Σba)−1 (2.79) Λab = −(Σaa − ΣabΣ−1

bb Σba)−1ΣabΣ−1

bb . (2.80)

From these we obtain the following expressions for the mean and covariance of the conditional distribution p(xa|xb)

µa|b = µa + ΣabΣ−1

bb (xb − µb) (2.81) Σa|b = Σaa − ΣabΣ−1

bb Σba. (2.82)

Comparing (2.73) and (2.82), we see that the conditional distribution p(xa|xb) takes a simpler form when expressed in terms of the partitioned precision matrix than when it is expressed in terms of the partitioned covariance matrix. Note that the mean of the conditional distribution p(xa|xb), given by (2.81), is a linear function of xb and that the covariance, given by (2.82), is independent of xa. This represents an

Section 8.1.4 example of a linear-Gaussian model.
