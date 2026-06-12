[Page 403]

- Figure 8.26 The Markov blanket of a node xi comprises the set of parents, children and co-parents of the node. It has the property that the conditional distribution of


xi, conditioned on all the remaining variables in the graph, is dependent only on the variables in the Markov blanket. xi

of xi as well as on the co-parents, in other words variables corresponding to parents of node xk other than node xi. The set of nodes comprising the parents, the children and the co-parents is called the Markov blanket and is illustrated in Figure 8.26. We can think of the Markov blanket of a node xi as being the minimal set of nodes that isolates xi from the rest of the graph. Note that it is not sufﬁcient to include only the parents and children of node xi because the phenomenon of explaining away means that observations of the child nodes will not block paths to the co-parents. We must therefore observe the co-parent nodes also.

###### 8.3. Markov Random Fields

We have seen that directed graphical models specify a factorization of the joint distribution over a set of variables into a product of local conditional distributions. They also deﬁne a set of conditional independence properties that must be satisﬁed by any distribution that factorizes according to the graph. We turn now to the second major class of graphical models that are described by undirected graphs and that again specify both a factorization and a set of conditional independence relations.

A Markov random ﬁeld, also known as a Markov network or an undirected graphical model (Kindermann and Snell, 1980), has a set of nodes each of which corresponds to a variable or group of variables, as well as a set of links each of which connects a pair of nodes. The links are undirected, that is they do not carry arrows. In the case of undirected graphs, it is convenient to begin with a discussion of conditional independence properties.

###### 8.3.1 Conditional independence properties

Section 8.2 In the case of directed graphs, we saw that it was possible to test whether a particular conditional independence property holds by applying a graphical test called d-separation. This involved testing whether or not the paths connecting two sets of nodes were ‘blocked’. The deﬁnition of blocked, however, was somewhat subtle due to the presence of paths having head-to-head nodes. We might ask whether it is possible to deﬁne an alternative graphical semantics for probability distributions such that conditional independence is determined by simple graph separation. This is indeed the case and corresponds to undirected graphical models. By removing the
