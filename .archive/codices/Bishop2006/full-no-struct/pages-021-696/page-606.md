[Page 606]

Exercise 12.25

to compute in O(D) steps), which is convenient because often M « D. Similarly, the M-step equations take the form

$$
W ^ { n } \ = \ \left [ \sum _ { n = 1 } ^ { N } ( x _ { n } - \overline { x } ) \mathbb { E } [ z _ { n } ] ^ { T } \right ] \left [ \sum _ { n = 1 } ^ { N } \mathbb { E } [ z _ { n } z _ { n } ^ { T } ] \right ] ^ { - 1 } \quad ( 1 2 . 6 )
$$

$$
\Psi ^ { n e w } \ = \ d i a g \left \{ S - W _ { n e w } \frac { 1 } { \overline { N } } \sum _ { n = 1 } ^ { N } \mathbb { E } [ z _ { n } ] ( x _ { n } - \overline { x } ) ^ { T } \right \} \quad ( 1 2 . 7 0 )
$$

where the 'diag' operator sets all of the nondiagonal elements of a matrix to zero. A Bayesian treatment of the factor analysis model can be obtained by a straightforward application of the techniques discussed in this book.

Another difference between probabilistic PCA and factor analysis concerns their different behaviour under transformations of the data set. For PCA and probabilistic PCA, if we rotate the coordinate system in data space, then we obtain exactly the same fit to the data but with the W matrix transformed by the corresponding rotation matrix. However, for factor analysis, the analogous property is that if we make a component-wise re-scaling of the data vectors, then this is absorbed into a corresponding re-scaling of the elements of \)i.

# 12.3. Kernel peA

In Chapter 6, we saw how the technique of kernel substitution allows us to take an algorithm expressed in terms of scalar products of the form x T x' and generalize that algorithm by replacing the scalar products with a nonlinear kernel. Here we apply this technique of kernel substitution to principal component analysis, thereby obtaining a nonlinear generalization called kernel peA (Scholkopf et al., 1998).

Consider a data set {x n } of observations, where n = 1, ... , N, in a space of dimensionality D. In order to keep the notation uncluttered, we shall assume that we have already subtracted the sample mean from each of the vectors X n , so that Ln X n = O. The first step is to express conventional PCA in such a form that the data vectors {x n } appear only in the form of the scalar products x~ X m . Recall that the principal components are defined by the eigenvectors Ui of the covariance matrix

$$
\text {Su} _ { i } = \lambda _ { i } \mathbf u _ { i }
$$

where i = 1, ... ,D. Here the D x D sample covariance matrix S is defined by

$$
S = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n } x _ { n } ^ { T } ,
$$

and the eigenvectors are normalized such that uT Ui = 1. Now consider a nonlinear transformation ¢(x) into

an M -dimensional feature space, so that each data point X n is thereby projected onto a point ¢(x n ). We can
