[Page 418]

Exercise 8.15

Chapter 9

Now suppose we wish to evaluate the marginals p ( x n ) for every node n ∈ { 1 ,...,N } in the chain. Simply applying the above procedure separately for each node will have computational cost that is O ( N 2 M 2 ) . However, such an approach would be very wasteful of computation. For instance, to ﬁnd p ( x 1 ) we need to propagate a message µ β ( · ) from node x N back to node x 2 . Similarly, to evaluate p ( x 2 ) we need to propagate a messages µ β ( · ) from node x N back to node x 3 . This will involve much duplicated computation because most of the messages will be identical in the two cases.

Suppose instead we ﬁrst launch a message µ β ( x N − 1 ) starting from node x N and propagate corresponding messages all the way back to node x 1 , and suppose we similarly launch a message µ α ( x 2 ) starting from node x 1 and propagate the corresponding messages all the way forward to node x N . Provided we store all of the intermediate messages along the way, then any node can evaluate its marginal simply by applying (8.54). The computational cost is only twice that for ﬁnding the marginal of a single node, rather than N times as much. Observe that a message has passed once in each direction across each link in the graph. Note also that the normalization constant Z need be evaluated only once, using any convenient node.

If some of the nodes in the graph are observed, then the corresponding variables are simply clamped to their observed values and there is no summation. To see this, note that the effect of clamping a variable x n to an observed value x n can be expressed by multiplying the joint distribution by (one or more copies of) an additional function I ( x n , x n ) , which takes the value 1 when x n = x n and the value 0 otherwise. One such function can then be absorbed into each of the potentials that contain x n . Summations over x n then contain only one term in which x n = x n . Now suppose we wish to calculate the joint distribution p ( x n 1 ,x n ) for two

− neighbouring nodes on the chain. This is similar to the evaluation of the marginal for a single node, except that there are now two variables that are not summed out. A few moments thought will show that the required joint distribution can be written in the form

$$
p ( x _ { n - 1 } , x _ { n } ) = \frac { 1 } { Z } \mu _ { \alpha } ( x _ { n - 1 } ) \psi _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) \mu _ { \beta } ( x _ { n } ) .
$$

Thus we can obtain the joint distributions over all of the sets of variables in each of the potentials directly once we have completed the message passing required to obtain the marginals.

This is a useful result because in practice we may wish to use parametric forms for the clique potentials, or equivalently for the conditional distributions if we started from a directed graph. In order to learn the parameters of these potentials in situations where not all of the variables are observed, we can employ the EM algorithm , and it turns out that the local joint distributions of the cliques, conditioned on any observed data, is precisely what is needed in the E step. We shall consider some examples of this in detail in Chapter 13.

# 8.4.2 Trees

We have seen that exact inference on a graph comprising a chain of nodes can be performed efficiently in time that is linear in the number of nodes, using an algorithm that can be interpreted in terms of messages passed along the chain. More generally, inference can be performed efficiently using local message passing on a broader class of graphs called trees . In particular, we shall shortly generalize the message passing formalism derived above for chains to give the sum-product algorithm, which provides an efficient framework for exact inference in tree-structured graphs.
