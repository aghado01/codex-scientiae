[Page 411]

Figure 8.33 Example of a simple directed graph (a) and the corresponding moral graph (b).

x1 x3

x2

x1 x3

x2

x4

(a)

x4

(b)

This is easily done by identifying

ψ1,2(x1,x2) = p(x1)p(x2|x1) ψ2,3(x2,x3) = p(x3|x2)

...

ψN−1,N(xN−1,xN) = p(xN|xN−1)

where we have absorbed the marginal p(x1) for the ﬁrst node into the ﬁrst potential function. Note that in this case, the partition function Z = 1.

Let us consider how to generalize this construction, so that we can convert any distribution speciﬁed by a factorization over a directed graph into one speciﬁed by a factorization over an undirected graph. This can be achieved if the clique potentials of the undirected graph are given by the conditional distributions of the directed graph. In order for this to be valid, we must ensure that the set of variables that appears in each of the conditional distributions is a member of at least one clique of the undirected graph. For nodes on the directed graph having just one parent, this is achieved simply by replacing the directed link with an undirected link. However, for nodes in the directed graph having more than one parent, this is not sufﬁcient. These are nodes that have ‘head-to-head’ paths encountered in our discussion of conditional independence. Consider a simple directed graph over 4 nodes shown in Figure 8.33. The joint distribution for the directed graph takes the form

p(x) = p(x1)p(x2)p(x3)p(x4|x1,x2,x3). (8.46)

We see that the factor p(x4|x1,x2,x3) involves the four variables x1, x2, x3, and x4, and so these must all belong to a single clique if this conditional distribution is to be absorbed into a clique potential. To ensure this, we add extra links between all pairs of parents of the node x4. Anachronistically, this process of ‘marrying the parents’ has become known as moralization, and the resulting undirected graph, after dropping the arrows, is called the moral graph. It is important to observe that the moral graph in this example is fully connected and so exhibits no conditional independence properties, in contrast to the original directed graph.

Thus in general to convert a directed graph into an undirected graph, we ﬁrst add additional undirected links between all pairs of parents for each node in the graph and
