[Page 402]

p(x) DF

Figure 8.25 We can view a graphical model (in this case a directed graph) as a ﬁlter in which a probability distribution p(x) is allowed through the ﬁlter if, and only if, it satisﬁes the directed factorization property (8.5). The set of all possible probability distributions p(x) that pass through the ﬁlter is denoted DF. We can alternatively use the graph to ﬁlter distributions according to whether they respect all of the conditional independencies implied by the d-separation properties of the graph. The d-separation theorem says that it is the same set of distributions DF that will be allowed through this second kind of ﬁlter.

tions p(x). At the other extreme, we have the fully disconnected graph, i.e., one having no links at all. This corresponds to joint distributions which factorize into the product of the marginal distributions over the variables comprising the nodes of the graph.

Note that for any given graph, the set of distributions DF will include any distributions that have additional independence properties beyond those described by the graph. For instance, a fully factorized distribution will always be passed through the ﬁlter implied by any graph over the corresponding set of variables.

We end our discussion of conditional independence properties by exploring the concept of a Markov blanket or Markov boundary. Consider a joint distribution p(x1,...,xD) represented by a directed graph having D nodes, and consider the conditional distribution of a particular node with variables xi conditioned on all of the remaining variables xj=� i. Using the factorization property (8.5), we can express this conditional distribution in the form

p(x1,...,xD) � p(x1,...,xD)dxi

p(xi|x{j=� i}) =

�

p(xk|pak)

k

=

� �

p(xk|pak)dxi

k

in which the integral is replaced by a summation in the case of discrete variables. We now observe that any factor p(xk|pak) that does not have any functional dependence on xi can be taken outside the integral over xi, and will therefore cancel between numerator and denominator. The only factors that remain will be the conditional distribution p(xi|pai) for node xi itself, together with the conditional distributions for any nodes xk such that node xi is in the conditioning set of p(xk|pak), in other words for which xi is a parent of xk. The conditional p(xi|pai) will depend on the parents of node xi, whereas the conditionals p(xk|pak) will depend on the children
