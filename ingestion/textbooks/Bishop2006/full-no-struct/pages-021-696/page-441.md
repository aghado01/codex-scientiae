[Page 441]

8.16 ( ) Consider the inference problem of evaluating p ( x n | x N ) for the graph shown in Figure 8.38, for all nodes n ∈ { 1 ,...,N − 1 } . Show that the message passing algorithm discussed in Section 8.4.1 can be used to solve this efﬁciently, and discuss which messages are modiﬁed and in what way.

8.17 ( ) Consider a graph of the form shown in Figure 8.38 having N = 5 nodes, in which nodes x 3 and x 5 are observed. Use d-separation to show that x 2 ⊥ x 5 | x 3 . Show that if the message passing algorithm of Section 8.4.1 is applied to the evaluation of p ( x 2 | x 3 ,x 5 ) , the result will be independent of the value of x 5 .

8.18 ( ) www Show that a distribution represented by a directed tree can trivially be written as an equivalent distribution over the corresponding undirected tree. Also show that a distribution expressed as an undirected tree can, by suitable normalization of the clique potentials, be written as a directed tree. Calculate the number of distinct directed trees that can be constructed from a given undirected tree.

8.19 ( ) Apply the sum-product algorithm derived in Section 8.4.4 to the chain-ofnodes model discussed in Section 8.4.1 and show that the results (8.54), (8.55), and (8.57) are recovered as a special case.

8.20 ( ) www Consider the message passing protocol for the sum-product algorithm on a tree-structured factor graph in which messages are ﬁrst propagated from the leaves to an arbitrarily chosen root node and then from the root node out to the leaves. Use proof by induction to show that the messages can be passed in such an order that at every step, each node that must send a message has received all of the incoming messages necessary to construct its outgoing messages.

8.21 ( ) www Show that the marginal distributions p ( x s ) over the sets of variables x s associated with each of the factors f x ( x s ) in a factor graph can be found by ﬁrst running the sum-product message passing algorithm and then evaluating the required marginals using (8.72).

8.22 ( ) Consider a tree-structured factor graph, in which a given subset of the variable nodes form a connected subgraph (i.e., any variable node of the subset is connected to at least one of the other variable nodes via a single factor node). Show how the sum-product algorithm can be used to compute the marginal distribution over that subset.

8.23 ( ) www In Section 8.4.4, we showed that the marginal distribution p ( x i ) for a variable node x i in a factor graph is given by the product of the messages arriving at this node from neighbouring factor nodes in the form (8.63). Show that the marginal p ( x i ) can also be written as the product of the incoming message along any one of the links with the outgoing message along the same link.

8.24 ( ) Show that the marginal distribution for the variables x s in a factor f s ( x s ) in a tree-structured factor graph, after running the sum-product message passing algorithm, can be written as the product of the message arriving at the factor node along all its links, times the local factor f ( x s ) , in the form (8.72).
