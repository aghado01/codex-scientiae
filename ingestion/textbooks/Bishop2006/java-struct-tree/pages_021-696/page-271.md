[Page 271]

5.4.2 Outer product approximation

When neural networks are applied to regression problems, it is common to use a sum-of-squares error function of the form

�N

1 2

E =

(yn − tn)2 (5.82)

n=1

where we have considered the case of a single output in order to keep the notation Exercise 5.16 simple (the extension to several outputs is straightforward). We can then write the

Hessian matrix in the form

�N

�N

∇yn∇yn +

(yn − tn)∇∇yn. (5.83)

H = ∇∇E =

n=1

n=1

If the network has been trained on the data set, and its outputs yn happen to be very close to the target values tn, then the second term in (5.83) will be small and can be neglected. More generally, however, it may be appropriate to neglect this term by the following argument. Recall from Section 1.5.5 that the optimal function that minimizes a sum-of-squares loss is the conditional average of the target data. The quantity (yn − tn) is then a random variable with zero mean. If we assume that its value is uncorrelated with the value of the second derivative term on the right-hand

Exercise 5.17 side of (5.83), then the whole term will average to zero in the summation over n.

By neglecting the second term in (5.83), we arrive at the Levenberg–Marquardt approximation or outer product approximation (because the Hessian matrix is built up from a sum of outer products of vectors), given by

�N

H �

bnbTn (5.84)

n=1

where bn = ∇yn = ∇an because the activation function for the output units is simply the identity. Evaluation of the outer product approximation for the Hessian is straightforward as it only involves ﬁrst derivatives of the error function, which can be evaluated efﬁciently in O(W) steps using standard backpropagation. The elements of the matrix can then be found in O(W2) steps by simple multiplication. It is important to emphasize that this approximation is only likely to be valid for a network that has been trained appropriately, and that for a general network mapping the second derivative terms on the right-hand side of (5.83) will typically not be negligible.

In the case of the cross-entropy error function for a network with logistic sigmoid Exercise 5.19 output-unit activation functions, the corresponding approximation is given by

�N

yn(1 − yn)bnbTn. (5.85)

H �

n=1

An analogous result can be obtained for multiclass networks having softmax outputExercise 5.20 unit activation functions.
