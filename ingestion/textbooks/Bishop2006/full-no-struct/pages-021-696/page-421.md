[Page 421]

![The image is a diagram consisting of three interconnected circles. Each circle is connected to the others by a line segment. The circles are labeled with different numbers, starting from the top left and moving clockwise. The numbers are: 1. A 2. B 3. C The diagram is a simple representation of a geometric figure, likely a diagram of a circle. The circles are connected by lines, which are not explicitly labeled. The lines are drawn in red, and the circles are connected by a line segment. The circles are connected by a line segment, which is not explicitly labeled. The diagram is a simple representation of a circle, likely a diagram of a circle.](../images/imageFile201.png)

x

x

x

x

x

x

1

2

1

2

1

2

f

f

c

f

f

a

b

x

x

x

3

3

3

(a)

(b)

(c)

Figure 8.42 (a) A directed graph with the factorization p ( x 1 ) p ( x 2 ) p ( x 3 | x 1 , x 2 ) . (b) A factor graph representing the same distribution as the directed graph, whose factor satisﬁes f ( x 1 , x 2 , x 3 ) = p ( x 1 ) p ( x 2 ) p ( x 3 | x 1 , x 2 ) . (c) A different factor graph representing the same distribution with factors f a ( x 1 ) = p ( x 1 ) , f b ( x 2 ) = p ( x 2 ) and f c ( x 1 , x 2 , x 3 ) = p ( x 3 | x 1 , x 2 ) .

Factor graphs are said to be bipartite because they consist of two distinct kinds of nodes, and all links go between nodes of opposite type. In general, factor graphs can therefore always be drawn as two rows of nodes (variable nodes at the top and factor nodes at the bottom) with links between the rows, as shown in the example in Figure 8.40. In some situations, however, other ways of laying out the graph may be more intuitive, for example when the factor graph is derived from a directed or undirected graph, as we shall see.

If we are given a distribution that is expressed in terms of an undirected graph, then we can readily convert it to a factor graph. To do this, we create variable nodes corresponding to the nodes in the original undirected graph, and then create additional factor nodes corresponding to the maximal cliques x s . The factors f s ( x s ) are then set equal to the clique potentials. Note that there may be several different factor graphs that correspond to the same undirected graph. These concepts are illustrated in Figure 8.41.

Similarly, to convert a directed graph to a factor graph, we simply create variable nodes in the factor graph corresponding to the nodes of the directed graph, and then create factor nodes corresponding to the conditional distributions, and then ﬁnally add the appropriate links. Again, there can be multiple factor graphs all of which correspond to the same directed graph. The conversion of a directed graph to a factor graph is illustrated in Figure 8.42.

We have already noted the importance of tree-structured graphs for performing efﬁcient inference. If we take a directed or undirected tree and convert it into a factor graph, then the result will again be a tree (in other words, the factor graph will have no loops, and there will be one and only one path connecting any two nodes). In the case of a directed polytree, conversion to an undirected graph results in loops due to the moralization step, whereas conversion to a factor graph again results in a tree, as illustrated in Figure 8.43. In fact, local cycles in a directed graph due to links connecting parents of a node can be removed on conversion to a factor graph by deﬁning the appropriate factor function, as shown in Figure 8.44.

We have seen that multiple different factor graphs can represent the same directed or undirected graph. This allows factor graphs to be more specific about the precise form of the factorization. Figure 8.45 shows an example of a fully connected undirected graph along with two different factor graphs. In (b), the joint distribution is given by a general form p ( x ) = f ( x 1 , x 2 , x 3 ) , whereas in (c), it is given by the more specific factorization p ( x ) = f a ( x 1 , x 2 ) f b ( x 1 , x 3 ) f c ( x 2 , x 3 ) . It should be emphasized that the factorization in (c) does not correspond to any conditional independence properties.
