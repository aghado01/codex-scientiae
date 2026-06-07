[Page 423]

![image 204](../images/imageFile204.png)

Figure 8.45 (a) A fully connected undirected graph. (b) and (c) Two factor graphs each of which corresponds to the undirected graph in (a).

There is an algorithm for exact inference on directed graphs without loops known as belief propagation (Pearl, 1988; Lauritzen and Spiegelhalter, 1988), and is equivalent to a special case of the sum-product algorithm. Here we shall consider only the sum-product algorithm because it is simpler to derive and to apply, as well as being more general.

We shall assume that the original graph is an undirected tree or a directed tree or polytree, so that the corresponding factor graph has a tree structure. We ﬁrst convert the original graph into a factor graph so that we can deal with both directed and undirected models using the same framework. Our goal is to exploit the structure of the graph to achieve two things: (i) to obtain an efﬁcient, exact inference algorithm for ﬁnding marginals; (ii) in situations where several marginals are required to allow computations to be shared efﬁciently.

We begin by considering the problem of ﬁnding the marginal $p(x)$ for particular variable node $x$. For the moment, we shall suppose that all of the variables are hidden. Later we shall see how to modify the algorithm to incorporate evidence corresponding to observed variables. By deﬁnition, the marginal is obtained by summing the joint distribution over all variables except $x$ so that

$$
p(x) = \sum_{\mathbf{x} \setminus x} p(\mathbf{x}) \tag{8.61}
$$

where $\mathbf{x} \setminus x$ denotes the set of variables in $\mathbf{x}$ with variable $x$ omitted. The idea is to substitute for $p(\mathbf{x})$ using the factor graph expression (8.59) and then interchange summations and products in order to obtain an efﬁcient algorithm. Consider the fragment of graph shown in Figure 8.46 in which we see that the tree structure of the graph allows us to partition the factors in the joint distribution into groups, with one group associated with each of the factor nodes that is a neighbour of the variable node $x$. We see that the joint distribution can be written as a product of the form

$$
p(\mathbf{x}) = \prod_{s \in \text{ne}(x)} F_s(x, X_s) \tag{8.62}
$$

where $\text{ne}(x)$ denotes the set of factor nodes that are neighbours of $x$, and $X_s$ denotes the set of all variables in the subtree connected to the variable node $x$ via the factor node
