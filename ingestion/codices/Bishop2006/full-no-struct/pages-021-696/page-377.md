[Page 377]

# Exercises

7.1 ( ) www Suppose we have a data set of input vectors { x n } with corresponding target values t n ∈ {− 1 , 1 } , and suppose that we model the density of input vectors within each class separately using a Parzen kernel density estimator (see Section 2.5.1) with a kernel k ( x , x ) . Write down the minimum misclassiﬁcation-rate decision rule assuming the two classes have equal prior probability. Show also that, if the kernel is chosen to be k ( x , x ) = x T x , then the classiﬁcation rule reduces to simply assigning a new input vector to the class having the closest mean. Finally, show that, if the kernel takes the form k ( x , x ) = φ ( x ) T φ ( x ) , that the classiﬁcation is based on the closest mean in the feature space φ ( x ) .

7.2 ( ) Show that, if the 1 on the right-hand side of the constraint (7.5) is replaced by some arbitrary constant γ > 0 , the solution for the maximum margin hyperplane is unchanged.

7.3 ( ) Show that, irrespective of the dimensionality of the data space, a data set consisting of just two data points, one from each class, is sufﬁcient to determine the location of the maximum-margin hyperplane.

7.4 ( ) www Show that the value ρ of the margin for the maximum-margin hyperplane is given by

$$
\frac { 1 } { \rho ^ { 2 } } = \sum _ { n = 1 } ^ { N } a _ { n } \\ \maximizing \left ( 7 . 1 0 \right ) \text { subject to the constraints } \left ( 7 . 1 1 \right ) \text { and}
$$

where { a n } are given by maximizing (7.10) subject to the constraints (7.11) and (7.12).

7.5 ( ) Show that the values of ρ and { a n } in the previous exercise also satisfy

$$
\frac { 1 } { \rho ^ { 2 } } = 2 \widetilde { L } ( a ) \\ \\ . 1 0 ) . \text { Similarly, show that}
$$

where L ( a ) is deﬁned by (7.10). Similarly, show that 1 ρ 2 = w 2 .

$$
\frac { 1 } { \rho ^ { 2 } } = \| w \| ^ { 2 } .
$$

7.6 ( ) Consider the logistic regression model with a target variable t ∈ {− 1 , 1 } . If we deﬁne p ( t = 1 | y ) = σ ( y ) where y ( x ) is given by (7.1), show that the negative log likelihood, with the addition of a quadratic regularization term, takes the form (7.47).

7.7 ( ) Consider the Lagrangian (7.56) for the regression support vector machine. By setting the derivatives of the Lagrangian with respect to w , b , ξ n , and ξ n to zero and then back substituting to eliminate the corresponding variables, show that the dual Lagrangian is given by (7.61).
