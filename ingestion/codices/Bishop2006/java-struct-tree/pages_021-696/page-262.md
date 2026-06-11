[Page 262]

uation of other derivatives such as the Jacobian and Hessian matrices, as we shall see later in this chapter. Similarly, the second stage of weight adjustment using the calculated derivatives can be tackled using a variety of optimization schemes, many of which are substantially more powerful than simple gradient descent.

5.3.1 Evaluation of error-function derivatives

We now derive the backpropagation algorithm for a general network having arbitrary feed-forward topology, arbitrary differentiable nonlinear activation functions, and a broad class of error function. The resulting formulae will then be illustrated using a simple layered network structure having a single layer of sigmoidal hidden units together with a sum-of-squares error.

Many error functions of practical interest, for instance those deﬁned by maximum likelihood for a set of i.i.d. data, comprise a sum of terms, one for each data point in the training set, so that

�N

E(w) =

En(w). (5.44)

n=1

Here we shall consider the problem of evaluating ∇En(w) for one such term in the error function. This may be used directly for sequential optimization, or the results can be accumulated over the training set in the case of batch methods.

Consider ﬁrst a simple linear model in which the outputs yk are linear combinations of the input variables xi so that

�

yk =

wkixi (5.45)

i

together with an error function that, for a particular input pattern n, takes the form

1 2 �

En =

(ynk − tnk)2 (5.46)

k

where ynk = yk(xn,w). The gradient of this error function with respect to a weight wji is given by

∂En ∂wji

= (ynj − tnj)xni (5.47)

which can be interpreted as a ‘local’ computation involving the product of an ‘error signal’ ynj − tnj associated with the output end of the link wji and the variable xni associated with the input end of the link. In Section 4.3.2, we saw how a similar formula arises with the logistic sigmoid activation function together with the cross entropy error function, and similarly for the softmax activation function together with its matching cross-entropy error function. We shall now see how this simple result extends to the more complex setting of multilayer feed-forward networks.

In a general feed-forward network, each unit computes a weighted sum of its inputs of the form

�

aj =

wjizi (5.48)

i
