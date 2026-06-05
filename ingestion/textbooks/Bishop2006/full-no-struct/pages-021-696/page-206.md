[Page 206]

4

![The image is a scatter plot with two axes. The x-axis is labeled x and the y-axis is labeled y. The plot is divided into two sections, each labeled x and y. The x-axis is labeled x and the y-axis is labeled y. There are two sets of data points plotted on the graph. The first set of data points is plotted on the x-axis and the second set of data points is plotted on the y-axis. The data points are scattered around the x-axis and the y-axis. The scatter plot is not perfectly symmetrical, but there are some patterns visible. The first set of data points is plotted on the x-axis and the second set of data points is plotted on the y-axis. The x-axis is labeled x and the y-axis is labeled y. The data points are scattered around the x-axis and the y-axis](../images/imageFile94.png)

4

2

2

0

0

−2

−2

−4

−4

−6

−6

−8

−8

−4

−2

0

2

4

6

8

−4

−2

0

2

4

6

8

Figure 4.4 The left plot shows data from two classes, denoted by red crosses and blue circles, together with the decision boundary found by least squares (magenta curve) and also by the logistic regression model (green curve), which is discussed later in Section 4.3.2. The right-hand plot shows the corresponding results obtained when extra data points are added at the bottom left of the diagram, showing that least squares is highly sensitive to outliers, unlike logistic regression.

However, problems with least squares can be more severe than simply lack of robustness, as illustrated in Figure 4.5. This shows a synthetic data set drawn from three classes in a two-dimensional input space ( x 1 ,x 2 ) , having the property that linear decision boundaries can give excellent separation between the classes. Indeed, the technique of logistic regression, described later in this chapter, gives a satisfactory solution as seen in the right-hand plot. However, the least-squares solution gives poor results, with only a small region of the input space assigned to the green class.

The failure of least squares should not surprise us when we recall that it corresponds to maximum likelihood under the assumption of a Gaussian conditional distribution, whereas binary target vectors clearly have a distribution that is far from Gaussian. By adopting more appropriate probabilistic models, we shall obtain classiﬁcation techniques with much better properties than least squares. For the moment, however, we continue to explore alternative nonprobabilistic methods for setting the parameters in the linear classiﬁcation models.

# 4.1.4 Fisher’s linear discriminant

One way to view a linear classiﬁcation model is in terms of dimensionality reduction. Consider ﬁrst the case of two classes, and suppose we take the D -
