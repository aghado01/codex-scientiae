[Page 277]

![The image presents a graph with three different sets of data points. The x-axis is labeled as M = 1 and the y-axis is labeled as M = 3. The data points are represented by red circles. The data points are scattered around the x-axis, but they are not perfectly aligned. There are two sets of data points, each with three data points. The first set of data points is located at the top of the graph, while the second set of data points is located at the bottom of the graph.](../images/imageFile115.png)

M

= 1

M

= 3

M

= 10

1

1

1

0

0

0

−1

−1

−1

0

1

0

1

0

1

Figure 5.9 Examples of two-layer networks trained on 10 data points drawn from the sinusoidal data set. The graphs show the result of ﬁtting networks having M = 1 , 3 and 10 hidden units, respectively, by minimizing a sum-of-squares error function using a scaled conjugate-gradient algorithm.

$$
\widetilde { E } ( w ) = E ( w ) + \frac { \lambda } { 2 } w ^ { T } w . \\ \intertext { a l s o k n o w n a s w e i g h t d e c a y } \text {effective model complexity is then determined by the choice of }
$$

# 5.5.1 Consistent Gaussian priors

One of the limitations of simple weight decay in the form (5.112) is that is inconsistent with certain scaling properties of network mappings. To illustrate this, consider a multilayer perceptron network having two layers of weights and linear output units, which performs a mapping from a set of input variables { x i } to a set of output variables { y k } . The activations of the hidden units in the ﬁrst hidden layer

Figure 5.10 Plot of the sum-of-squares test-set error for the polynomial data set versus the number of hidden units in the network, with 30 random starts for each network size, showing the effect of local minima. For each new start, the weight vector was initialized by sampling from an isotropic Gaussian distribution having a mean of zero and a variance of .

of zero and a variance of 10 .

![The image is a bar chart titled Bars with a title at the top. The chart is titled Bars and has a legend at the bottom. The chart has a white background with a grid of blue bars. The x-axis is labeled Bars and has a scale from 0 to 160. The y-axis is labeled Bars and has a range from 0 to 100. The bars are color-coded, with blue bars representing the highest bar and red bars representing the lowest bar. The legend at the top of the chart indicates that the y-axis is labeled Bars and the x-axis is labeled Bars. The bars are color-coded to represent the heights of the bars, with blue bars representing the highest bar and red bars representing the lowest bar. The chart is designed to show the relationship between two variables, specifically the height of the bars for each category](../images/imageFile116.png)

160

140

120

100

80

60

0

2

4

6

8

10
