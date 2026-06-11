[Page 420]

Figure 8.40 Example of a factor graph, which corresponds to the factorization (8.60).

x

x

x

![image 199](../images/imageFile199.png)

1

2

3

f

f

f

f

a

b

c

d

individual variables by x i , however, as in earlier discussions, these can comprise groups of variables (such as vectors or matrices). Each factor f s is a function of a corresponding set of variables x s . Directed graphs, whose factorization is deﬁned by (8.5), represent special cases

of (8.59) in which the factors f s ( x s ) are local conditional distributions. Similarly, undirected graphs, given by (8.39), are a special case in which the factors are potential functions over the maximal cliques (the normalizing coefﬁcient 1 /Z can be viewed as a factor deﬁned over the empty set of variables).

In a factor graph, there is a node (depicted as usual by a circle) for every variable in the distribution, as was the case for directed and undirected graphs. There are also additional nodes (depicted by small squares) for each factor f s ( x s ) in the joint distribution. Finally, there are undirected links connecting each factor node to all of the variables nodes on which that factor depends. Consider, for example, a distribution that is expressed in terms of the factorization

$$
p ( x ) = f _ { a } ( x _ { 1 } , x _ { 2 } ) f _ { b } ( x _ { 1 } , x _ { 2 } ) f _ { c } ( x _ { 2 } , x _ { 3 } ) f _ { d } ( x _ { 3 } ) .
$$

This can be expressed by the factor graph shown in Figure 8.40. Note that there are two factors f a ( x 1 ,x 2 ) and f b ( x 1 ,x 2 ) that are deﬁned over the same set of variables. In an undirected graph, the product of two such factors would simply be lumped together into the same clique potential. Similarly, f c ( x 2 ,x 3 ) and f d ( x 3 ) could be combined into a single potential over x 2 and x 3 . The factor graph, however, keeps such factors explicit and so is able to convey more detailed information about the underlying factorization.

x

x

x

x

x

x

![The image is a diagram consisting of three interconnected circles. Each circle is connected to the others by a line segment. The circles are labeled with different numbers and are arranged in a triangular formation. The diagram is labeled as follows: - **Circle A**: This circle is connected to the first circle, which is labeled as circle B. - **Circle B**: This circle is connected to the second circle, which is labeled as circle C. - **Circle C**: This circle is connected to the third circle, which is labeled as circle D. The lines connecting the circles are labeled with numbers, starting from the top of the diagram and moving down. The numbers are as follows: - **Circle A**: 1 - **Circle B**: 2 - **Circle C**: 3 - **Circle D**: 4 The diagram is labeled as follows: - **Circle A**: The first](../images/imageFile200.png)

1

2

1

2

1

2

f

f

a

f

b

x

x

x

3

3

3

(a)

(b)

(c)

Figure 8.41 (a) An undirected graph with a single clique potential ψ ( x 1 , x 2 , x 3 ) . (b) A factor graph with factor f ( x 1 , x 2 , x 3 ) = ψ ( x 1 , x 2 , x 3 ) representing the same distribution as the undirected graph. (c) A different factor graph representing the same distribution, whose factors satisfy f a ( x 1 , x 2 , x 3 ) f b ( x 1 , x 2 ) = ψ ( x 1 , x 2 , x 3 ) .
