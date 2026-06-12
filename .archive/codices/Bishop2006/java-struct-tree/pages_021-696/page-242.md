[Page 242]

which represents the mean of those feature vectors assigned to class Ck. Similarly, show that the maximum likelihood solution for the shared covariance matrix is given by

�K

Nk N

Σ =

Sk (4.162) where

k=1

�N

1 Nk

Sk =

tnk(φn − µk)(φn − µk)T. (4.163)

n=1

Thus Σ is given by a weighted average of the covariances of the data associated with each class, in which the weighting coefﬁcients are given by the prior probabilities of the classes.

4.11 (��) Consider a classiﬁcation problem with K classes for which the feature vector φ has M components each of which can take L discrete states. Let the values of the components be represented by a 1-of-L binary coding scheme. Further suppose that, conditioned on the class Ck, the M components of φ are independent, so that the class-conditional density factorizes with respect to the feature vector components. Show that the quantities ak given by (4.63), which appear in the argument to the softmax function describing the posterior class probabilities, are linear functions of the components of φ. Note that this represents an example of the naive Bayes model which is discussed in Section 8.2.2.

4.12 (�) www Verify the relation (4.88) for the derivative of the logistic sigmoid func-

tion deﬁned by (4.59).

4.13 (�) www By making use of the result (4.88) for the derivative of the logistic sigmoid, show that the derivative of the error function (4.90) for the logistic regression model is given by (4.91).

4.14 (�) Show that for a linearly separable data set, the maximum likelihood solution for the logistic regression model is obtained by ﬁnding a vector w whose decision boundary wTφ(x) = 0 separates the classes and then taking the magnitude of w to inﬁnity.

4.15 (��) Show that the Hessian matrix H for the logistic regression model, given by (4.97), is positive deﬁnite. Here R is a diagonal matrix with elements yn(1 − yn), and yn is the output of the logistic regression model for input vector xn. Hence show that the error function is a concave function of w and that it has a unique minimum.

4.16 (�) Consider a binary classiﬁcation problem in which each observation xn is known to belong to one of two classes, corresponding to t = 0 and t = 1, and suppose that the procedure for collecting training data is imperfect, so that training points are sometimes mislabelled. For every data point xn, instead of having a value t for the class label, we have instead a value πn representing the probability that tn = 1. Given a probabilistic model p(t = 1|φ), write down the log likelihood function appropriate to such a data set.
