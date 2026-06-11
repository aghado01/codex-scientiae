[Page 178]

![The image is a scatter plot with four different sets of data points. Each set of data points is represented by a different color, and the x-axis is labeled t, while the y-axis is labeled t. The data points are represented by red dots, and each data point is represented by a different color. The x-axis is labeled t, and the y-axis is labeled t. The data points are scattered around the x-axis, with some points closer to the x-axis and others farther away. The data points are scattered in a random pattern, with no clear pattern or pattern.](../images/imageFile81.png)

Figure 3.9 Plots of the function $y(x, \mathbf{w})$ using samples from the posterior distributions over $\mathbf{w}$ corresponding to the plots in Figure 3.8.

If we used localized basis functions such as Gaussians, then in regions away from the basis function centres, the contribution from the second term in the predictive variance (3.59) will go to zero, leaving only the noise contribution $\beta^{-1}$. Thus, the model becomes very confident in its predictions when extrapolating outside the region occupied by the basis functions, which is generally an undesirable behaviour. This problem can be avoided by adopting an alternative Bayesian approach to regression known as a Gaussian process.

Note that, if both $\mathbf{w}$ and $\beta$ are treated as unknown, then we can introduce a conjugate prior distribution $p(\mathbf{w}, \beta)$ that, from the discussion in Section 2.3.6, will be given by a Gaussian-gamma distribution (Denison et al., 2002). In this case, the predictive distribution is a Student's t-distribution.
