[Page 55]

Figure 1.20 Illustration of a simple approach to the solution of a classiﬁcation problem in which the input space is divided into cells and any new test point is assigned to the class that has a majority number of representatives in the same cell as the test point. As we shall see shortly, this simplistic approach has some severe shortcomings.

![The image is a scatter plot with a grid of points. The points are scattered across the image, with a grid of points forming a grid of squares. The points are colored in different colors, with each color representing a different number of points. The colors are red, green, blue, and pink. The points are scattered in a random pattern, with no clear pattern or pattern in the grid. The x-axis is labeled as x, and the y-axis is labeled as y. The x-axis is labeled as x1, and the y-axis is labeled as y1. The grid of points is filled with red, green, blue, and pink colors. The points are scattered in a random pattern, with no clear pattern or pattern in the grid. There are no labels or text on the image. The image is a simple scatter plot with no additional information. ### Analysis and Description: The scatter plot is a](../images/imageFile25.png)

fall in the same cell. The identity of the test point is predicted as being the same as the class having the largest number of training points in the same cell as the test point (with ties being broken at random).

There are numerous problems with this naive approach, but one of the most severe becomes apparent when we consider its extension to problems having larger numbers of input variables, corresponding to input spaces of higher dimensionality. The origin of the problem is illustrated in Figure 1.21, which shows that, if we divide a region of a space into regular cells, then the number of such cells grows exponentially with the dimensionality of the space. The problem with an exponentially large number of cells is that we would need an exponentially large quantity of training data in order to ensure that the cells are not empty. Clearly, we have no hope of applying such a technique in a space of more than a few variables, and so we need to ﬁnd a more sophisticated approach.

We can gain further insight into the problems of high-dimensional spaces by returning to the example of polynomial curve ﬁtting and considering how we would

Figure 1.21 Illustration of the curse of dimensionality, showing how the number of regions of a regular grid grows exponentially with the dimensionality $D$ of the space. For clarity, only a subset of the cubical regions are shown for $D = 3$.

![In this image, we can see a diagram with a graph and some text. The graph is represented by a line. There are some points on the graph.](../images/imageFile26.png)
