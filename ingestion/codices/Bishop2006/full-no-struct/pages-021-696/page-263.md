[Page 263]

where z i is the activation of a unit, or input, that sends a connection to unit j , and w ji is the weight associated with that connection. In Section 5.1, we saw that biases can be included in this sum by introducing an extra unit, or input, with activation ﬁxed at +1 . We therefore do not need to deal with biases explicitly. The sum in (5.48) is transformed by a nonlinear activation function h ( · ) to give the activation z j of unit j in the form

$$
z _ { j } = h ( a _ { j } ) .
$$

Note that one or more of the variables z i in the sum in (5.48) could be an input, and similarly, the unit j in (5.49) could be an output.

For each pattern in the training set, we shall suppose that we have supplied the corresponding input vector to the network and calculated the activations of all of the hidden and output units in the network by successive application of (5.48) and (5.49). This process is often called forward propagation because it can be regarded as a forward ﬂow of information through the network.

Now consider the evaluation of the derivative of E n with respect to a weight w ji . The outputs of the various units will depend on the particular input pattern n . However, in order to keep the notation uncluttered, we shall omit the subscript n from the network variables. First we note that E n depends on the weight w ji only via the summed input a j to unit j . We can therefore apply the chain rule for partial derivatives to give

$$
\frac { \partial E _ { n } } { \partial w _ { j i } } = \frac { \partial E _ { n } } { \partial a _ { j } } \frac { \partial a _ { j } } { \partial w _ { j i } } .
$$

We now introduce a useful notation

$$
\delta _ { j } \equiv \frac { \partial E _ { n } } { \partial a _ { j } }
$$

where the δ ’s are often referred to as errors for reasons we shall see shortly. Using (5.48), we can write

$$
\frac { \partial a _ { j } } { \partial w _ { j i } } = z _ { i } .
$$

Substituting (5.51) and (5.52) into (5.50), we then obtain

$$
\frac { \partial E _ { n } } { \partial w _ { j i } } = \delta _ { j } z _ { i } .
$$

Equation (5.53) tells us that the required derivative is obtained simply by multiplying the value of δ for the unit at the output end of the weight by the value of z for the unit at the input end of the weight (where z = 1 in the case of a bias). Note that this takes the same form as for the simple linear model considered at the start of this section. Thus, in order to evaluate the derivatives, we need only to calculate the value of δ j for each hidden and output unit in the network, and then apply (5.53).

As we have seen already, for the output units, we have

$$
\delta _ { k } = y _ { k } - t _ { k }
$$
