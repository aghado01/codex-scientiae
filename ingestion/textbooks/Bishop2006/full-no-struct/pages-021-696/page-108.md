[Page 108]

# 2.3.2 Marginal Gaussian distributions

We have seen that if a joint distribution p ( x a , x b ) is Gaussian, then the conditional distribution p ( x a | x b ) will again be Gaussian. Now we turn to a discussion of the marginal distribution given by

$$
p ( x _ { a } ) = \int p ( x _ { a } , x _ { b } ) \, d x _ { b } \\ \intertext { s e e } \text { is also Gaussian} \text { once again } \text { our strategy for evaluating this }
$$

which, as we shall see, is also Gaussian. Once again, our strategy for evaluating this distribution efﬁciently will be to focus on the quadratic form in the exponent of the joint distribution and thereby to identify the mean and covariance of the marginal distribution p ( x a ) . The quadratic form for the joint distribution can be expressed, using the par-

titioned precision matrix, in the form (2.70). Because our goal is to integrate out x b , this is most easily achieved by ﬁrst considering the terms involving x b and then completing the square in order to facilitate integration. Picking out just those terms that involve x b , we have

$$
- \frac { 1 } { 2 } x _ { b } ^ { T } \Lambda _ { b b } x _ { b } + x _ { b } ^ { T } m = - \frac { 1 } { 2 } ( x _ { b } - \Lambda _ { b b } ^ { - 1 } m ) ^ { T } \Lambda _ { b b } ( x _ { b } - \Lambda _ { b b } ^ { - 1 } m ) + \frac { 1 } { 2 } m ^ { T } \Lambda _ { b b } ^ { - 1 } m \ ( 2 . 8 4 )
$$

where we have deﬁned

$$
m = \Lambda _ { b b } \mu _ { b } - \Lambda _ { b a } ( x _ { a } - \mu _ { a } ) .
$$

We see that the dependence on x b has been cast into the standard quadratic form of a Gaussian distribution corresponding to the ﬁrst term on the right-hand side of (2.84), plus a term that does not depend on x b (but that does depend on x a ). Thus, when we take the exponential of this quadratic form, we see that the integration over x b required by (2.83) will take the form

$$
\int \exp \left \{ - \frac { 1 } { 2 } ( x _ { b } - \Lambda _ { b b } ^ { - 1 } m ) ^ { T } \Lambda _ { b b } ( x _ { b } - \Lambda _ { b b } ^ { - 1 } m ) \right \} \, d x _ { b } .
$$

This integration is easily performed by noting that it is the integral over an unnormalized Gaussian, and so the result will be the reciprocal of the normalization coefﬁcient. We know from the form of the normalized Gaussian given by (2.43), that this coefﬁcient is independent of the mean and depends only on the determinant of the covariance matrix. Thus, by completing the square with respect to x b , we can integrate out x b and the only term remaining from the contributions on the left-hand side of (2.84) that depends on x a is the last term on the right-hand side of (2.84) in which m is given by (2.85). Combining this term with the remaining terms from
