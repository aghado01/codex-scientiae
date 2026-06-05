[Page 271]

# Exercise 5.16

# Exercise 5.17

Exercise 5.19

Exercise 5.20

When neural networks are applied to regression problems, it is common to use a sum-of-squares error function of the form

$$
E = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } ( y _ { n } - t _ { n } ) ^ { 2 } \\ \text {dered the case of a single output in order to keep the notation}
$$

where we have considered the case of a single output in order to keep the notation simple (the extension to several outputs is straightforward). We can then write the Hessian matrix in the form

$$
H = \nabla \nabla E = \sum _ { n = 1 } ^ { N } \nabla y _ { n } \nabla y _ { n } + \sum _ { n = 1 } ^ { N } ( y _ { n } - t _ { n } ) \nabla \nabla y _ { n } . \\ \intertext { h e c k w o r k } \intertext { h a s b e n t i n d e } \intertext { o w n t r a c k } \intertext { e x t e r } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n t r a c k } \intertext { s u p s } \intertext { e f t r a c k } \intertext { o w n
$$

If the network has been trained on the data set, and its outputs y n happen to be very close to the target values t n , then the second term in (5.83) will be small and can be neglected. More generally, however, it may be appropriate to neglect this term by the following argument. Recall from Section 1.5.5 that the optimal function that minimizes a sum-of-squares loss is the conditional average of the target data. The quantity ( y n − t n ) is then a random variable with zero mean. If we assume that its value is uncorrelated with the value of the second derivative term on the right-hand side of (5.83), then the whole term will average to zero in the summation over n .

By neglecting the second term in (5.83), we arrive at the Levenberg–Marquardt approximation or outer product approximation (because the Hessian matrix is built up from a sum of outer products of vectors), given by

$$
H \simeq \sum _ { n = 1 } ^ { N } b _ { n } b _ { n } ^ { T } & & ( 5 . 8 4 ) \\ a _ { n } \, \text { because the activation function for the output units is}
$$

where b n = ∇ y n = ∇ a n because the activation function for the output units is simply the identity. Evaluation of the outer product approximation for the Hessian is straightforward as it only involves ﬁrst derivatives of the error function, which can be evaluated efﬁciently in O ( W ) steps using standard backpropagation. The elements of the matrix can then be found in O ( W 2 ) steps by simple multiplication. It is important to emphasize that this approximation is only likely to be valid for a network that has been trained appropriately, and that for a general network mapping the second derivative terms on the right-hand side of (5.83) will typically not be negligible.

In the case of the cross-entropy error function for a network with logistic sigmoid output-unit activation functions, the corresponding approximation is given by

$$
H \simeq \sum _ { n = 1 } ^ { N } y _ { n } ( 1 - y _ { n } ) b _ { n } b _ { n } ^ { T } . \\ \intertext { l a t c a n b e o t a i n d f o r m u l c i s t r o w s h i v e s }
$$

An analogous result can be obtained for multiclass networks having softmax outputunit activation functions.
