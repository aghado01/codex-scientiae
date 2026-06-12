[Page 146]

- Figure 2.27 (a) In the K-nearestneighbour classiﬁer, a new point, shown by the black diamond, is classiﬁed according to the majority class membership of the K closest training data points, in this case K =

3. (b) In the nearest-neighbour (K = 1) approach to classiﬁcation, the resulting decision boundary is composed of hyperplanes that form perpendicular bisectors of pairs of points from different classes.

x1

x2

(a)

x1

x2

(b)

If we wish to minimize the probability of misclassiﬁcation, this is done by assigning the test point x to the class having the largest posterior probability, corresponding to the largest value of Kk/K. Thus to classify a new point, we identify the K nearest points from the training data set and then assign the new point to the class having the largest number of representatives amongst this set. Ties can be broken at random. The particular case of K = 1 is called the nearest-neighbour rule, because a test point is simply assigned to the same class as the nearest point from the training set. These concepts are illustrated in Figure 2.27.

In Figure 2.28, we show the results of applying the K-nearest-neighbour algorithm to the oil ﬂow data, introduced in Chapter 1, for various values of K. As expected, we see that K controls the degree of smoothing, so that small K produces many small regions of each class, whereas large K leads to fewer larger regions.

x6

x7

|![image 53](../../../../../images/imageFile53.png)<br><br>|
|---|


K = 1

0 1 2

- 0
- 1
- 2


x6

x7

K = 3

|![image 54](../../../../../images/imageFile54.png)<br><br>|
|---|


0 1 2

- 0
- 1
- 2


x6

x7

K = 31

|![image 55](../../../../../images/imageFile55.png)<br><br>|
|---|


0 1 2

- 0
- 1
- 2


- Figure 2.28 Plot of 200 data points from the oil data set showing values of x6 plotted against x7, where the red, green, and blue points correspond to the ‘laminar’, ‘annular’, and ‘homogeneous’ classes, respectively. Also shown are the classiﬁcations of the input space given by the K-nearest-neighbour algorithm for various values of K.
