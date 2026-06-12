[Page 356]

Section 1.4 mensionality. This is not the case, however, because there are constraints amongst the feature values that restrict the effective dimensionality of feature space. To see this consider a simple second-order polynomial kernel that we can expand in terms of its components

k(x,z) = 1 + xTz 2 = (1 + x1z1 + x2z2)2

= 1 + 2x1z1 + 2x2z2 + x21z12 + 2x1z1x2z2 + x22z22

√2x1,

√2x2,x21,

√2x1x2,x22)(1,

√2z1,

√2z2,z12,

√2z1z2,z22)T

= (1,

= φ(x)Tφ(z). (7.42)

This kernel function therefore represents an inner product in a feature space having six dimensions, in which the mapping from input space to feature space is described by the vector function φ(x). However, the coefﬁcients weighting these different features are constrained to have speciﬁc forms. Thus any set of points in the original two-dimensional space x would be constrained to lie exactly on a two-dimensional nonlinear manifold embedded in the six-dimensional feature space.

We have already highlighted the fact that the support vector machine does not provide probabilistic outputs but instead makes classiﬁcation decisions for new input vectors. Veropoulos et al. (1999) discuss modiﬁcations to the SVM to allow the trade-off between false positive and false negative errors to be controlled. However, if we wish to use the SVM as a module in a larger probabilistic system, then probabilistic predictions of the class label t for new inputs x are required.

To address this issue, Platt (2000) has proposed ﬁtting a logistic sigmoid to the outputs of a previously trained support vector machine. Speciﬁcally, the required conditional probability is assumed to be of the form

p(t = 1|x) = σ (Ay(x) + B) (7.43)

where y(x) is deﬁned by (7.1). Values for the parameters A and B are found by minimizing the cross-entropy error function deﬁned by a training set consisting of pairs of values y(xn) and tn. The data used to ﬁt the sigmoid needs to be independent of that used to train the original SVM in order to avoid severe over-ﬁtting. This twostage approach is equivalent to assuming that the output y(x) of the support vector machine represents the log-odds of x belonging to class t = 1. Because the SVM training procedure is not speciﬁcally intended to encourage this, the SVM can give a poor approximation to the posterior probabilities (Tipping, 2001).

###### 7.1.2 Relation to logistic regression

As with the separable case, we can re-cast the SVM for nonseparable distributions in terms of the minimization of a regularized error function. This will also allow us to highlight similarities, and differences, compared to the logistic regression

Section 4.3.2 model.

We have seen that for data points that are on the correct side of the margin boundary, and which therefore satisfy yntn 1, we have ξn = 0, and for the
