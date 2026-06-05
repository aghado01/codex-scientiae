[Page 420]

Figure 8.40 Example of a factor graph, which corresponds

to the factorization (8.60).

x1 x2 x3

fa fb fc fd

individual variables by xi, however, as in earlier discussions, these can comprise groups of variables (such as vectors or matrices). Each factor fs is a function of a corresponding set of variables xs.

Directed graphs, whose factorization is deﬁned by (8.5), represent special cases of (8.59) in which the factors fs(xs) are local conditional distributions. Similarly, undirected graphs, given by (8.39), are a special case in which the factors are potential functions over the maximal cliques (the normalizing coefﬁcient 1/Z can be viewed as a factor deﬁned over the empty set of variables).

In a factor graph, there is a node (depicted as usual by a circle) for every variable in the distribution, as was the case for directed and undirected graphs. There are also additional nodes (depicted by small squares) for each factor fs(xs) in the joint distribution. Finally, there are undirected links connecting each factor node to all of the variables nodes on which that factor depends. Consider, for example, a distribution that is expressed in terms of the factorization

###### p(x) = fa(x1,x2)fb(x1,x2)fc(x2,x3)fd(x3). (8.60)

This can be expressed by the factor graph shown in Figure 8.40. Note that there are two factors fa(x1,x2) and fb(x1,x2) that are deﬁned over the same set of variables. In an undirected graph, the product of two such factors would simply be lumped together into the same clique potential. Similarly, fc(x2,x3) and fd(x3) could be combined into a single potential over x2 and x3. The factor graph, however, keeps such factors explicit and so is able to convey more detailed information about the underlying factorization.

x1 x2

x3

(a)

x1 x2

f

| | |
|---|---|
| | |


x3

(b)

x1 x2

fa

| | |
|---|---|
| | |


| | |
|---|---|
| | |


fb

x3

(c)

- Figure 8.41 (a) An undirected graph with a single clique potential ψ(x1, x2, x3). (b) A factor graph with factor f(x1, x2, x3) = ψ(x1, x2, x3) representing the same distribution as the undirected graph. (c) A different factor graph representing the same distribution, whose factors satisfy fa(x1, x2, x3)fb(x1, x2) = ψ(x1, x2, x3).
