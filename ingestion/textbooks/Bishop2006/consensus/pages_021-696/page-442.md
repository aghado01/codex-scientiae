[Page 442]

8.25 ($\star$) In (8.86), we veriﬁed that the sum-product algorithm run on the graph in Figure 8.51 with node $x_3$ designated as the root node gives the correct marginal for $x_2$. Show that the correct marginals are obtained also for $x_1$ and $x_3$. Similarly, show that the use of the result (8.72) after running the sum-product algorithm on this graph gives the correct joint distribution for $x_1, x_2$.

8.26 ($\star$) Consider a tree-structured factor graph over discrete variables, and suppose we wish to evaluate the joint distribution $p(x_a, x_b)$ associated with two variables $x_a$ and $x_b$ that do not belong to a common factor. Deﬁne a procedure for using the sum-product algorithm to evaluate this joint distribution in which one of the variables is successively clamped to each of its allowed values.

8.27 ($\star$) Consider two discrete variables $x$ and $y$ each having three possible states, for example $x,y \in \{0,1,2\}$. Construct a joint distribution $p(x,y)$ over these variables having the property that the value $x$ that maximizes the marginal $p(x)$, along with the value $y$ that maximizes the marginal $p(y)$, together have probability zero under the joint distribution, so that $p(x, y) = 0$.

8.28 ($\star$) www The concept of a pending message in the sum-product algorithm for a factor graph was deﬁned in Section 8.4.7. Show that if the graph has one or more cycles, there will always be at least one pending message irrespective of how long the algorithm runs.

8.29 ($\star$) www Show that if the sum-product algorithm is run on a factor graph with a tree structure (no loops), then after a ﬁnite number of messages have been sent, there will be no pending messages.
