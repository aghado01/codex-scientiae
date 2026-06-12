[Page 328]

![The image is a scatter plot with four different colors and four different lines. The x-axis is labeled as 1, the y-axis is labeled as 1, and the points are represented by the colors blue, red, green, and orange. The points are scattered across the graph, with each color representing a different type of data point. The lines are also colored differently, with blue representing a linear trend, red representing a non-linear trend, green representing a non-linear trend, and orange representing a non-linear trend. The scatter plot is titled 1,00, 4,00, 0,00, 0,00. The title is written in a bold, sans-serif font. The scatter plot is visually represented with four different lines, each represented by a different color. The lines are colored in blue, red, green, and orange. The blue line is represented by the color 1](../images/imageFile135.png)

(1 .

.

00

,

4

.

00

,

0

.

00

,

0

.

0.

(9 .

.

00

,

4

.

00

,

0

.

00

,

0

.

0.

(1 .

.

00

,

64 .

.

00

,

0

.

00

,

0

.

0.

3

9

3

1.5

4.5

1.5

0

0

0

−1.5

−4.5

−1.5

-3

-9

-3

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

(1 .

.

00

,

4

.

00

,

0

.

00

,

5

.

0.

(1 .

.

00

,

0

.

25

,

0

.

00

,

0

.

0.

(1 .

.

00

,

4

.

00

,

10 .

.

00

,

0

.

0.

3

9

4

1.5

4.5

2

0

0

0

−1.5

−4.5

−2

-3

-9

-4

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

Figure 6.5 Samples from a Gaussian process prior deﬁned by the covariance function (6.63). The title above each plot denotes ( θ 0 , θ 1 , θ 2 , θ 3 ) .

$$
m ( x _ { N + 1 } ) \ = \ k ^ { T } C _ { N } ^ { - 1 } \mathfrak { t } \\
$$

$$
\begin{array} { r l r } { \tau ^ { 2 } ( x _ { N + 1 } ) } & = } & { c - k ^ { T } C _ { N } ^ { - 1 } k . } \end{array}
$$

$$
\sigma ^ { 2 } ( \mathbf x _ { N + 1 } ) \ = \ c - \mathbf k ^ { \mathrm T } C _ { N } ^ { - 1 } \mathbf k .
$$

These are the key results that deﬁne Gaussian process regression. Because the vector k is a function of the test point input value x N +1 , we see that the predictive distribution is a Gaussian whose mean and variance both depend on x N +1 . An example of Gaussian process regression is shown in Figure 6.8.
