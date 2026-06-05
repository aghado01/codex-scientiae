[Page 405]

- Figure 8.28 For an undirected graph, the Markov blanket of a node xi consists of the set of neighbouring nodes. It has the property that the conditional distribution of xi, conditioned on all the remaining variables in the graph, is dependent only on the variables in the Markov blanket.

If we consider two nodes xi and xj that are not connected by a link, then these variables must be conditionally independent given all other nodes in the graph. This follows from the fact that there is no direct path between the two nodes, and all other paths pass through nodes that are observed, and hence those paths are blocked. This conditional independence property can be expressed as

p(xi,xj|x\{i,j}) = p(xi|x\{i,j})p(xj|x\{i,j}) (8.38)

where x\{i,j} denotes the set x of all variables with xi and xj removed. The factorization of the joint distribution must therefore be such that xi and xj do not appear in the same factor in order for the conditional independence property to hold for all possible distributions belonging to the graph.

This leads us to consider a graphical concept called a clique, which is deﬁned as a subset of the nodes in a graph such that there exists a link between all pairs of nodes in the subset. In other words, the set of nodes in a clique is fully connected. Furthermore, a maximal clique is a clique such that it is not possible to include any other nodes from the graph in the set without it ceasing to be a clique. These concepts are illustrated by the undirected graph over four variables shown in Figure 8.29. This graph has ﬁve cliques of two nodes given by {x1,x2}, {x2,x3}, {x3,x4}, {x4,x2}, and {x1,x3}, as well as two maximal cliques given by {x1,x2,x3} and {x2,x3,x4}. The set {x1,x2,x3,x4} is not a clique because of the missing link from x1 to x4.

We can therefore deﬁne the factors in the decomposition of the joint distribution to be functions of the variables in the cliques. In fact, we can consider functions of the maximal cliques, without loss of generality, because other cliques must be subsets of maximal cliques. Thus, if {x1,x2,x3} is a maximal clique and we deﬁne an arbitrary function over this clique, then including another factor deﬁned over a subset of these variables would be redundant.

Let us denote a clique by C and the set of variables in that clique by xC. Then

- Figure 8.29 A four-node undirected graph showing a clique (outlined in green) and a maximal clique (outlined in blue). x1


x2

x3

x4
