[Page 194]

3.2 ( ) Show that the matrix

$$
\Phi ( \Phi ^ { T } \Phi ) ^ { - 1 } \Phi ^ { T }
$$

takes any vector v and projects it onto the space spanned by the columns of Φ . Use this result to show that the least-squares solution (3.15) corresponds to an orthogonal projection of the vector t onto the manifold S as shown in Figure 3.2.

3.3 ( ) Consider a data set in which each data point t n is associated with a weighting factor r n > 0 , so that the sum-of-squares error function becomes

$$
E _ { D } ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } r _ { n } \left \{ t _ { n } - w ^ { \top } \phi ( x _ { n } ) \right \} ^ { 2 } . \\ \intertext { s p r e s s } \text {for the solution } w ^ { * } \text { that minimizes } \text { this error function.  Give two}
$$

Find an expression for the solution w that minimizes this error function. Give two alternative interpretations of the weighted sum-of-squares error function in terms of (i) data dependent noise variance and (ii) replicated data points.

3.4 ( ) www Consider a linear model of the form

$$
y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \\ \intertext { a n o f s u r g e s } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D }
$$

together with a sum-of-squares error function of the form

$$
E _ { D } ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } .
$$

Now suppose that Gaussian noise i with zero mean and variance σ 2 is added independently to each of the input variables x i . By making use of E [ i ] = 0 and E [ i j ] = δ ij σ 2 , show that minimizing E D averaged over the noise distribution is equivalent to minimizing the sum-of-squares error for noise-free input variables with the addition of a weight-decay regularization term, in which the bias parameter w 0 is omitted from the regularizer.

3.5 ( ) www Using the technique of Lagrange multipliers, discussed in Appendix E, show that minimization of the regularized error function (3.29) is equivalent to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint (3.30). Discuss the relationship between the parameters η and λ .

3.6 ( ) www Consider a linear basis function regression model for a multivariate target variable t having a Gaussian distribution of the form

where together with a training data set comprising input basis vectors φ ( x n ) and corresponding target vectors t n , with n = 1 , . . . , N . Show that the maximum likelihood solution W ML for the parameter matrix W has the property that each column is given by an expression of the form (3.15), which was the solution for an isotropic noise distribution. Note that this is independent of the covariance matrix Σ . Show that the maximum likelihood solution for Σ is given by

$$
p ( t | W , \Sigma ) = \mathcal { N } ( t | y ( x , W ) , \Sigma )
$$

$$
y ( x , W ) = W ^ { T } \phi ( x )
$$
