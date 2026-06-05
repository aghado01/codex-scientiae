[Page 340]

By working directly with the covariance function we have implicitly marginalized over the distribution of weights. If the weight prior is governed by hyperparameters, then their values will determine the length scales of the distribution over functions, as can be understood by studying the examples in Figure 5.11 for the case of a ﬁnite number of hidden units. Note that we cannot marginalize out the hyperparameters analytically, and must instead resort to techniques of the kind discussed in Section 6.4.

Exercises

6.1 (��) www Consider the dual formulation of the least squares linear regression

problem given in Section 6.1. Show that the solution for the components an of the vector a can be expressed as a linear combination of the elements of the vector

φ(xn). Denoting these coefﬁcients by the vector w, show that the dual of the dual formulation is given by the original representation in terms of the parameter vector w.

6.2 (��) In this exercise, we develop a dual formulation of the perceptron learning algorithm. Using the perceptron learning rule (4.55), show that the learned weight vector w can be written as a linear combination of the vectors tnφ(xn) where tn ∈ {−1,+1}. Denote the coefﬁcients of this linear combination by αn and derive a formulation of the perceptron learning algorithm, and the predictive function for the perceptron, in terms of the αn. Show that the feature vector φ(x) enters only in the form of the kernel function k(x,x�) = φ(x)Tφ(x�).

6.3 (�) The nearest-neighbour classiﬁer (Section 2.5.2) assigns a new input vector x to the same class as that of the nearest input vector xn from the training set, where in the simplest case, the distance is deﬁned by the Euclidean metric �x − xn�2. By expressing this rule in terms of scalar products and then making use of kernel substitution, formulate the nearest-neighbour classiﬁer for a general nonlinear kernel.

6.4 (�) In Appendix C, we give an example of a matrix that has positive elements but that has a negative eigenvalue and hence that is not positive deﬁnite. Find an example of the converse property, namely a 2 × 2 matrix with positive eigenvalues yet that has at least one negative element.

6.5 (�) www Verify the results (6.13) and (6.14) for constructing valid kernels. 6.6 (�) Verify the results (6.15) and (6.16) for constructing valid kernels. 6.7 (�) www Verify the results (6.17) and (6.18) for constructing valid kernels. 6.8 (�) Verify the results (6.19) and (6.20) for constructing valid kernels. 6.9 (�) Verify the results (6.21) and (6.22) for constructing valid kernels.

6.10 (�) Show that an excellent choice of kernel for learning a function f(x) is given by k(x,x�) = f(x)f(x�) by showing that a linear learning machine based on this kernel will always ﬁnd a solution proportional to f(x).
