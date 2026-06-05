[Page 330]

![The image consists of a diagram with a line labeled as ( m(x) ) and a point ( x ) on the line. The diagram is a circle with a radius of ( 1 ). The line ( m(x) ) is drawn as a dashed line, and the point ( x ) is located on the line. The line segment ( m(x) ) is shown to intersect the circle at two points, ( x_1 ) and ( x_2 ).](../images/imageFile137.png)

t

2

1

m

(

)

2

x

0

t

1

−1

−1

0

1

# Exercise 6.23

framework. However, an advantage of a Gaussian processes viewpoint is that we can consider covariance functions that can only be expressed in terms of an inﬁnite number of basis functions.

For large training data sets, however, the direct application of Gaussian process methods can become infeasible, and so a range of approximation schemes have been developed that have better scaling with training set size than the exact approach (Gibbs, 1997; Tresp, 2001; Smola and Bartlett, 2001; Williams and Seeger, 2001; Csat´ o and Opper, 2002; Seeger et al. , 2003). Practical issues in the application of Gaussian processes are discussed in Bishop and Nabney (2008).

We have introduced Gaussian process regression for the case of a single target variable. The extension of this formalism to multiple target variables, known as co-kriging (Cressie, 1993), is straightforward. Various other extensions of Gaus-

Figure 6.8

Illustration of Gaussian process regression applied to the sinusoidal data set in Figure A.6 in which the three right-most data points have been omitted. The green curve shows the sinusoidal function from which the data points, shown in blue, are obtained by sampling and addition of Gaussian noise. The red line shows the mean of the Gaussian process predictive distribution, and the shaded region corresponds to plus and minus two standard deviations. Notice how the uncertainty increases in the region to the right of the data points.

![The image is a line graph that shows the trend of a series of data points over a period of time. The x-axis represents the time, ranging from 0 to 1. The y-axis represents the values, ranging from 0.2 to 0.8. The data points are plotted as a line, with each point representing a single data point. The line graph shows a general upward trend, with the points increasing from left to right. The points are marked with blue and green lines, indicating that the data points are increasing. The line appears to be increasing at a steady rate, with the points moving from left to right. There are a few notable observations: 1. **Initial Trend**: The graph starts with a small initial increase, around 0.2. This indicates a small initial increase in the data. 2. **Moderate Trend**: The graph shows a moderate increase in the data, around 0.4](../images/imageFile138.png)

1

0.5

0

−0.5

−1

0

0.2

0.4

0.6

0.8

1
