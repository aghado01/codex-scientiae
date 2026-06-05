[Page 484]

![The image is a graph that shows the relationship between the values of two variables, represented by the x-axis and the y-axis. The x-axis is labeled as −2 and the y-axis is labeled as 0. The graph shows three different lines, each representing a different set of values for the variables. The lines are as follows: 1. The first line is a green line with a positive value of 0.05. 2. The second line is a red line with a positive value of 0.06. 3. The third line is a green line with a positive value of 0.07. The x-axis values are given as 0, 0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2](../images/imageFile231.png)

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

Figure 10.1 Illustration of the variational approximation for the example considered earlier in Figure 4.14. The left-hand plot shows the original distribution (yellow) along with the Laplace (red) and variational (green) approximations, and the right-hand plot shows the negative logarithms of the corresponding curves.

However, we shall suppose the model is such that working with the true posterior distribution is intractable.

We therefore consider instead a restricted family of distributions q ( Z ) and then seek the member of this family for which the KL divergence is minimized. Our goal is to restrict the family sufﬁciently that they comprise only tractable distributions, while at the same time allowing the family to be sufﬁciently rich and ﬂexible that it can provide a good approximation to the true posterior distribution. It is important to emphasize that the restriction is imposed purely to achieve tractability, and that subject to this requirement we should use as rich a family of approximating distributions as possible. In particular, there is no ‘over-ﬁtting’ associated with highly ﬂexible distributions. Using more ﬂexible approximations simply allows us to approach the true posterior distribution more closely.

One way to restrict the family of approximating distributions is to use a parametric distribution q ( Z | ω ) governed by a set of parameters ω . The lower bound L ( q ) then becomes a function of ω , and we can exploit standard nonlinear optimization techniques to determine the optimal values for the parameters. An example of this approach, in which the variational distribution is a Gaussian and we have optimized with respect to its mean and variance, is shown in Figure 10.1.

# 10.1.1 Factorized distributions

Here we consider an alternative way in which to restrict the family of distributions q ( Z ) . Suppose we partition the elements of Z into disjoint groups that we denote by Z i where i = 1 ,...,M . We then assume that the q distribution factorizes with respect to these groups, so that

$$
q ( Z ) = \prod _ { i = 1 } ^ { M } q _ { i } ( Z _ { i } ) .
$$
