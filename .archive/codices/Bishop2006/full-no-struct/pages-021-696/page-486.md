[Page 486]

divergence, and the minimum occurs when q j ( Z j ) = p ( X , Z j ) . Thus we obtain a general expression for the optimal solution q j ( Z j ) given by ln q j ( Z j ) = E i = j [ln p ( X , Z )] + const . (10.9)

$$
\ln q _ { j } ^ { * } ( Z _ { j } ) = \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] + c o n s t .
$$

/negationslash

It is worth taking a few moments to study the form of this solution as it provides the basis for applications of variational methods. It says that the log of the optimal solution for factor q j is obtained simply by considering the log of the joint distribution over all hidden and visible variables and then taking the expectation with respect to all of the other factors { q i } for i = j . The additive constant in (10.9) is set by normalizing the distribution q j ( Z j ) .

/negationslash

The additive constant in (10.9) is set by normalizing the distribution q /star j ( Z j ) . Thus if we take the exponential of both sides and normalize, we have

$$
q _ { j } ^ { * } ( Z _ { j } ) = \frac { \exp \left ( \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] \right ) } { \int \exp \left ( \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] \right ) \, d Z _ { j } } . \\ \int \exp \left ( \mathbb { E } _ { i \neq j } [ \ln p ( X , Z ) ] \right ) \, d Z _ { j }
$$

/negationslash

/negationslash

In practice, we shall ﬁnd it more convenient to work with the form (10.9) and then reinstate the normalization constant (where required) by inspection. This will become clear from subsequent examples.

The set of equations given by (10.9) for j = 1 ,...,M represent a set of consistency conditions for the maximum of the lower bound subject to the factorization constraint. However, they do not represent an explicit solution because the expression on the right-hand side of (10.9) for the optimum q j ( Z j ) depends on expectations computed with respect to the other factors q i ( Z i ) for i = j . We will therefore seek a consistent solution by ﬁrst initializing all of the factors q i ( Z i ) appropriately and then cycling through the factors and replacing each in turn with a revised estimate given by the right-hand side of (10.9) evaluated using the current estimates for all of the other factors. Convergence is guaranteed because bound is convex with respect to each of the factors q i ( Z i ) (Boyd and Vandenberghe, 2004).

/negationslash

# 10.1.2 Properties of factorized approximations

Our approach to variational inference is based on a factorized approximation to the true posterior distribution. Let us consider for a moment the problem of approximating a general distribution by a factorized distribution. To begin with, we discuss the problem of approximating a Gaussian distribution using a factorized Gaussian, which will provide useful insight into the types of inaccuracy introduced in using factorized approximations. Consider a Gaussian distribution p ( z ) = N ( z | µ , Λ − 1 ) over two correlated variables z = ( z 1 ,z 2 ) in which the mean and precision have elements Λ Λ

$$
\mu & = \begin{pmatrix} \mu _ { 1 } \\ \mu _ { 2 } \end{pmatrix} , \quad \Lambda = \begin{pmatrix} \Lambda _ { 1 1 } & \Lambda _ { 1 2 } \\ \Lambda _ { 2 1 } & \Lambda _ { 2 2 } \end{pmatrix} \\ \Lambda _ { 1 3 } \, d e \, t o \, the \, \text {symmetry of the precision matrix} \, \text {,  Now suppose we}
$$

and Λ 21 = Λ 12 due to the symmetry of the precision matrix. Now suppose we wish to approximate this distribution using a factorized Gaussian of the form q ( z ) = q 1 ( z 1 ) q 2 ( z 2 ) . We ﬁrst apply the general result (10.9) to ﬁnd an expression for the
