[Page 264]

Figure 5.7

Illustration of the calculation of δ j for hidden unit j by backpropagation of the δ ’s from those units k to which unit j sends connections. The blue arrow denotes the direction of information ﬂow during forward propagation, and the red arrows indicate the backward propagation of error information.

![image 113](../images/imageFile113.png)

z

δ

i

k

δ

j

w

w

ji

kj

z

j

δ

1

provided we are using the canonical link as the output-unit activation function. To evaluate the δ ’s for hidden units, we again make use of the chain rule for partial derivatives, ∂E ∂E ∂a

$$
\delta _ { j } \equiv \frac { \partial E _ { n } } { \partial a _ { j } } = \sum _ { k } \frac { \partial E _ { n } } { \partial a _ { k } } \frac { \partial a _ { k } } { \partial a _ { j } } \\ \intertext { s o r e a l l u n i t s k t o w i c h i n u t i j s d e n s c o n t i o n s . T h e r a n g e - }
$$

where the sum runs over all units k to which unit j sends connections. The arrangement of units and weights is illustrated in Figure 5.7. Note that the units labelled k could include other hidden units and/or output units. In writing down (5.55), we are making use of the fact that variations in a j give rise to variations in the error function only through variations in the variables a k . If we now substitute the deﬁnition of δ given by (5.51) into (5.55), and make use of (5.48) and (5.49), we obtain the following backpropagation formula

$$
\delta _ { j } = h ^ { \prime } ( a _ { j } ) \sum _ { k } w _ { k j } \delta _ { k } \\ \intertext { o v l u o f } \delta _ { j } = h ^ { \prime } ( a _ { j } ) \sum _ { k } w _ { k j } \delta _ { k } \\
$$

which tells us that the value of δ for a particular hidden unit can be obtained by propagating the δ ’s backwards from units higher up in the network, as illustrated in Figure 5.7. Note that the summation in (5.56) is taken over the ﬁrst index on w kj (corresponding to backward propagation of information through the network), whereas in the forward propagation equation (5.10) it is taken over the second index. Because we already know the values of the δ ’s for the output units, it follows that by recursively applying (5.56) we can evaluate the δ ’s for all of the hidden units in a feed-forward network, regardless of its topology.

The backpropagation procedure can therefore be summarized as follows.

# Error Backpropagation

- 1. Apply an input vector x n to the network and forward propagate through the network using (5.48) and (5.49) to ﬁnd the activations of all the hidden and output units.
- 2. Evaluate the δ k for all the output units using (5.54).
- 3. Backpropagate the δ ’s using (5.56) to obtain δ j for each hidden unit in the network.
- 4. Use (5.53) to evaluate the required derivatives.
