[Page 422]

![The image is a diagram consisting of three interconnected circles. Each circle is connected to the others by a line. The circles are arranged in a clockwise direction, starting from the top left and moving clockwise. Here is a detailed description of the diagram: - **Circle 1**: This circle is connected to the center of the diagram. - **Circle 2**: This circle is connected to the center of the diagram, but it is not connected to the center of the diagram. - **Circle 3**: This circle is connected to the center of the diagram, but it is not connected to the center of the diagram. The diagram is labeled with the following labels: - **Circle 1**: The center of the diagram. - **Circle 2**: The center of the diagram. - **Circle 3**: The center of the diagram. The diagram is a simple representation of a circle with a line](../images/imageFile202.png)

(a)

(b)

(c)

Figure 8.43 (a) A directed polytree. (b) The result of converting the polytree into an undirected graph showing the creation of loops. (c) The result of converting the polytree into a factor graph, which retains the tree structure.

# Section 13.3

# 8.4.4 The sum-product algorithm

We shall now make use of the factor graph framework to derive a powerful class of efﬁcient, exact inference algorithms that are applicable to tree-structured graphs. Here we shall focus on the problem of evaluating local marginals over nodes or subsets of nodes, which will lead us to the sum-product algorithm. Later we shall modify the technique to allow the most probable state to be found, giving rise to the max-sum algorithm.

Also we shall suppose that all of the variables in the model are discrete, and so marginalization corresponds to performing sums. The framework, however, is equally applicable to linear-Gaussian models in which case marginalization involves integration, and we shall consider an example of this in detail when we discuss linear dynamical systems.

# Figure 8.44

(a) A fragment of a directed graph having a local cycle. (b) Conversion to a fragment of a factor graph having a tree structure, in which f ( x 1 , x 2 , x 3 ) = p ( x 1 ) p ( x 2 | x 1 ) p ( x 3 | x 1 , x 2 ) .

x

x

x

x

![In this image, we can see a diagram with two circles and some text. The diagram is labeled as f(x,y,z).](../images/imageFile203.png)

1

2

1

2

f

(

x

,x 2

,x 3

)

1

2

3

x

x

3

3

(a)

(b)
