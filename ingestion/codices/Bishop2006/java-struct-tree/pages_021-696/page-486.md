[Page 486]

divergence, and the minimum occurs when qj(Zj) = �p(X,Zj). Thus we obtain a general expression for the optimal solution qj�(Zj) given by

lnqj�(Zj) = Ei�=j[lnp(X,Z)] + const. (10.9)

It is worth taking a few moments to study the form of this solution as it provides the basis for applications of variational methods. It says that the log of the optimal solution for factor qj is obtained simply by considering the log of the joint distribution over all hidden and visible variables and then taking the expectation with respect to all of the other factors {qi} for i �= j.

The additive constant in (10.9) is set by normalizing the distribution qj�(Zj). Thus if we take the exponential of both sides and normalize, we have

exp(Ei�=j[lnp(X,Z)]) � exp(Ei�=j[lnp(X,Z)]) dZj

qj�(Zj) =

.

In practice, we shall ﬁnd it more convenient to work with the form (10.9) and then reinstate the normalization constant (where required) by inspection. This will become clear from subsequent examples.

The set of equations given by (10.9) for j = 1,...,M represent a set of consistency conditions for the maximum of the lower bound subject to the factorization constraint. However, they do not represent an explicit solution because the expression on the right-hand side of (10.9) for the optimum qj�(Zj) depends on expectations computed with respect to the other factors qi(Zi) for i �= j. We will therefore seek a consistent solution by ﬁrst initializing all of the factors qi(Zi) appropriately and then cycling through the factors and replacing each in turn with a revised estimate given by the right-hand side of (10.9) evaluated using the current estimates for all of the other factors. Convergence is guaranteed because bound is convex with respect to each of the factors qi(Zi) (Boyd and Vandenberghe, 2004).

10.1.2 Properties of factorized approximations

Our approach to variational inference is based on a factorized approximation to the true posterior distribution. Let us consider for a moment the problem of approximating a general distribution by a factorized distribution. To begin with, we discuss the problem of approximating a Gaussian distribution using a factorized Gaussian, which will provide useful insight into the types of inaccuracy introduced in using factorized approximations. Consider a Gaussian distribution p(z) = N(z|µ,Λ−1) over two correlated variables z = (z1,z2) in which the mean and precision have elements

µ = �

�, Λ = �

Λ11 Λ12 Λ21 Λ22� (10.10)

µ1 µ2

and Λ21 = Λ12 due to the symmetry of the precision matrix. Now suppose we wish to approximate this distribution using a factorized Gaussian of the form q(z) =

q1(z1)q2(z2). We ﬁrst apply the general result (10.9) to ﬁnd an expression for the
