[Page 410]

Figure 8.32 (a) Example of a directed graph. (b) The equivalent undirected graph.

x

x

x

x

![The image presents a diagram with two circular arrows pointing in opposite directions. The arrows are labeled as a and b, and they are connected to a circular structure with a label N inside it. The arrows are pointing in opposite directions, indicating that they are connected to the same circular structure. The diagram is labeled as follows: - **A** is connected to **N** with a circular arrow. - **B** is connected to **N** with a circular arrow. The diagram is a simple representation of a circular structure with a label N inside it. The arrows are labeled as a and b, and they are connected to the same circular structure. The diagram is a simple representation of a circular structure with a label N inside it. The arrows are labeled as a and b, and they are connected to the same circular structure. The diagram is a simple representation of a](../images/imageFile191.png)

-

N

1

N

1

2

(a)

x

x

x

x

-

N

1

N

1

2

(b)

Exercise 8.14

Section 8.4

For the purposes of this simple illustration, we have ﬁxed the parameters to be β = 1 . 0 , η = 2 . 1 and h = 0 . Note that leaving h = 0 simply means that the prior probabilities of the two states of x i are equal. Starting with the observed noisy image as the initial conﬁguration, we run ICM until convergence, leading to the de-noised image shown in the lower left panel of Figure 8.30. Note that if we set β = 0 , which effectively removes the links between neighbouring pixels, then the global most probable solution is given by x i = y i for all i , corresponding to the observed noisy image.

Later we shall discuss a more effective algorithm for ﬁnding high probability solutions called the max-product algorithm, which typically leads to better solutions, although this is still not guaranteed to ﬁnd the global maximum of the posterior distribution. However, for certain classes of model, including the one given by (8.42), there exist efﬁcient algorithms based on graph cuts that are guaranteed to ﬁnd the global maximum (Greig et al. , 1989; Boykov et al. , 2001; Kolmogorov and Zabih, 2004). The lower right panel of Figure 8.30 shows the result of applying a graph-cut algorithm to the de-noising problem.

# 8.3.4 Relation to directed graphs

We have introduced two graphical frameworks for representing probability distributions, corresponding to directed and undirected graphs, and it is instructive to discuss the relation between these. Consider ﬁrst the problem of taking a model that is speciﬁed using a directed graph and trying to convert it to an undirected graph. In some cases this is straightforward, as in the simple example in Figure 8.32. Here the joint distribution for the directed graph is given as a product of conditionals in the form

$$
p ( x ) & = p ( x _ { 1 } ) p ( x _ { 2 } | x _ { 1 } ) p ( x _ { 3 } | x _ { 2 } ) \cdots p ( x _ { N } | x _ { N - 1 } ) . \\ \\ 1 _ { 0 } & \quad - p ( x _ { 1 } ) \dot { \cdot } \cdot \cdot \cdot \\
$$

Now let us convert this to an undirected graph representation, as shown in Figure 8.32. In the undirected graph, the maximal cliques are simply the pairs of neighbouring nodes, and so from (8.39) we wish to write the joint distribution in the form

$$
p ( x ) = \frac { 1 } { Z } \psi _ { 1 , 2 } ( x _ { 1 } , x _ { 2 } ) \psi _ { 2 , 3 } ( x _ { 2 } , x _ { 3 } ) \cdots \psi _ { N - 1 , N } ( x _ { N - 1 } , x _ { N } ) .
$$
