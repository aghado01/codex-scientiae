[Page 402]

Figure 8.25 We can view a graphical model (in this case a directed graph) as a ﬁlter in which a probability distribution $p(\mathbf{x})$ is allowed through the ﬁlter if, and only if, it satisﬁes the directed factorization property (8.5). The set of all possible probability distributions $p(\mathbf{x})$ that pass through the ﬁlter is denoted $\mathcal{DF}$. We can alternatively use the graph to ﬁlter distributions according to whether they respect all of the conditional independencies implied by the d-separation properties of the graph. The d-separation theorem says that it is the same set of distributions $\mathcal{DF}$ that will be allowed through this second kind of ﬁlter.

![image 184](../images/imageFile184.png)

tions $p(\mathbf{x})$. At the other extreme, we have the fully disconnected graph, i.e., one having no links at all. This corresponds to joint distributions which factorize into the product of the marginal distributions over the variables comprising the nodes of the graph.

Note that for any given graph, the set of distributions $\mathcal{DF}$ will include any distributions that have additional independence properties beyond those described by the graph. For instance, a fully factorized distribution will always be passed through the ﬁlter implied by any graph over the corresponding set of variables.

We end our discussion of conditional independence properties by exploring the concept of a Markov blanket or Markov boundary. Consider a joint distribution $p(x_1, \ldots, x_D)$ represented by a directed graph having $D$ nodes, and consider the conditional distribution of a particular node with variables $x_i$ conditioned on all of the remaining variables $x_{j \neq i}$. Using the factorization property (8.5), we can express this conditional distribution in the form

$$
\begin{align}
p(x_i|x_{\{j \neq i\}}) &= \frac{p(x_1, \ldots, x_D)}{\int p(x_1, \ldots, x_D) \text{d}x_i} \\
&= \frac{\prod_k p(x_k|\text{pa}_k)}{\int \prod_k p(x_k|\text{pa}_k) \text{d}x_i}
\end{align}
$$

in which the integral is replaced by a summation in the case of discrete variables. We now observe that any factor $p(x_k|\text{pa}_k)$ that does not have any functional dependence on $x_i$ can be taken outside the integral over $x_i$, and will therefore cancel between numerator and denominator. The only factors that remain will be the conditional distribution $p(x_i|\text{pa}_i)$ for node $x_i$ itself, together with the conditional distributions for any nodes $x_k$ such that node $x_i$ is in the conditioning set of $p(x_k|\text{pa}_k)$, in other words for which $x_i$ is a parent of $x_k$. The conditional $p(x_i|\text{pa}_i)$ will depend on the parents of node $x_i$, whereas the conditionals $p(x_k|\text{pa}_k)$ will depend on the children
