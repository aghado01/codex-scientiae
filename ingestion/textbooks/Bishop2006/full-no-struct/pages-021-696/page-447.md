[Page 447]

Figure 9.2 Plot of the cost function J given by (9.1) after each E step (blue points) and M step (red points) of the K means algorithm for the example shown in Figure 9.1. The algorithm has converged after the third M step, and the ﬁnal EM cycle produces no changes in either the assignments or the prototype vectors.

![The image is a line graph with two lines. The x-axis is labeled as J and the y-axis is labeled as 0. The line on the graph is colored green and is labeled as J. The line on the graph is a straight line with a minimum value of 0 and a maximum value of 100. The line on the graph is also colored green and is labeled as J. The line on the graph is a straight line with a minimum value of 0 and a maximum value of 100. The line on the graph is colored green and is labeled as J. The line on the graph is a straight line with a minimum value of 0 and a maximum value of 100. The line on the graph is colored green and is labeled as J.](../images/imageFile217.png)

1000

J

500

0

1

2

3

4

Section 9.2.2

# Section 2.3.5

# Exercise 9.2

Note that we have deliberately chosen poor initial values for the cluster centres so that the algorithm takes several steps before convergence. In practice, a better initialization procedure would be to choose the cluster centres µ k to be equal to a random subset of K data points. It is also worth noting that the K -means algorithm itself is often used to initialize the parameters in a Gaussian mixture model before applying the EM algorithm.

A direct implementation of the K -means algorithm as discussed here can be relatively slow, because in each E step it is necessary to compute the Euclidean distance between every prototype vector and every data point. Various schemes have been proposed for speeding up the K -means algorithm, some of which are based on precomputing a data structure such as a tree such that nearby points are in the same subtree (Ramasubramanian and Paliwal, 1990; Moore, 2000). Other approaches make use of the triangle inequality for distances, thereby avoiding unnecessary distance calculations (Hodgson, 1998; Elkan, 2003).

So far, we have considered a batch version of K -means in which the whole data set is used together to update the prototype vectors. We can also derive an on-line stochastic algorithm (MacQueen, 1967) by applying the Robbins-Monro procedure to the problem of ﬁnding the roots of the regression function given by the derivatives of J in (9.1) with respect to µ k . This leads to a sequential update in which, for each data point x n in turn, we update the nearest prototype µ k using

$$
\mu _ { k } ^ { \text {new} } = \mu _ { k } ^ { \text {old} } + \eta _ { n } ( x _ { n } - \mu _ { k } ^ { \text {old} } )
$$

where η n is the learning rate parameter, which is typically made to decrease monotonically as more data points are considered.

The K -means algorithm is based on the use of squared Euclidean distance as the measure of dissimilarity between a data point and a prototype vector. Not only does this limit the type of data variables that can be considered (it would be inappropriate for cases where some or all of the variables represent categorical labels for instance),
