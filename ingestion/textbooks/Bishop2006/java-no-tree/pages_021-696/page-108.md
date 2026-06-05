[Page 108]

###### 2.3.2 Marginal Gaussian distributions

We have seen that if a joint distribution p(xa,xb) is Gaussian, then the conditional distribution p(xa|xb) will again be Gaussian. Now we turn to a discussion of the marginal distribution given by

###### p(xa) = p(xa,xb)dxb (2.83)

which, as we shall see, is also Gaussian. Once again, our strategy for evaluating this distribution efﬁciently will be to focus on the quadratic form in the exponent of the joint distribution and thereby to identify the mean and covariance of the marginal distribution p(xa).

The quadratic form for the joint distribution can be expressed, using the partitioned precision matrix, in the form (2.70). Because our goal is to integrate out xb, this is most easily achieved by ﬁrst considering the terms involving xb and then completing the square in order to facilitate integration. Picking out just those terms that involve xb, we have

- 1

- 2


1 2

- 1

- 2


(xb−Λ−1

bb m)TΛbb(xb−Λ−1

###### mTΛ−1

xTb Λbbxb+xTb m = −

bb m)+

bb m (2.84) where we have deﬁned

−

m = Λbbµb − Λba(xa − µa). (2.85)

We see that the dependence on xb has been cast into the standard quadratic form of a Gaussian distribution corresponding to the ﬁrst term on the right-hand side of (2.84),

plus a term that does not depend on xb (but that does depend on xa). Thus, when we take the exponential of this quadratic form, we see that the integration over xb required by (2.83) will take the form

1 2

exp −

(xb − Λ−1

bb m)TΛbb(xb − Λ−1

bb m) dxb. (2.86)

This integration is easily performed by noting that it is the integral over an unnormalized Gaussian, and so the result will be the reciprocal of the normalization coefﬁcient. We know from the form of the normalized Gaussian given by (2.43), that this coefﬁcient is independent of the mean and depends only on the determinant of the covariance matrix. Thus, by completing the square with respect to xb, we can integrate out xb and the only term remaining from the contributions on the left-hand side of (2.84) that depends on xa is the last term on the right-hand side of (2.84) in which m is given by (2.85). Combining this term with the remaining terms from
