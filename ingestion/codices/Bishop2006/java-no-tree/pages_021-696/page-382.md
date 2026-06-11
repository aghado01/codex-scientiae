[Page 382]

Figure 8.2 Example of a directed acyclic graph describing the joint distribution over variables x1, . . . , x7. The corresponding decomposition of the joint distribution is given by (8.4).

x1 x2 x3

x4 x5

x6 x7

is therefore given by

p(x1)p(x2)p(x3)p(x4|x1,x2,x3)p(x5|x1,x3)p(x6|x4)p(x7|x4,x5). (8.4)

The reader should take a moment to study carefully the correspondence between (8.4) and Figure 8.2.

We can now state in general terms the relationship between a given directed graph and the corresponding distribution over the variables. The joint distribution deﬁned by a graph is given by the product, over all of the nodes of the graph, of a conditional distribution for each node conditioned on the variables corresponding to the parents of that node in the graph. Thus, for a graph with K nodes, the joint distribution is given by

K

p(x) =

p(xk|pak) (8.5)

k=1

where pak denotes the set of parents of xk, and x = {x1,...,xK}. This key equation expresses the factorization properties of the joint distribution for a directed graphical model. Although we have considered each node to correspond to a single variable, we can equally well associate sets of variables and vector-valued variables with the nodes of a graph. It is easy to show that the representation on the righthand side of (8.5) is always correctly normalized provided the individual conditional

- Exercise 8.1 distributions are normalized. The directed graphs that we are considering are subject to an important restric-

tion namely that there must be no directed cycles, in other words there are no closed paths within the graph such that we can move from node to node along links following the direction of the arrows and end up back at the starting node. Such graphs are

- Exercise 8.2 also called directed acyclic graphs, or DAGs. This is equivalent to the statement that there exists an ordering of the nodes such that there are no links that go from any node to any lower numbered node.


###### 8.1.1 Example: Polynomial regression

As an illustration of the use of directed graphs to describe probability distributions, we consider the Bayesian polynomial regression model introduced in Sec-
