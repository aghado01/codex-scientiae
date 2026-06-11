[Page 410]

Figure 8.32 (a) Example of a directed graph. (b) The equivalent undirected graph.

(a)

x1 x2 xN−1 xN

(b)

x1 x2 xN xN−1

will have converged to a local maximum of the probability. This need not, however, correspond to the global maximum.

For the purposes of this simple illustration, we have ﬁxed the parameters to be β = 1.0, η = 2.1 and h = 0. Note that leaving h = 0 simply means that the prior probabilities of the two states of xi are equal. Starting with the observed noisy image as the initial conﬁguration, we run ICM until convergence, leading to the de-noised image shown in the lower left panel of Figure 8.30. Note that if we set β = 0, which effectively removes the links between neighbouring pixels, then the global most probable solution is given by xi = yi for all i, corresponding to the observed

Exercise 8.14 noisy image.

Later we shall discuss a more effective algorithm for ﬁnding high probability so-

Section 8.4 lutions called the max-product algorithm, which typically leads to better solutions, although this is still not guaranteed to ﬁnd the global maximum of the posterior distribution. However, for certain classes of model, including the one given by (8.42), there exist efﬁcient algorithms based on graph cuts that are guaranteed to ﬁnd the global maximum (Greig et al., 1989; Boykov et al., 2001; Kolmogorov and Zabih, 2004). The lower right panel of Figure 8.30 shows the result of applying a graph-cut algorithm to the de-noising problem.

8.3.4 Relation to directed graphs

We have introduced two graphical frameworks for representing probability distributions, corresponding to directed and undirected graphs, and it is instructive to discuss the relation between these. Consider ﬁrst the problem of taking a model that is speciﬁed using a directed graph and trying to convert it to an undirected graph. In some cases this is straightforward, as in the simple example in Figure 8.32. Here the joint distribution for the directed graph is given as a product of conditionals in the form

p(x) = p(x1)p(x2|x1)p(x3|x2)···p(xN|xN−1). (8.44)

Now let us convert this to an undirected graph representation, as shown in Figure 8.32. In the undirected graph, the maximal cliques are simply the pairs of neighbouring nodes, and so from (8.39) we wish to write the joint distribution in the form

1 Z

ψ1,2(x1,x2)ψ2,3(x2,x3)···ψN−1,N(xN−1,xN). (8.45)

p(x) =
