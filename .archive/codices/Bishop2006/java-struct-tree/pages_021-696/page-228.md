[Page 228]

where we have made use of (4.88). Also, we have introduced the N × N diagonal matrix R with elements

Rnn = yn(1 − yn). (4.98) We see that the Hessian is no longer constant but depends on w through the weighting matrix R, corresponding to the fact that the error function is no longer quadratic. Using the property 0 < yn < 1, which follows from the form of the logistic sigmoid function, we see that uTHu > 0 for an arbitrary vector u, and so the Hessian matrix H is positive deﬁnite. It follows that the error function is a concave function of w

Exercise 4.15 and hence has a unique minimum.

The Newton-Raphson update formula for the logistic regression model then becomes

w(new) = w(old) − (ΦTRΦ)−1ΦT(y − t)

= (ΦTRΦ)−1 �

�

ΦTRΦw(old) − ΦT(y − t)

= (ΦTRΦ)−1ΦTRz (4.99) where z is an N-dimensional vector with elements

z = Φw(old) − R−1(y − t). (4.100)

We see that the update formula (4.99) takes the form of a set of normal equations for a weighted least-squares problem. Because the weighing matrix R is not constant but depends on the parameter vector w, we must apply the normal equations iteratively, each time using the new weight vector w to compute a revised weighing matrix R. For this reason, the algorithm is known as iterative reweighted least squares, or IRLS (Rubin, 1983). As in the weighted least-squares problem, the elements of the diagonal weighting matrix R can be interpreted as variances because the mean and variance of t in the logistic regression model are given by

E[t] = σ(x) = y (4.101) var[t] = E[t2] − E[t]2 = σ(x) − σ(x)2 = y(1 − y) (4.102)

where we have used the property t2 = t for t ∈ {0,1}. In fact, we can interpret IRLS as the solution to a linearized problem in the space of the variable a = wTφ. The quantity zn, which corresponds to the nth element of z, can then be given a simple interpretation as an effective target value in this space obtained by making a local linear approximation to the logistic sigmoid function around the current operating point w(old)

� � � �

dan dyn

an(w) � an(w(old)) +

(tn − yn)

w(old)

(yn − tn) yn(1 − yn)

= zn. (4.103)

= φTnw(old) −
