[Page 321]

![The image is a graph that shows the behavior of two different functions. The graph is titled Graphs and has a title Graphs at the top. The graph is a line graph, with two lines extending from the graph. The lines are labeled as follows: - The first line is a blue line, which starts at the top of the graph and extends downward to the bottom. - The second line is a red line, which starts at the top of the graph and extends upward to the bottom. The x-axis is labeled as x, and the y-axis is labeled as y. The graph shows the values of the two lines at different points. The x-axis is labeled as x, and the y-axis is labeled as y. The graph shows that the blue line is the highest line, and the red line is the lowest line. The blue line is above the red line at all points, and](../images/imageFile132.png)

Figure 6.2 Plot of a set of Gaussian basis functions on the left, together with the corresponding normalized basis functions on the right.

One of the simplest ways of choosing basis function centres is to use a randomly chosen subset of the data points. A more systematic approach is called orthogonal least squares (Chen et al., 1991). This is a sequential selection process in which at each step the next data point to be chosen as a basis function centre corresponds to the one that gives the greatest reduction in the sum-of-squares error. Values for the expansion coefﬁcients are determined as part of the algorithm. Clustering algorithms such as $K$-means have also been used, which give a set of basis function centres that no longer coincide with training data points.

###### 6.3.1 Nadaraya-Watson model

In Section 3.3.3, we saw that the prediction of a linear regression model for a new input $\mathbf{x}$ takes the form of a linear combination of the training set target values with coefﬁcients given by the ‘equivalent kernel’ (3.62) where the equivalent kernel satisﬁes the summation constraint (3.64).

We can motivate the kernel regression model (3.61) from a different perspective, starting with kernel density estimation. Suppose we have a training set $\{\mathbf{x}_n,t_n\}$ and we use a Parzen density estimator to model the joint distribution $p(\mathbf{x},t)$, so that

$$
p(\mathbf{x},t) = \frac{1}{N} \sum_{n=1}^N f(\mathbf{x} - \mathbf{x}_n, t - t_n) \tag{6.42}
$$

where $f(\mathbf{x},t)$ is the component density function, and there is one such component centred on each data point. We now ﬁnd an expression for the regression function $y(\mathbf{x})$, corresponding to the conditional average of the target variable conditioned on
