[Page 582]

chapter, we shall consider techniques to determine an appropriate value of IV! from the data.

To begin with, consider the projection onto a one-dimensional space (M = 1). We can define the direction of this space using a D-dimensional vector Ul, which for convenience (and without loss of generality) we shall choose to be a unit vector so that uf Ul = 1 (note that we are only interested in the direction defined by Ul, not in the magnitude of Ul itself). Each data point X n is then projected onto a scalar value uf X n . The mean of the projected data is ufx where x is the sample set mean given by

$$
\overline { x } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n }
$$

and the variance of the projected data is given by

$$
\frac { 1 } { N } \sum _ { n = 1 } ^ { N } \left \{ u _ { 1 } ^ { T } x _ { n } - u _ { 1 } ^ { T } \overline { x } \right \} ^ { 2 } = u _ { 1 } ^ { T } S u _ { 1 } \,
$$

where S is the data covariance matrix defined by

$$
S = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \overline { x } ) ( x _ { n } - \overline { x } ) ^ { T } .
$$

We now maximize the projected variance UfSUl with respect to Ul. Clearly, this has to be a constrained maximization to prevent Ilulll ..... 00. The appropriate constraint comes from the normalization condition uf Ul = 1. To enforce this constraint, we introduce a Lagrange multiplier that we shall denote by AI, and then make an unconstrained maximization of

$$
( 1 2 . 4 )
$$

By setting the derivative with respect to Ul equal to zero, we see that this quantity will have a stationary point when

$$
S u _ { 1 } = \lambda _ { 1 } u _ { 1 }
$$

which says that Ul must be an eigenvector of S. If we left-multiply by uf and make use of uf Ul = 1, we see that the variance is given by

$$
\Im u _ { 1 } = \lambda _ { 1 }
$$

and so the variance will be a maximum when we set Ul equal to the eigenvector having the largest eigenvalue AI. This eigenvector is known as the first principal component.

We can define additional principal components in an incremental fashion by choosing each new direction to be that which maximizes the projected variance
