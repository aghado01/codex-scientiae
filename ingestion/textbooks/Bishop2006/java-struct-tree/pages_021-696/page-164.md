[Page 164]

in which the data points are considered one at a time, and the model parameters updated after each such presentation. Sequential learning is also appropriate for realtime applications in which the data observations are arriving in a continuous stream, and predictions must be made before all of the data points are seen.

We can obtain a sequential learning algorithm by applying the technique of stochastic gradient descent, also known as sequential gradient descent, as follows. If the error function comprises a sum over data points E =

�

n En, then after presentation of pattern n, the stochastic gradient descent algorithm updates the parameter vector w using

w(τ+1) = w(τ) − η∇En (3.22)

where τ denotes the iteration number, and η is a learning rate parameter. We shall discuss the choice of value for η shortly. The value of w is initialized to some starting vector w(0). For the case of the sum-of-squares error function (3.12), this gives

w(τ+1) = w(τ) + η(tn − w(τ)Tφn)φn (3.23)

where φn = φ(xn). This is known as least-mean-squares or the LMS algorithm. The value of η needs to be chosen with care to ensure that the algorithm converges (Bishop and Nabney, 2008).

3.1.4 Regularized least squares

In Section 1.1, we introduced the idea of adding a regularization term to an error function in order to control over-ﬁtting, so that the total error function to be minimized takes the form

ED(w) + λEW(w) (3.24) where λ is the regularization coefﬁcient that controls the relative importance of the data-dependent error ED(w) and the regularization term EW(w). One of the simplest forms of regularizer is given by the sum-of-squares of the weight vector elements

1 2

EW(w) =

wTw. (3.25) If we also consider the sum-of-squares error function given by

�N

1 2

E(w) =

n=1

then the total error function becomes

{tn − wTφ(xn)}2 (3.26)

�N

1 2

λ 2

{tn − wTφ(xn)}2 +

wTw. (3.27)

n=1

This particular choice of regularizer is known in the machine learning literature as weight decay because in sequential learning algorithms, it encourages weight values to decay towards zero, unless supported by the data. In statistics, it provides an example of a parameter shrinkage method because it shrinks parameter values towards
