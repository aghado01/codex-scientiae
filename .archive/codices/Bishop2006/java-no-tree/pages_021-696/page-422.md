[Page 422]

(a) (b)

| | |
|---|---|
| | |


| | |
|---|---|
| | |


| | |
|---|---|
| | |


| | |
|---|---|
| | |


| | |
|---|---|
| | |


(c)

- Figure 8.43 (a) A directed polytree. (b) The result of converting the polytree into an undirected graph showing the creation of loops. (c) The result of converting the polytree into a factor graph, which retains the tree structure.


precise form of the factorization. Figure 8.45 shows an example of a fully connected undirected graph along with two different factor graphs. In (b), the joint distribution is given by a general form p(x) = f(x1,x2,x3), whereas in (c), it is given by the more speciﬁc factorization p(x) = fa(x1,x2)fb(x1,x3)fc(x2,x3). It should be emphasized that the factorization in (c) does not correspond to any conditional independence properties.

###### 8.4.4 The sum-product algorithm

We shall now make use of the factor graph framework to derive a powerful class of efﬁcient, exact inference algorithms that are applicable to tree-structured graphs. Here we shall focus on the problem of evaluating local marginals over nodes or subsets of nodes, which will lead us to the sum-product algorithm. Later we shall modify the technique to allow the most probable state to be found, giving rise to the max-sum algorithm.

Also we shall suppose that all of the variables in the model are discrete, and so marginalization corresponds to performing sums. The framework, however, is equally applicable to linear-Gaussian models in which case marginalization involves integration, and we shall consider an example of this in detail when we discuss linear

Section 13.3 dynamical systems.

Figure 8.44 (a) A fragment of a directed graph having a local cycle. (b) Conversion to a fragment of a factor graph having a tree structure, in which f(x1, x2, x3) = p(x1)p(x2|x1)p(x3|x1, x2).

x1 x2

x3

(a)

x1 x2

| | |
|---|---|
| | |


f(x1,x2,x3)

x3

(b)
