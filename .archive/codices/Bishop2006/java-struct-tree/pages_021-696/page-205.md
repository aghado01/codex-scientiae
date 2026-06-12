[Page 205]

where W� is a matrix whose kth column comprises the D + 1-dimensional vector w�k = (wk0,wkT)T and x� is the corresponding augmented input vector (1,xT)T with a dummy input x0 = 1. This representation was discussed in detail in Section 3.1. A new input x is then assigned to the class for which the output yk = w�kTx� is largest.

We now determine the parameter matrix W� by minimizing a sum-of-squares error function, as we did for regression in Chapter 3. Consider a training data set {xn,tn} where n = 1,...,N, and deﬁne a matrix T whose nth row is the vector tTn, together with a matrix X� whose nth row is x�Tn. The sum-of-squares error function can then be written as

Tr�(X�W� − T)T(X�W� − T)�. (4.15)

1 2

ED(W�) =

Setting the derivative with respect to W� to zero, and rearranging, we then obtain the solution for W� in the form

W� = (X�TX�)−1X�TT = X�†T (4.16)

where X�† is the pseudo-inverse of the matrix X�, as discussed in Section 3.1.1. We then obtain the discriminant function in the form

y(x) = W�Tx� = TT �

�T

X�†

x�. (4.17)

An interesting property of least-squares solutions with multiple target variables is that if every target vector in the training set satisﬁes some linear constraint

aTtn + b = 0 (4.18) for some constants a and b, then the model prediction for any value of x will satisfy

Exercise 4.2 the same constraint so that

aTy(x) + b = 0. (4.19)

Thus if we use a 1-of-K coding scheme for K classes, then the predictions made by the model will have the property that the elements of y(x) will sum to 1 for any value of x. However, this summation constraint alone is not sufﬁcient to allow the model outputs to be interpreted as probabilities because they are not constrained to lie within the interval (0,1).

The least-squares approach gives an exact closed-form solution for the discriminant function parameters. However, even as a discriminant function (where we use it to make decisions directly and dispense with any probabilistic interpretation) it suf-

Section 2.3.7 fers from some severe problems. We have already seen that least-squares solutions lack robustness to outliers, and this applies equally to the classiﬁcation application, as illustrated in Figure 4.4. Here we see that the additional data points in the righthand ﬁgure produce a signiﬁcant change in the location of the decision boundary, even though these point would be correctly classiﬁed by the original decision boundary in the left-hand ﬁgure. The sum-of-squares error function penalizes predictions that are ‘too correct’ in that they lie a long way on the correct side of the decision
