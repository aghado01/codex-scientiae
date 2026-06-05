[Page 242]

which represents the mean of those feature vectors assigned to class C k . Similarly, show that the maximum likelihood solution for the shared covariance matrix is given by

$$
\Sigma = \sum _ { k = 1 } ^ { K } \frac { N _ { k } } { N } S _ { k } \\
$$

where

$$
S _ { k } = \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } t _ { n k } ( \phi _ { n } - \mu _ { k } ) ( \phi _ { n } - \mu _ { k } ) ^ { T } . \\ \text {given by a weighted average of the covariances of the data associated with}
$$

Thus Σ is given by a weighted average of the covariances of the data associated with each class, in which the weighting coefﬁcients are given by the prior probabilities of the classes.

4.11 ( ) Consider a classiﬁcation problem with K classes for which the feature vector φ has M components each of which can take L discrete states. Let the values of the components be represented by a 1-ofL binary coding scheme. Further suppose that, conditioned on the class C k , the M components of φ are independent, so that the class-conditional density factorizes with respect to the feature vector components. Show that the quantities a k given by (4.63), which appear in the argument to the softmax function describing the posterior class probabilities, are linear functions of the components of φ . Note that this represents an example of the naive Bayes model which is discussed in Section 8.2.2.

4.12 ( ) www Verify the relation (4.88) for the derivative of the logistic sigmoid function deﬁned by (4.59).

4.13 ( ) www By making use of the result (4.88) for the derivative of the logistic sigmoid, show that the derivative of the error function (4.90) for the logistic regression model is given by (4.91).

4.14 ( ) Show that for a linearly separable data set, the maximum likelihood solution for the logistic regression model is obtained by ﬁnding a vector w whose decision boundary w T φ ( x ) = 0 separates the classes and then taking the magnitude of w to inﬁnity.

4.15 ( ) Show that the Hessian matrix H for the logistic regression model, given by (4.97), is positive deﬁnite. Here R is a diagonal matrix with elements y n (1 − y n ) , and y n is the output of the logistic regression model for input vector x n . Hence show that the error function is a concave function of w and that it has a unique minimum.

4.16 ( ) Consider a binary classiﬁcation problem in which each observation x n is known to belong to one of two classes, corresponding to t = 0 and t = 1 , and suppose that the procedure for collecting training data is imperfect, so that training points are sometimes mislabelled. For every data point x n , instead of having a value t for the class label, we have instead a value π n representing the probability that t n = 1 . Given a probabilistic model p ( t = 1 | φ ) , write down the log likelihood function appropriate to such a data set.
