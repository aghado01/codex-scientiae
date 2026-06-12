[Page 528]

![The image is a graph that shows the relationship between the values of two variables, represented by the x-axis and the y-axis. The x-axis is labeled as −2 and the y-axis is labeled as 0. The graph shows a trend of increasing values of the variables, with the highest value on the y-axis and the lowest value on the x-axis. The graph shows a clear pattern: - The highest value on the y-axis is approximately 30. - The lowest value on the y-axis is approximately 1. - The values are increasing in a linear fashion, with a constant rate of increase. The graph also shows a pattern of decreasing values: - The highest value on the y-axis is approximately 1.5. - The lowest value on the y-axis is approximately 0.5. - The values are decreasing in a linear fashion, with a](../images/imageFile247.png)

1

40

0.8

30

0.6

20

0.4

10

0.2

0

0

-2

−1

0

1

2

3

4

-2

−1

0

1

2

3

4

Figure 10.14 Illustration of the expectation propagation approximation using a Gaussian distribution for the example considered earlier in Figures 4.14 and 10.1. The left-hand plot shows the original distribution (yellow) along with the Laplace (red), global variational (green), and EP (blue) approximations, and the right-hand plot shows the corresponding negative logarithms of the distributions. Note that the EP distribution is broader than that variational inference, as a consequence of the different form of KL divergence.

$$
Z _ { j } & = \int f _ { j } ( \theta ) q ^ { \langle j } ( \theta ) \, \mathrm d \theta . \\
$$

We now determine a revised factor f j ( θ ) by minimizing the Kullback-Leibler divergence KL f j ( θ ) q \ j ( θ ) q new ( θ ) . (10.198)

$$
\text {the used factor} \, j ( 0 ) \, \text {by removing the $\kappa$-kernel} \, Z _ { j } \, \text { } \\ \text {KL} \left ( \frac { f _ { j } ( \theta ) q ^ { \vee j } ( \theta ) } { Z _ { j } } \right \| q ^ { \text {new} } ( \theta ) \right ) . \quad ( 1 0 . 1 8 ) \\ \text {proved because the approximating distribution} \, q ^ { \text {new} } ( \theta ) \, \text {is from the ex-} \\ \text {y, and so we can appeal to the result (10.0.187), which tells us that the}
$$

Z j This is easily solved because the approximating distribution q new ( θ ) is from the exponential family, and so we can appeal to the result (10.187), which tells us that the parameters of q new ( θ ) are obtained by matching its expected sufﬁcient statistics to the corresponding moments of (10.196). We shall assume that this is a tractable operation. For example, if we choose q ( θ ) to be a Gaussian distribution N ( θ | µ , Σ ) , then µ is set equal to the mean of the (unnormalized) distribution f j ( θ ) q \ j ( θ ) , and Σ is set to its covariance. More generally, it is straightforward to obtain the required expectations for any member of the exponential family, provided it can be normalized, because the expected statistics can be related to the derivatives of the normalization coefﬁcient, as given by (2.226). The EP approximation is illustrated in Figure 10.14.

From (10.193), we see that the revised factor f j ( θ ) can be found by taking q new ( θ ) and dividing out the remaining factors so that q new ( θ )

$$
\widetilde { f } _ { j } ( \theta ) = K \frac { q ^ { n e } ( \theta ) } { q ^ { \langle j } ( \theta ) } & & ( 1 0 . 1 9 ) \\ 0 . 1 9 5 ) . \, \text {The coefficient } K \text { is determined by multiplying both}
$$

where we have used (10.195). The coefﬁcient K is determined by multiplying both
