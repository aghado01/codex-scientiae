[Page 266]

Next we compute the δ’s for each output unit using

δk = yk − tk. (5.65) Then we backpropagate these to obtain δs for the hidden units using

δj = (1 − zj2)

K

wkjδk. (5.66)

k=1

Finally, the derivatives with respect to the ﬁrst-layer and second-layer weights are given by

∂En ∂wkj(2)

∂En ∂wji(1)

= δjxi,

= δkzj. (5.67)

###### 5.3.3 Efﬁciency of backpropagation

One of the most important aspects of backpropagation is its computational efﬁciency. To understand this, let us examine how the number of computer operations required to evaluate the derivatives of the error function scales with the total number W of weights and biases in the network. A single evaluation of the error function (for a given input pattern) would require O(W) operations, for sufﬁciently large W. This follows from the fact that, except for a network with very sparse connections, the number of weights is typically much greater than the number of units, and so the bulk of the computational effort in forward propagation is concerned with evaluating the sums in (5.48), with the evaluation of the activation functions representing a small overhead. Each term in the sum in (5.48) requires one multiplication and one addition, leading to an overall computational cost that is O(W).

An alternative approach to backpropagation for computing the derivatives of the error function is to use ﬁnite differences. This can be done by perturbing each weight in turn, and approximating the derivatives by the expression

En(wji + ) − En(wji)

∂En ∂wji

=

+ O( ) (5.68)

where 1. In a software simulation, the accuracy of the approximation to the derivatives can be improved by making smaller, until numerical roundoff problems arise. The accuracy of the ﬁnite differences method can be improved signiﬁcantly by using symmetrical central differences of the form

En(wji + ) − En(wji − ) 2

∂En ∂wji

=

+ O( 2). (5.69)

- Exercise 5.14 In this case, the O( ) corrections cancel, as can be veriﬁed by Taylor expansion on the right-hand side of (5.69), and so the residual corrections are O( 2). The number of computational steps is, however, roughly doubled compared with (5.68).


The main problem with numerical differentiation is that the highly desirable O(W) scaling has been lost. Each forward propagation requires O(W) steps, and
