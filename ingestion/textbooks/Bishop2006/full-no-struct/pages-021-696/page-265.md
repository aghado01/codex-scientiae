[Page 265]

For batch methods, the derivative of the total error E can then be obtained by repeating the above steps for each pattern in the training set and then summing over all patterns:

$$
\frac { \partial E } { \partial w _ { j i } } = \sum _ { n } \frac { \partial E _ { n } } { \partial w _ { j i } } . \\ \text {we have implicitly assumed that each hidden or output unit in}
$$

In the above derivation we have implicitly assumed that each hidden or output unit in the network has the same activation function h ( · ) . The derivation is easily generalized, however, to allow different units to have individual activation functions, simply by keeping track of which form of h ( · ) goes with which unit.

# 5.3.2 A simple example

The above derivation of the backpropagation procedure allowed for general forms for the error function, the activation functions, and the network topology. In order to illustrate the application of this algorithm, we shall consider a particular example. This is chosen both for its simplicity and for its practical importance, because many applications of neural networks reported in the literature make use of this type of network. Speciﬁcally, we shall consider a two-layer network of the form illustrated in Figure 5.1, together with a sum-of-squares error, in which the output units have linear activation functions, so that y k = a k , while the hidden units have logistic sigmoid activation functions given by

$$
h ( a ) \equiv \tanh ( a )
$$

where

$$
\tanh ( a ) = \frac { e ^ { a } - e ^ { - a } } { e ^ { a } + e ^ { - a } } . \\ \intertext { f o r $ i $ t h e f t $ i $ o $ d i v e t i v e $ a $ o w $ h e $ a $ m a t h e e d }
$$

A useful feature of this function is that its derivative can be expressed in a particularly simple form: 2

$$
h ^ { \prime } ( a ) = 1 - h ( a ) ^ { 2 } . \\ \text {and} \, \sum \text {of} \, \underset { \ } s u a r e s \, \text { error function } \, \text { so that for pattern } \, n \, \text { the}
$$

We also consider a standard sum-of-squares error function, so that for pattern n the error is given by

$$
E _ { n } = \frac { 1 } { 2 } \sum _ { k = 1 } ^ { K } ( y _ { k } - t _ { k } ) ^ { 2 } \\ \text {rotation of output unit} \, k , \, \text {and} \, t _ { k } \, \text {is the corresponding target, for a}
$$

where y k is the activation of output unit k , and t k is the corresponding target, for a particular input pattern x n . For each pattern in the training set in turn, we ﬁrst perform a forward propagation

For each pattern in the training set in turn, we first perform a forward propagation using

$$
a _ { j } \ & = \ \sum _ { i = 0 } ^ { D } w _ { j i } ^ { ( 1 ) } x _ { i } & & ( 5 . 6 2 ) \\ z _ { j } \ & = \ \tanh ( a _ { j } ) & & ( 5 . 6 3 )
$$

$$
z _ { j } \ = \ \tanh ( a _ { j } )
$$

$$
y _ { k } \ = \ \sum _ { j = 0 } ^ { M } w _ { k j } ^ { ( 2 ) } z _ { j } .
$$
