[Page 178]

![The image is a scatter plot with four different sets of data points. Each set of data points is represented by a different color, and the x-axis is labeled t, while the y-axis is labeled t. The data points are represented by red dots, and each data point is represented by a different color. The x-axis is labeled t, and the y-axis is labeled t. The data points are scattered around the x-axis, with some points closer to the x-axis and others farther away. The data points are scattered in a random pattern, with no clear pattern or pattern.](../images/imageFile81.png)

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

Figure 3.9 Plots of the function y ( x, w ) using samples from the posterior distributions over w corresponding to the plots in Figure 3.8.

Section 6.4

Exercise 3.12

Exercise 3.13

If we used localized basis functions such as Gaussians, then in regions away from the basis function centres, the contribution from the second term in the predictive variance (3.59) will go to zero, leaving only the noise contribution β − 1 . Thus, the model becomes very conﬁdent in its predictions when extrapolating outside the region occupied by the basis functions, which is generally an undesirable behaviour. This problem can be avoided by adopting an alternative Bayesian approach to regression known as a Gaussian process.

Note that, if both w and β are treated as unknown, then we can introduce a conjugate prior distribution p ( w ,β ) that, from the discussion in Section 2.3.6, will be given by a Gaussian-gamma distribution (Denison et al. , 2002). In this case, the predictive distribution is a Student’s t-distribution.
