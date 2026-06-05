[Page 382]

Figure 8.2 Example of a directed acyclic graph describing the joint distribution over variables x 1 , . . . , x 7 . The corresponding decomposition of the joint distribution is given by (8.4).

![image 161](../images/imageFile161.png)

x

1

x

x

2

3

x

x

4

5

x

x

6

7

Exercise 8.1

Exercise 8.2

$$
p ( x _ { 1 } ) p ( x _ { 2 } ) p ( x _ { 3 } ) p ( x _ { 4 } | x _ { 1 } , x _ { 2 } , x _ { 3 } ) p ( x _ { 5 } | x _ { 1 } , x _ { 3 } ) p ( x _ { 6 } | x _ { 4 } ) p ( x _ { 7 } | x _ { 4 } , x _ { 5 } ) .
$$

The reader should take a moment to study carefully the correspondence between (8.4) and Figure 8.2.

We can now state in general terms the relationship between a given directed graph and the corresponding distribution over the variables. The joint distribution deﬁned by a graph is given by the product, over all of the nodes of the graph, of a conditional distribution for each node conditioned on the variables corresponding to the parents of that node in the graph. Thus, for a graph with K nodes, the joint distribution is given by

$$
p ( x ) & = \prod _ { k = 1 } ^ { K } p ( x _ { k } | \text {pa} _ { k } ) \\ \intertext { h e c k s t o f p a r t i v e s } \text {the set of parents of } x _ { k } , \text { and } x _ { k } & = \{ x _ { 1 } , \dots , x _ { K } \} _ { \colon \text { This key} }
$$

where pa k denotes the set of parents of x k , and x = { x 1 ,...,x K } . This key equation expresses the factorization properties of the joint distribution for a directed graphical model. Although we have considered each node to correspond to a single variable, we can equally well associate sets of variables and vector-valued variables with the nodes of a graph. It is easy to show that the representation on the righthand side of (8.5) is always correctly normalized provided the individual conditional distributions are normalized.

The directed graphs that we are considering are subject to an important restriction namely that there must be no directed cycles , in other words there are no closed paths within the graph such that we can move from node to node along links following the direction of the arrows and end up back at the starting node. Such graphs are also called directed acyclic graphs , or DAGs . This is equivalent to the statement that there exists an ordering of the nodes such that there are no links that go from any node to any lower numbered node.

# 8.1.1 Example: Polynomial regression

As an illustration of the use of directed graphs to describe probability distributions, we consider the Bayesian polynomial regression model introduced in Sec-
