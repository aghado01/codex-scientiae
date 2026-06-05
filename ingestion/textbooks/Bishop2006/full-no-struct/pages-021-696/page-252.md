[Page 252]

Example of the solution of a simple twoclass classiﬁcation problem involving synthetic data using a neural network having two inputs, two hidden units with ‘ tanh ’ activation functions, and a single output having a logistic sigmoid activation function. The dashed blue lines show the z = 0 . 5 contours for each of the hidden units, and the red line shows the y = 0 . 5 decision surface for the network. For comparison, the green line denotes the optimal decision boundary computed from the distributions used to generate the data.

3

![The image is a scatter plot with a white background. The plot consists of a grid of points, each marked with a blue dot. The points are scattered across the grid, with some points closer to the top and some farther away. The points are connected by lines, with each line representing a different direction. The lines are colored in red and blue, with the red line being the most prominent. The x-axis is labeled as x and the y-axis is labeled as y. The plot is titled scatter plot. There are a few notable elements in the image: 1. **Grid Points**: There are a few grid points scattered across the image. These points are scattered in a grid pattern, with some points closer to the top and some farther away. 2. **Lines**: There are several lines in the image, each representing a different direction. These lines are colored in red and blue, with the red line being the most prominent.](../images/imageFile110.png)

2

1

0

- −1
- −2

−2

−1

0

1

2

symmetries, and thus any given weight vector will be one of a set 2 M equivalent weight vectors .

Similarly, imagine that we interchange the values of all of the weights (and the bias) leading both into and out of a particular hidden unit with the corresponding values of the weights (and bias) associated with a different hidden unit. Again, this clearly leaves the network input–output mapping function unchanged, but it corresponds to a different choice of weight vector. For M hidden units, any given weight vector will belong to a set of M ! equivalent weight vectors associated with this interchange symmetry, corresponding to the M ! different orderings of the hidden units. The network will therefore have an overall weight-space symmetry factor of M !2 M . For networks with more than two layers of weights, the total level of symmetry will be given by the product of such factors, one for each layer of hidden units.

It turns out that these factors account for all of the symmetries in weight space (except for possible accidental symmetries due to speciﬁc choices for the weight values). Furthermore, the existence of these symmetries is not a particular property of the ‘ tanh ’ function but applies to a wide range of activation functions (K˙ urkov´ a and Kainen, 1994). In many cases, these symmetries in weight space are of little practical consequence, although in Section 5.7 we shall encounter a situation in which we need to take them into account.

# 5.2. Network Training

So far, we have viewed neural networks as a general class of parametric nonlinear functions from a vector x of input variables to a vector y of output variables. A simple approach to the problem of determining the network parameters is to make an analogy with the discussion of polynomial curve ﬁtting in Section 1.1, and therefore to minimize a sum-of-squares error function. Given a training set comprising a set of input vectors { x n } , where n = 1 ,...,N , together with a corresponding set of
