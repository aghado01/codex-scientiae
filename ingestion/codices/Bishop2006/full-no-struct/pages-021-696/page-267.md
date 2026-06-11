[Page 267]

Figure 5.8 Illustration of a modular pattern recognition system in which the Jacobian matrix can be used to backpropagate error signals from the outputs through to earlier modules in the system.

![In this image, we can see a diagram with two boxes and the text in the image.](../images/imageFile114.png)

u

v

y

w

z

x

However, numerical differentiation plays an important role in practice, because a comparison of the derivatives calculated by backpropagation with those obtained using central differences provides a powerful check on the correctness of any software implementation of the backpropagation algorithm. When training networks in practice, derivatives should be evaluated using backpropagation, because this gives the greatest accuracy and numerical efﬁciency. However, the results should be compared with numerical differentiation using (5.69) for some test cases in order to check the correctness of the implementation.

# 5.3.4 The Jacobian matrix

We have seen how the derivatives of an error function with respect to the weights can be obtained by the propagation of errors backwards through the network. The technique of backpropagation can also be applied to the calculation of other derivatives. Here we consider the evaluation of the Jacobian matrix, whose elements are given by the derivatives of the network outputs with respect to the inputs

$$
J _ { k i } \equiv \frac { \partial y _ { k } } { \partial x _ { i } }
$$

where each such derivative is evaluated with all other inputs held ﬁxed. Jacobian matrices play a useful role in systems built from a number of distinct modules, as illustrated in Figure 5.8. Each module can comprise a ﬁxed or adaptive function, which can be linear or nonlinear, so long as it is differentiable. Suppose we wish to minimize an error function E with respect to the parameter w in Figure 5.8. The derivative of the error function is given by

$$
\frac { \partial E } { \partial w } = \sum _ { k , j } \frac { \partial E } { \partial y _ { k } } \frac { \partial y _ { k } } { \partial z _ { j } } \frac { \partial z _ { j } } { \partial w } \\
$$

in which the Jacobian matrix for the red module in Figure 5.8 appears in the middle term.

Because the Jacobian matrix provides a measure of the local sensitivity of the outputs to changes in each of the input variables, it also allows any known errors ∆ x i associated with the inputs to be propagated through the trained network in order to estimate their contribution ∆ y k to the errors at the outputs, through the relation
