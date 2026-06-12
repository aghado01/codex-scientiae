[Page 419]

Figure 8.39 Examples of treestructured graphs, showing (a) an undirected tree, (b) a directed tree, and (c) a directed polytree.

(a) (b) (c)

that can be interpreted in terms of messages passed along the chain. More generally, inference can be performed efﬁciently using local message passing on a broader class of graphs called trees. In particular, we shall shortly generalize the message passing formalism derived above for chains to give the sum-product algorithm, which provides an efﬁcient framework for exact inference in tree-structured graphs.

In the case of an undirected graph, a tree is deﬁned as a graph in which there is one, and only one, path between any pair of nodes. Such graphs therefore do not have loops. In the case of directed graphs, a tree is deﬁned such that there is a single node, called the root, which has no parents, and all other nodes have one parent. If we convert a directed tree into an undirected graph, we see that the moralization step will not add any links as all nodes have at most one parent, and as a consequence the corresponding moralized graph will be an undirected tree. Examples of undirected and directed trees are shown in Figure 8.39(a) and 8.39(b). Note that a distribution represented as a directed tree can easily be converted into one represented by an

Exercise 8.18 undirected tree, and vice versa.

If there are nodes in a directed graph that have more than one parent, but there is still only one path (ignoring the direction of the arrows) between any two nodes, then the graph is a called a polytree, as illustrated in Figure 8.39(c). Such a graph will have more than one node with the property of having no parents, and furthermore, the corresponding moralized undirected graph will have loops.

8.4.3 Factor graphs

The sum-product algorithm that we derive in the next section is applicable to undirected and directed trees and to polytrees. It can be cast in a particularly simple and general form if we ﬁrst introduce a new graphical construction called a factor graph (Frey, 1998; Kschischnang et al., 2001).

Both directed and undirected graphs allow a global function of several variables to be expressed as a product of factors over subsets of those variables. Factor graphs make this decomposition explicit by introducing additional nodes for the factors themselves in addition to the nodes representing the variables. They also allow us to be more explicit about the details of the factorization, as we shall see.

Let us write the joint distribution over a set of variables in the form of a product of factors

�

fs(xs) (8.59)

p(x) =

s

where xs denotes a subset of the variables. For convenience, we shall denote the
