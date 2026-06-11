[Page 209]

wTSBw wTSWw

J(w) =

where SB is the between-class covariance matrix and is given by

(4.26)

SB = (m2 − m1)(m2 − m1)T (4.27) and SW is the total within-class covariance matrix, given by

###### SW =

(xn − m1)(xn − m1)T +

(xn − m2)(xn − m2)T. (4.28)

n∈C1

n∈C2

Differentiating (4.26) with respect to w, we ﬁnd that J(w) is maximized when

###### (wTSBw)SWw = (wTSWw)SBw. (4.29)

From (4.27), we see that SBw is always in the direction of (m2−m1). Furthermore, we do not care about the magnitude of w, only its direction, and so we can drop the

scalar factors (wTSBw) and (wTSWw). Multiplying both sides of (4.29) by S−1

W

we then obtain

w ∝ S−1

W (m2 − m1). (4.30)

Note that if the within-class covariance is isotropic, so that SW is proportional to the unit matrix, we ﬁnd that w is proportional to the difference of the class means, as discussed above.

The result (4.30) is known as Fisher’s linear discriminant, although strictly it is not a discriminant but rather a speciﬁc choice of direction for projection of the data down to one dimension. However, the projected data can subsequently be used to construct a discriminant, by choosing a threshold y0 so that we classify a new point as belonging to C1 if y(x) y0 and classify it as belonging to C2 otherwise. For example, we can model the class-conditional densities p(y|Ck) using Gaussian distributions and then use the techniques of Section 1.2.4 to ﬁnd the parameters of the Gaussian distributions by maximum likelihood. Having found Gaussian approximations to the projected classes, the formalism of Section 1.5.1 then gives an expression for the optimal threshold. Some justiﬁcation for the Gaussian assumption comes from the central limit theorem by noting that y = wTx is the sum of a set of random variables.

###### 4.1.5 Relation to least squares

The least-squares approach to the determination of a linear discriminant was based on the goal of making the model predictions as close as possible to a set of target values. By contrast, the Fisher criterion was derived by requiring maximum class separation in the output space. It is interesting to see the relationship between these two approaches. In particular, we shall show that, for the two-class problem, the Fisher criterion can be obtained as a special case of least squares.

So far we have considered 1-of-K coding for the target values. If, however, we adopt a slightly different target coding scheme, then the least-squares solution for
