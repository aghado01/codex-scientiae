[Page 209]

$$
J ( w ) = \frac { w ^ { T } S _ { B } w } { w ^ { T } S _ { W } w }
$$

where S B is the between-class covariance matrix and is given by

$$
S _ { B } = ( m _ { 2 } - m _ { 1 } ) ( m _ { 2 } - m _ { 1 } ) ^ { T }
$$

and S W is the total within-class covariance matrix, given by

$$
S _ { W } & = \sum _ { n \in \mathcal { C } _ { 1 } } ( x _ { n } - m _ { 1 } ) ( x _ { n } - m _ { 1 } ) ^ { T } + \sum _ { n \in \mathcal { C } _ { 2 } } ( x _ { n } - m _ { 2 } ) ( x _ { n } - m _ { 2 } ) ^ { T } . \quad ( 4 . 2 8 ) \\ \intertext { S i f f e x u t i t i n g ( 4 ) $ 2 ( x _ { n } - m _ { 1 } ) ( x _ { n } - m _ { 1 } ) ^ { T } + \sum _ { n \in \mathcal { C } _ { 1 } } ( x _ { n } - m _ { 2 } ) ( x _ { n } - m _ { 2 } ) ^ { T } . }
$$

Differentiating (4.26) with respect to w , we ﬁnd that J ( w ) is maximized when

$$
( w ^ { T } S _ { B } w ) S _ { W } w = ( w ^ { T } S _ { W } w ) S _ { B } w .
$$

From (4.27), we see that S B w is always in the direction of ( m 2 − m 1 ) . Furthermore, we do not care about the magnitude of w , only its direction, and so we can drop the scalar factors ( w T S B w ) and ( w T S W w ) . Multiplying both sides of (4.29) by S − 1 W we then obtain 1

$$
w \, \in S _ { W } ^ { - 1 } ( m _ { 2 } - m _ { 1 } ) . \\ \\ \intertext { w \, \infty \, S _ { W } ^ { - 1 } ( m _ { 2 } - m _ { 1 } ) . } \\ \intertext { w \, \infty \, S _ { W } ^ { - 1 } ( m _ { 2 } - m _ { 1 } ) . }
$$

Note that if the within-class covariance is isotropic, so that S W is proportional to the unit matrix, we ﬁnd that w is proportional to the difference of the class means, as discussed above.

The result (4.30) is known as Fisher’s linear discriminant , although strictly it is not a discriminant but rather a speciﬁc choice of direction for projection of the data down to one dimension. However, the projected data can subsequently be used to construct a discriminant, by choosing a threshold y 0 so that we classify a new point as belonging to C 1 if y ( x ) y 0 and classify it as belonging to C 2 otherwise. For example, we can model the class-conditional densities p ( y |C k ) using Gaussian distributions and then use the techniques of Section 1.2.4 to ﬁnd the parameters of the Gaussian distributions by maximum likelihood. Having found Gaussian approximations to the projected classes, the formalism of Section 1.5.1 then gives an expression for the optimal threshold. Some justiﬁcation for the Gaussian assumption comes from the central limit theorem by noting that y = w T x is the sum of a set of random variables.

# 4.1.5 Relation to least squares

The least-squares approach to the determination of a linear discriminant was based on the goal of making the model predictions as close as possible to a set of target values. By contrast, the Fisher criterion was derived by requiring maximum class separation in the output space. It is interesting to see the relationship between these two approaches. In particular, we shall show that, for the two-class problem, the Fisher criterion can be obtained as a special case of least squares.

So far we have considered 1-ofK coding for the target values. If, however, we adopt a slightly different target coding scheme, then the least-squares solution for
