[Page 411]

Figure 8.33 Example of a simple directed graph (a) and the corresponding moral graph (b).

x

x

x

x

![In this image, we can see a diagram with a line and a circle. There are some points marked on the line.](../images/imageFile192.png)

1

3

1

3

x

x

2

2

x

x

4

4

(a)

(b)

This is easily done by identifying

$$
\begin{array} { r l r } { \psi _ { 1 , 2 } ( x _ { 1 } , x _ { 2 } ) } & { = } & { p ( x _ { 1 } ) p ( x _ { 2 } | x _ { 1 } ) } \\ { \psi _ { 2 , 3 } ( x _ { 2 } , x _ { 3 } ) } & { = } & { p ( x _ { 3 } | x _ { 2 } ) } \\ & { \vdots } & \\ { \psi _ { N - 1 , N } ( x _ { N - 1 } , x _ { N } ) } & { = } & { p ( x _ { N } | x _ { N - 1 } ) } \\ \end{array}
$$

where we have absorbed the marginal p ( x 1 ) for the ﬁrst node into the ﬁrst potential function. Note that in this case, the partition function Z = 1 .

Let us consider how to generalize this construction, so that we can convert any distribution speciﬁed by a factorization over a directed graph into one speciﬁed by a factorization over an undirected graph. This can be achieved if the clique potentials of the undirected graph are given by the conditional distributions of the directed graph. In order for this to be valid, we must ensure that the set of variables that appears in each of the conditional distributions is a member of at least one clique of the undirected graph. For nodes on the directed graph having just one parent, this is achieved simply by replacing the directed link with an undirected link. However, for nodes in the directed graph having more than one parent, this is not sufﬁcient. These are nodes that have ‘head-to-head’ paths encountered in our discussion of conditional independence. Consider a simple directed graph over 4 nodes shown in Figure 8.33. The joint distribution for the directed graph takes the form

$$
p ( x ) = p ( x _ { 1 } ) p ( x _ { 2 } ) p ( x _ { 3 } ) p ( x _ { 4 } | x _ { 1 } , x _ { 2 } , x _ { 3 } ) .
$$

We see that the factor p ( x 4 | x 1 ,x 2 ,x 3 ) involves the four variables x 1 , x 2 , x 3 , and x 4 , and so these must all belong to a single clique if this conditional distribution is to be absorbed into a clique potential. To ensure this, we add extra links between all pairs of parents of the node x 4 . Anachronistically, this process of ‘marrying the parents’ has become known as moralization , and the resulting undirected graph, after dropping the arrows, is called the moral graph . It is important to observe that the moral graph in this example is fully connected and so exhibits no conditional independence properties, in contrast to the original directed graph.

Thus in general to convert a directed graph into an undirected graph, we ﬁrst add additional undirected links between all pairs of parents for each node in the graph and
