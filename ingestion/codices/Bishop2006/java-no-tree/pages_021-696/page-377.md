[Page 377]

Exercises 357

###### Exercises

- 7.1 ( ) www Suppose we have a data set of input vectors {xn} with corresponding target values tn ∈ {−1,1}, and suppose that we model the density of input vectors within each class separately using a Parzen kernel density estimator (see Section 2.5.1) with a kernel k(x,x ). Write down the minimum misclassiﬁcation-rate decision rule assuming the two classes have equal prior probability. Show also that, if the kernel is chosen to be k(x,x ) = xTx , then the classiﬁcation rule reduces to simply assigning a new input vector to the class having the closest mean. Finally, show that, if the kernel takes the form k(x,x ) = φ(x)Tφ(x ), that the classiﬁcation is based on the closest mean in the feature space φ(x).

- 7.2 ( ) Show that, if the 1 on the right-hand side of the constraint (7.5) is replaced by some arbitrary constant γ > 0, the solution for the maximum margin hyperplane is unchanged.
- 7.3 ( ) Show that, irrespective of the dimensionality of the data space, a data set consisting of just two data points, one from each class, is sufﬁcient to determine the location of the maximum-margin hyperplane.
- 7.4 ( ) www Show that the value ρ of the margin for the maximum-margin hyperplane is given by

1 ρ2

=

N

n=1

an (7.123)

where {an} are given by maximizing (7.10) subject to the constraints (7.11) and (7.12).

- 7.5 ( ) Show that the values of ρ and {an} in the previous exercise also satisfy 1

ρ2

= 2 L(a) (7.124)

where L(a) is deﬁned by (7.10). Similarly, show that

1 ρ2

= w 2. (7.125)

- 7.6 ( ) Consider the logistic regression model with a target variable t ∈ {−1,1}. If we deﬁne p(t = 1|y) = σ(y) where y(x) is given by (7.1), show that the negative log likelihood, with the addition of a quadratic regularization term, takes the form (7.47).
- 7.7 ( ) Consider the Lagrangian (7.56) for the regression support vector machine. By


setting the derivatives of the Lagrangian with respect to w, b, ξn, and ξn to zero and then back substituting to eliminate the corresponding variables, show that the dual Lagrangian is given by (7.61).
