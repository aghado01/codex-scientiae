[Page 702]

Figure A.5 Plot of the time to the next eruption in minutes (vertical axis) versus the duration of the eruption in minutes (horizontal axis) for the Old Faithful data set.

data set.

![The image is a scatter plot with a title labeled Skewed Data and a legend at the bottom right corner. The plot is titled Skewed Data and has a scale from 0 to 100 on the x-axis, labeled Skewed Data and has a scale from 0 to 100 on the y-axis, labeled Skewed Data. The x-axis is labeled Skewed Data and has a scale from 0 to 100. The plot consists of several clusters of data points. The data points are scattered randomly across the x-axis, with no clear pattern or pattern. The data points are green, indicating that they are outliers or data points that are not in the main cluster. There are a few notable outliers in the data: 1. **Highest Data Points**: The data points that are the most spread out are the ones at the top of](../images/imageFile339.png)

100

90

80

70

60

50

1 40

1

2

3

4

5

6

# Synthetic Data

Throughout the book, we use two simple synthetic data sets to illustrate many of the algorithms. The ﬁrst of these is a regression problem, based on the sinusoidal function, shown in Figure A.6. The input values { x n } are generated uniformly in range (0 , 1) , and the corresponding target values { t n } are obtained by ﬁrst computing the corresponding values of the function sin(2 πx ) , and then adding random noise with a Gaussian distribution having standard deviation 0 . 3 . Various forms of this data set, having different numbers of data points, are used in the book.

The second data set is a classiﬁcation problem having two classes, with equal prior probabilities, and is shown in Figure A.7. The blue class is generated from a single Gaussian while the red class comes from a mixture of two Gaussians. Because we know the class priors and the class-conditional densities, it is straightforward to evaluate and plot the true posterior probabilities as well as the minimum misclassiﬁcation-rate decision boundary, as shown in Figure A.7.
