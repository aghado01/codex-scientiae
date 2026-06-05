[Page 447]

Figure 9.2 Plot of the cost function J given by (9.1) after each E step (blue points) and M step (red points) of the Kmeans algorithm for the example shown in Figure 9.1. The algorithm has converged after the third M step, and the ﬁnal EM cycle produces no changes in either the assignments or the prototype vectors.

| |
|---|


1000

J

500

0

1 2 3 4

case, the assignment of each data point to the nearest cluster centre is equivalent to a classiﬁcation of the data points according to which side they lie of the perpendicular bisector of the two cluster centres. A plot of the cost function J given by (9.1) for the Old Faithful example is shown in Figure 9.2.

Note that we have deliberately chosen poor initial values for the cluster centres so that the algorithm takes several steps before convergence. In practice, a better initialization procedure would be to choose the cluster centres µk to be equal to a random subset of K data points. It is also worth noting that the K-means algorithm itself is often used to initialize the parameters in a Gaussian mixture model before

- Section 9.2.2 applying the EM algorithm. A direct implementation of the K-means algorithm as discussed here can be


relatively slow, because in each E step it is necessary to compute the Euclidean distance between every prototype vector and every data point. Various schemes have been proposed for speeding up the K-means algorithm, some of which are based on precomputing a data structure such as a tree such that nearby points are in the same subtree (Ramasubramanian and Paliwal, 1990; Moore, 2000). Other approaches make use of the triangle inequality for distances, thereby avoiding unnecessary distance calculations (Hodgson, 1998; Elkan, 2003).

So far, we have considered a batch version of K-means in which the whole data

set is used together to update the prototype vectors. We can also derive an on-line Section 2.3.5 stochastic algorithm (MacQueen, 1967) by applying the Robbins-Monro procedure

to the problem of ﬁnding the roots of the regression function given by the derivatives

- Exercise 9.2 of J in (9.1) with respect to µk. This leads to a sequential update in which, for each data point xn in turn, we update the nearest prototype µk using


###### µnewk = µoldk + ηn(xn − µoldk ) (9.5)

where ηn is the learning rate parameter, which is typically made to decrease monotonically as more data points are considered.

The K-means algorithm is based on the use of squared Euclidean distance as the measure of dissimilarity between a data point and a prototype vector. Not only does this limit the type of data variables that can be considered (it would be inappropriate for cases where some or all of the variables represent categorical labels for instance),
