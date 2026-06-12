[Page 531]

# Figure 10.15

Illustration of the clutter problem for a data space dimensionality of D = 1 . Training data points, denoted by the crosses, are drawn from a mixture of two Gaussians with components shown in red and green. The goal is to infer the mean of the green Gaussian from the observed data.

![The image is a graph with two axes. The x-axis is labeled as z and the y-axis is labeled as z. The graph is a line graph with two peaks and two troughs. The line is drawn from the bottom left to the top right, with the peaks and troughs being the same size. The line is colored red and green, with the red line being higher than the green line. The x-axis is labeled as z and the y-axis is labeled as z.](../images/imageFile248.png)

x

−5

0

5

10

θ

# 10.7.1 Example: The clutter problem

Following Minka (2001b), we illustrate the EP algorithm using a simple example in which the goal is to infer the mean θ of a multivariate Gaussian distribution over a variable x given a set of observations drawn from that distribution. To make the problem more interesting, the observations are embedded in background clutter, which itself is also Gaussian distributed, as illustrated in Figure 10.15. The distribution of observed values x is therefore a mixture of Gaussians, which we take to be of the form

$$
p ( x | \theta ) & = ( 1 - w ) \mathcal { N } ( x | \theta , I ) + w \mathcal { N } ( x | 0 , a I ) & ( 1 0 . 2 0 9 ) \\ \dot { \cdot } _ { \ } a I & = \dot { \cdot } _ { \ } a I - 1 &
$$

where w is the proportion of background clutter and is assumed to be known. The prior over θ is taken to be Gaussian

$$
p ( \theta ) = \mathcal { N } ( \theta | 0 , b I )
$$

and Minka (2001a) chooses the parameter values a = 10 , b = 100 and w = 0 . 5 . The joint distribution of N observations D = { x 1 ,..., x N } and θ is given by

$$
p ( \mathcal { D } , \theta ) = p ( \theta ) \prod _ { n = 1 } ^ { N } p ( x _ { n } | \theta )
$$

and so the posterior distribution comprises a mixture of 2 N Gaussians. Thus the computational cost of solving this problem exactly would grow exponentially with the size of the data set, and so an exact solution is intractable for moderately large N .

To apply EP to the clutter problem, we ﬁrst identify the factors f 0 ( θ ) = p ( θ ) and f n ( θ ) = p ( x n | θ ) . Next we select an approximating distribution from the exponential family, and for this example it is convenient to choose a spherical Gaussian

$$
q ( \theta ) = \mathcal { N } ( \theta | \mathbf m , v \mathbf I ) .
$$
