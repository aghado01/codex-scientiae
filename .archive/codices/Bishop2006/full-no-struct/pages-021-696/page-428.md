[Page 428]

Figure 8.50

The sum-product algorithm can be viewed purely in terms of messages sent out by factor nodes to other factor nodes. In this example, the outgoing message shown by the blue arrow is obtained by taking the product of all the incoming messages shown by green arrows, multiplying by the factor f s , and marginalizing over the variables x 1 and x 2 .

![The image depicts a diagram of a circuit with a series of interconnected components. The components are connected by lines and arrows, indicating the flow of current. The diagram is labeled with the following components: 1. **Circuit Components**: - **Power Source**: A red square with a small arrow pointing to the right. - **Power Input**: A red square with a small arrow pointing to the left. - **Power Output**: A red square with a small arrow pointing to the right. - **Power Line**: A red square with a small arrow pointing to the left. - **Power Line Line**: A red square with a small arrow pointing to the left. - **Power Line Line**: A red square with a small arrow pointing to the left. - **Power Line Line Line**: A red square with a small arrow pointing to the left. - **Power Line Line Line Line**: A red square with a small arrow pointing to the left. -](../images/imageFile209.png)

x

1

x

3

f

x

s

2

# Exercise 8.21

and indeed the notion of one node having a special status was introduced only as a convenient way to explain the message passing protocol.

Next suppose we wish to ﬁnd the marginal distributions p ( x s ) associated with the sets of variables belonging to each of the factors. By a similar argument to that used above, it is easy to see that the marginal associated with a factor is given by the product of messages arriving at the factor node and the local factor at that node

$$
p ( x _ { s } ) = f _ { s } ( x _ { s } ) \prod _ { i \in \real { n } ( f _ { s } ) } \mu _ { x _ { i } \to f _ { s } } ( x _ { i } ) \\ \intertext { s o n l e g w i t h w i t h s e r g r a n l e o w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h s e r g r a n l e w i t h
$$

in complete analogy with the marginals at the variable nodes. If the factors are parameterized functions and we wish to learn the values of the parameters using the EM algorithm, then these marginals are precisely the quantities we will need to calculate in the E step, as we shall see in detail when we discuss the hidden Markov model in Chapter 13.

The message sent by a variable node to a factor node, as we have seen, is simply the product of the incoming messages on other links. We can if we wish view the sum-product algorithm in a slightly different form by eliminating messages from variable nodes to factor nodes and simply considering messages that are sent out by factor nodes. This is most easily seen by considering the example in Figure 8.50.

So far, we have rather neglected the issue of normalization. If the factor graph was derived from a directed graph, then the joint distribution is already correctly normalized, and so the marginals obtained by the sum-product algorithm will similarly be normalized correctly. However, if we started from an undirected graph, then in general there will be an unknown normalization coefﬁcient 1 /Z . As with the simple chain example of Figure 8.38, this is easily handled by working with an unnormalized version p ( x ) of the joint distribution, where p ( x ) = p ( x ) /Z . We ﬁrst run the sum-product algorithm to ﬁnd the corresponding unnormalized marginals p ( x i ) . The coefﬁcient 1 /Z is then easily obtained by normalizing any one of these marginals, and this is computationally efﬁcient because the normalization is done over a single variable rather than over the entire set of variables as would be required to normalize p ( x ) directly.

At this point, it may be helpful to consider a simple example to illustrate the operation of the sum-product algorithm. Figure 8.51 shows a simple 4-node factor
