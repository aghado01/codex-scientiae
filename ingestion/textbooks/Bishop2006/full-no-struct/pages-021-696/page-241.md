[Page 241]

To do so, assume that one of the basis functions φ 0 ( x ) = 1 so that the corresponding parameter w 0 plays the role of a bias.

4.3 ( ) Extend the result of Exercise 4.2 to show that if multiple linear constraints are satisﬁed simultaneously by the target vectors, then the same constraints will also be satisﬁed by the least-squares prediction of a linear model.

4.4 ( ) www Show that maximization of the class separation criterion given by (4.23) with respect to w , using a Lagrange multiplier to enforce the constraint w T w = 1 , leads to the result that w ∝ ( m 2 − m 1 ) .

4.5 ( ) By making use of (4.20), (4.23), and (4.24), show that the Fisher criterion (4.25) can be written in the form (4.26).

4.6 ( ) Using the deﬁnitions of the between-class and within-class covariance matrices given by (4.27) and (4.28), respectively, together with (4.34) and (4.36) and the choice of target values described in Section 4.1.5, show that the expression (4.33) that minimizes the sum-of-squares error function can be written in the form (4.37).

4.7 ( ) www Show that the logistic sigmoid function (4.59) satisﬁes the property σ ( − a ) = 1 − σ ( a ) and that its inverse is given by σ − 1 ( y ) = ln { y/ (1 − y ) } .

4.8 ( ) Using (4.57) and (4.58), derive the result (4.65) for the posterior class probability in the two-class generative model with Gaussian densities, and verify the results (4.66) and (4.67) for the parameters w and w 0 .

4.9 ( ) www Consider a generative classiﬁcation model for K classes deﬁned by prior class probabilities p ( C k ) = π k and general class-conditional densities p ( φ |C k ) where φ is the input feature vector. Suppose we are given a training data set { φ n , t n } where n = 1 ,...,N , and t n is a binary target vector of length K that uses the 1-ofK coding scheme, so that it has components t nj = I jk if pattern n is from class C k . Assuming that the data points are drawn independently from this model, show that the maximum-likelihood solution for the prior probabilities is given by

$$
\pi _ { k } = \frac { N _ { k } } { N }
$$

where N k is the number of data points assigned to class C k .

4.10 ( ) Consider the classiﬁcation model of Exercise 4.9 and now suppose that the class-conditional densities are given by Gaussian distributions with a shared covariance matrix, so that

$$
p ( \phi | \mathcal { C } _ { k } ) = \mathcal { N } ( \phi | \mu _ { k } , \Sigma ) . \\ \intertext { p ( \phi | \mathcal { C } _ { k } ) = \mathcal { N } ( \phi | \mu _ { k } , \Sigma ) . } \intertext { r ! 1 1 } \intertext { r ! 1 1 } \intertext { r ! 2 1 }
$$

Show that the maximum likelihood solution for the mean of the Gaussian distribution for class C k is given by 1 N

$$
\mu _ { k } = \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } t _ { n k } \phi _ { n }
$$
