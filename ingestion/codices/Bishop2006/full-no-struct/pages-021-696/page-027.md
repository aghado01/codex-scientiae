[Page 27]

![The image is a graph consisting of four different lines, each represented by a different color. The lines are connected by a horizontal line and a vertical line. The x-axis is labeled as t and the y-axis is labeled as M. The graph is titled M = 0 and has a label M = 1. Each line in the graph has a different color: 1. The first line is red and has a label of M = 0 on the x-axis. 2. The second line is green and has a label of M = 0 on the x-axis. 3. The third line is blue and has a label of M = 0 on the x-axis. 4. The fourth line is green and has a label of M = 0 on the x-axis. Each line has a different slope and a different value of M.](../images/imageFile7.png)

M

= 0

M

= 1

1

1

t

t

0

0

−1

−1

0

1

0

1

x

x

M

= 3

M

= 9

1

1

t

t

0

0

−1

−1

0

1

0

1

x

x

Figure 1.4 Plots of polynomials having various orders M , shown as red curves, ﬁtted to the data set shown in Figure 1.2.

(RMS) error deﬁned by

$$
r _ { R M S } = \sqrt { 2 E ( w ^ { * } ) / N } \quad ( 1 . 3 ) \\ \text {lows us to compare different sizes of data sets on
tree } \, \text {root ensures that } E _ { R M S } \, \text {is measured on the same
} \, \text {size}
$$

$$
E _ { R M S } = \sqrt { 2 E ( w ^ { * } ) / N }
$$

in which the division by N allows us to compare different sizes of data sets on an equal footing, and the square root ensures that E RMS is measured on the same scale (and in the same units) as the target variable t . Graphs of the training and test set RMS errors are shown, for various values of M , in Figure 1.5. The test set error is a measure of how well we are doing in predicting the values of t for new data observations of x . We note from Figure 1.5 that small values of M give relatively large values of the test set error, and this can be attributed to the fact that the corresponding polynomials are rather inﬂexible and are incapable of capturing the oscillations in the function sin(2 πx ) . Values of M in the range 3 M 8 give small values for the test set error, and these also give reasonable representations of the generating function sin(2 πx ) , as can be seen, for the case of M = 3 , from Figure 1.4.
