[Page 265]

For batch methods, the derivative of the total error E can then be obtained by repeating the above steps for each pattern in the training set and then summing over all patterns:

�

∂E ∂wji

∂En ∂wji

=

. (5.57)

n

In the above derivation we have implicitly assumed that each hidden or output unit in the network has the same activation function h(·). The derivation is easily generalized, however, to allow different units to have individual activation functions, simply by keeping track of which form of h(·) goes with which unit.

5.3.2 A simple example

The above derivation of the backpropagation procedure allowed for general forms for the error function, the activation functions, and the network topology. In order to illustrate the application of this algorithm, we shall consider a particular example. This is chosen both for its simplicity and for its practical importance, because many applications of neural networks reported in the literature make use of this type of network. Speciﬁcally, we shall consider a two-layer network of the form illustrated in Figure 5.1, together with a sum-of-squares error, in which the output units have linear activation functions, so that yk = ak, while the hidden units have logistic sigmoid activation functions given by

h(a) ≡ tanh(a) (5.58) where

ea − e−a ea + e−a. (5.59)

tanh(a) =

A useful feature of this function is that its derivative can be expressed in a particularly simple form:

h�(a) = 1 − h(a)2. (5.60) We also consider a standard sum-of-squares error function, so that for pattern n the error is given by

�K

1 2

En =

(yk − tk)2 (5.61)

k=1

where yk is the activation of output unit k, and tk is the corresponding target, for a particular input pattern xn.

For each pattern in the training set in turn, we ﬁrst perform a forward propagation using

�D

wji(1)xi (5.62) zj = tanh(aj) (5.63)

aj =

i=0

�M

wkj(2)zj. (5.64)

yk =

j=0
