[Page 305]

5.3 (��) Consider a regression problem involving multiple target variables in which it is assumed that the distribution of the targets, conditioned on the input vector x, is a Gaussian of the form

p(t|x,w) = N(t|y(x,w),Σ) (5.192)

where y(x,w) is the output of a neural network with input vector x and weight vector w, and Σ is the covariance of the assumed Gaussian noise on the targets. Given a set of independent observations of x and t, write down the error function that must be minimized in order to ﬁnd the maximum likelihood solution for w, if we assume that Σ is ﬁxed and known. Now assume that Σ is also to be determined from the data, and write down an expression for the maximum likelihood solution for Σ. Note that the optimizations of w and Σ are now coupled, in contrast to the case of independent target variables discussed in Section 5.2.

5.4 (��) Consider a binary classiﬁcation problem in which the target values are t ∈ {0,1}, with a network output y(x,w) that represents p(t = 1|x), and suppose that there is a probability � that the class label on a training data point has been incorrectly set. Assuming independent and identically distributed data, write down the error function corresponding to the negative log likelihood. Verify that the error function (5.21) is obtained when � = 0. Note that this error function makes the model robust to incorrectly labelled data, in contrast to the usual error function.

5.5 (�) www Show that maximizing likelihood for a multiclass neural network model

in which the network outputs have the interpretation yk(x,w) = p(tk = 1|x) is equivalent to the minimization of the cross-entropy error function (5.24).

5.6 (�) www Show the derivative of the error function (5.21) with respect to the

activation ak for an output unit having a logistic sigmoid activation function satisﬁes (5.18).

5.7 (�) Show the derivative of the error function (5.24) with respect to the activation ak

for output units having a softmax activation function satisﬁes (5.18).

5.8 (�) We saw in (4.88) that the derivative of the logistic sigmoid activation function can be expressed in terms of the function value itself. Derive the corresponding result for the ‘tanh’ activation function deﬁned by (5.59).

5.9 (�) www The error function (5.21) for binary classiﬁcation problems was derived for a network having a logistic-sigmoid output activation function, so that 0 � y(x,w) � 1, and data having target values t ∈ {0,1}. Derive the corresponding error function if we consider a network having an output −1 � y(x,w) � 1 and target values t = 1 for class C1 and t = −1 for class C2. What would be the appropriate choice of output unit activation function?

5.10 (�) www Consider a Hessian matrix H with eigenvector equation (5.33). By

setting the vector v in (5.39) equal to each of the eigenvectors ui in turn, show that H is positive deﬁnite if, and only if, all of its eigenvalues are positive.
