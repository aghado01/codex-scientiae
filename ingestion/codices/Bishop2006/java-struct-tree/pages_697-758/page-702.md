[Page 702]

Figure A.5 Plot of the time to the next eruption in minutes (vertical axis) versus the duration of the eruption in minutes (horizontal axis) for the Old Faithful data set.

100

90

80

70

60

50

40

1 2 3 4 5 6

Synthetic Data

Throughout the book, we use two simple synthetic data sets to illustrate many of the algorithms. The ﬁrst of these is a regression problem, based on the sinusoidal function, shown in Figure A.6. The input values {xn} are generated uniformly in range (0,1), and the corresponding target values {tn} are obtained by ﬁrst computing the corresponding values of the function sin(2πx), and then adding random noise with a Gaussian distribution having standard deviation 0.3. Various forms of this data set, having different numbers of data points, are used in the book.

The second data set is a classiﬁcation problem having two classes, with equal prior probabilities, and is shown in Figure A.7. The blue class is generated from a single Gaussian while the red class comes from a mixture of two Gaussians. Because we know the class priors and the class-conditional densities, it is straightforward to evaluate and plot the true posterior probabilities as well as the minimum misclassiﬁcation-rate decision boundary, as shown in Figure A.7.
