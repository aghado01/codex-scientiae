[Page 326]

Figure 6.4 Samples from Gaussian processes for a ‘Gaussian’ kernel (left) and an exponential kernel (right).

![The image is a line graph that shows the trend of data over time. The x-axis represents the time in years, ranging from 0 to 1. The y-axis represents the values of the data, ranging from 0 to 1. The data is plotted with different colors, with blue representing the highest values and red representing the lowest values. The graph shows a general upward trend, with the highest values being around 1.5 and the lowest values being around -1.5. The data points are scattered throughout the graph, with some points being more spread out than others. The data points are not perfectly aligned, but they are generally in a consistent pattern. There are no specific labels or numbers on the graph, but the data points are clearly marked with a single point. The graph is not labeled, but it is clear that the data points are not just random points but are also scattered throughout the graph. ### Analysis and Description](../images/imageFile134.png)

3

3

1.5

1.5

0

0

−1.5

−1.5

-3

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

# 6.4.2 Gaussian processes for regression

In order to apply Gaussian process models to the problem of regression, we need to take account of the noise on the observed target values, which are given by

$$
t _ { n } = y _ { n } + \epsilon _ { n }
$$

where y n = y ( x n ) , and n is a random noise variable whose value is chosen independently for each observation n . Here we shall consider noise processes that have a Gaussian distribution, so that

$$
p ( t _ { n } | y _ { n } ) = \mathcal { N } ( t _ { n } | y _ { n } , \beta ^ { - 1 } )
$$

where β is a hyperparameter representing the precision of the noise. Because the noise is independent for each data point, the joint distribution of the target values t = ( t 1 ,...,t N ) T conditioned on the values of y = ( y 1 ,...,y N ) T is given by an isotropic Gaussian of the form

$$
p ( \mathbf t | \mathbf y ) = \mathcal { N } ( \mathbf t | \mathbf y , \beta ^ { - 1 } \mathbf I _ { N } )
$$

where I N denotes the N × N unit matrix. From the deﬁnition of a Gaussian process, the marginal distribution p ( y ) is given by a Gaussian whose mean is zero and whose covariance is deﬁned by a Gram matrix K so that

$$
p ( \mathbf y ) = \mathcal { N } ( \mathbf y | 0 , K ) .
$$

The kernel function that determines K is typically chosen to express the property that, for points x n and x m that are similar, the corresponding values y ( x n ) and y ( x m ) will be more strongly correlated than for dissimilar points. Here the notion of similarity will depend on the application.

In order to ﬁnd the marginal distribution p ( t ) , conditioned on the input values x 1 ,..., x N , we need to integrate over y . This can be done by making use of the results from Section 2.3.3 for the linear-Gaussian model. Using (2.115), we see that the marginal distribution of t is given by

$$
p ( \mathbf t ) = \int p ( \mathbf t | \mathbf y ) p ( \mathbf y ) \, \mathrm d \mathbf y = \mathcal { N } ( \mathbf t | 0 , C )
$$
