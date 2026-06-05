[Page 432]

where M is the total number of variables, and then substitute for p(x) using its expansion in terms of a product of factors. In deriving the sum-product algorithm, we made use of the distributive law (8.53) for multiplication. Here we make use of the analogous law for the max operator

###### max(ab,ac) = amax(b,c) (8.90)

which holds if a 0 (as will always be the case for the factors in a graphical model). This allows us to exchange products with maximizations.

Consider ﬁrst the simple example of a chain of nodes described by (8.49). The evaluation of the probability maximum can be written as

max

p(x) =

x

1 Z

max

=

x1

1 Z

···max

[ψ1,2(x1,x2)···ψN−1,N(xN−1,xN)]

max

x1

xN

ψ1,2(x1,x2) ···max

ψN−1,N(xN−1,xN) .

xN

- As with the calculation of marginals, we see that exchanging the max and product operators results in a much more efﬁcient computation, and one that is easily interpreted in terms of messages passed from node xN backwards along the chain to node x1.


We can readily generalize this result to arbitrary tree-structured factor graphs by substituting the expression (8.59) for the factor graph expansion into (8.89) and again exchanging maximizations with products. The structure of this calculation is identical to that of the sum-product algorithm, and so we can simply translate those results into the present context. In particular, suppose that we designate a particular variable node as the ‘root’ of the graph. Then we start a set of messages propagating inwards from the leaves of the tree towards the root, with each node sending its message towards the root once it has received all incoming messages from its other neighbours. The ﬁnal maximization is performed over the product of all messages arriving at the root node, and gives the maximum value for p(x). This could be called the max-product algorithm and is identical to the sum-product algorithm except that summations are replaced by maximizations. Note that at this stage, messages have been sent from leaves to the root, but not in the other direction.

In practice, products of many small probabilities can lead to numerical underﬂow problems, and so it is convenient to work with the logarithm of the joint distribution. The logarithm is a monotonic function, so that if a > b then lna > lnb, and hence the max operator and the logarithm function can be interchanged, so that

lnp(x). (8.91) The distributive property is preserved because

ln max

p(x) = max

x

x

###### max(a + b,a + c) = a + max(b,c). (8.92)

Thus taking the logarithm simply has the effect of replacing the products in the max-product algorithm with sums, and so we obtain the max-sum algorithm. From
