[Page 240]

We now apply the approximation σ(a) Φ(λa) to the probit functions appearing on both sides of this equation, leading to the following approximation for the convolution of a logistic sigmoid with a Gaussian

σ(a)N(a|µ,σ2)da σ κ(σ2)µ (4.153)

where we have deﬁned

κ(σ2) = (1 + πσ2/8)−1/2. (4.154)

Applying this result to (4.151) we obtain the approximate predictive distribution in the form

p(C1|φ,t) = σ κ(σa2)µa (4.155)

where µa and σa2 are deﬁned by (4.149) and (4.150), respectively, and κ(σa2) is deﬁned by (4.154).

Note that the decision boundary corresponding to p(C1|φ,t) = 0.5 is given by µa = 0, which is the same as the decision boundary obtained by using the MAP value for w. Thus if the decision criterion is based on minimizing misclassiﬁcation rate, with equal prior probabilities, then the marginalization over w has no effect. However, for more complex decision criteria it will play an important role. Marginalization of the logistic sigmoid model under a Gaussian approximation to the posterior distribution will be illustrated in the context of variational inference in Figure 10.13.

###### Exercises

- 4.1 ( ) Given a set of data points {xn}, we can deﬁne the convex hull to be the set of all points x given by

x =

n

αnxn (4.156)

where αn 0 and n αn = 1. Consider a second set of points {yn} together with their corresponding convex hull. By deﬁnition, the two sets of points will be linearly

separable if there exists a vector w and a scalar w0 such that wTxn + w0 > 0 for all xn, and wTyn +w0 < 0 for all yn. Show that if their convex hulls intersect, the two sets of points cannot be linearly separable, and conversely that if they are linearly separable, their convex hulls do not intersect.

- 4.2 ( ) www Consider the minimization of a sum-of-squares error function (4.15), and suppose that all of the target vectors in the training set satisfy a linear constraint


###### aTtn + b = 0 (4.157)

where tn corresponds to the nth row of the matrix T in (4.15). Show that as a consequence of this constraint, the elements of the model prediction y(x) given by the least-squares solution (4.17) also satisfy this constraint, so that

###### aTy(x) + b = 0. (4.158)
