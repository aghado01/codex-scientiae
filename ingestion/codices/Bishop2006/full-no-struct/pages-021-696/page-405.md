[Page 405]

Figure 8.28

For an undirected graph, the Markov blanket of a node x i consists of the set of neighbouring nodes. It has the property that the conditional distribution of x i , conditioned on all the remaining variables in the graph, is dependent only on the variables in the Markov blanket.

![image 187](../images/imageFile187.png)

If we consider two nodes x i and x j that are not connected by a link, then these variables must be conditionally independent given all other nodes in the graph. This follows from the fact that there is no direct path between the two nodes, and all other paths pass through nodes that are observed, and hence those paths are blocked. This conditional independence property can be expressed as

$$
p ( x _ { i } , x _ { j } | x _ { \{ i , j \} } ) = p ( x _ { i } | x _ { \{ i , j \} } ) p ( x _ { j } | x _ { \{ i , j \} } )
$$

where x \{ i,j } denotes the set x of all variables with x i and x j removed. The factorization of the joint distribution must therefore be such that x i and x j do not appear in the same factor in order for the conditional independence property to hold for all possible distributions belonging to the graph.

This leads us to consider a graphical concept called a clique , which is deﬁned as a subset of the nodes in a graph such that there exists a link between all pairs of nodes in the subset. In other words, the set of nodes in a clique is fully connected. Furthermore, a maximal clique is a clique such that it is not possible to include any other nodes from the graph in the set without it ceasing to be a clique. These concepts are illustrated by the undirected graph over four variables shown in Figure 8.29. This graph has ﬁve cliques of two nodes given by { x 1 ,x 2 } , { x 2 ,x 3 } , { x 3 ,x 4 } , { x 4 ,x 2 } , and { x 1 ,x 3 } , as well as two maximal cliques given by { x 1 ,x 2 ,x 3 } and { x 2 ,x 3 ,x 4 } . The set { x 1 ,x 2 ,x 3 ,x 4 } is not a clique because of the missing link from x 1 to x 4 . We can therefore deﬁne the factors in the decomposition of the joint distribution

to be functions of the variables in the cliques. In fact, we can consider functions of the maximal cliques, without loss of generality, because other cliques must be subsets of maximal cliques. Thus, if { x 1 ,x 2 ,x 3 } is a maximal clique and we deﬁne an arbitrary function over this clique, then including another factor deﬁned over a subset of these variables would be redundant.

Let us denote a clique by C and the set of variables in that clique by x C . Then the joint distribution is written as a product of potential functions ψ C ( x C ) over the maximal cliques of the graph

Figure 8.29 A four-node undirected graph showing a clique (outlined in green) and a maximal clique (outlined in blue).

![image 188](../images/imageFile188.png)

x

1

x

2

x

3

x

4
