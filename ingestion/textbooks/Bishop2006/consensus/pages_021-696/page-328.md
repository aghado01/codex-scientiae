[Page 328]

Figure 6.5 Samples from a Gaussian process prior deﬁned by the covariance function (6.63). The title above each plot denotes $(\theta_0, \theta_1, \theta_2, \theta_3)$.

![The image is a scatter plot with four different colors and four different lines. The x-axis is labeled as 1, the y-axis is labeled as 1, and the points are represented by the colors blue, red, green, and orange. The points are scattered across the graph, with each color representing a different type of data point. The lines are also colored differently, with blue representing a linear trend, red representing a non-linear trend, green representing a non-linear trend, and orange representing a non-linear trend. The scatter plot is titled 1,00, 4,00, 0,00, 0,00. The title is written in a bold, sans-serif font. The scatter plot is visually represented with four different lines, each represented by a different color. The lines are colored in blue, red, green, and orange. The blue line is represented by the color 1](../images/imageFile135.png)

$c = k(\mathbf{x}_{N+1},\mathbf{x}_{N+1})+\beta^{-1}$. Using the results (2.81) and (2.82), we see that the conditional distribution $p(t_{N+1}|\mathbf{t})$ is a Gaussian distribution with mean and covariance given by

$$
m(\mathbf{x}_{N+1}) = \mathbf{k}^T\mathbf{C}_N^{-1}\mathbf{t} \tag{6.66}
$$

$$
\sigma^2(\mathbf{x}_{N+1}) = c - \mathbf{k}^T\mathbf{C}_N^{-1}\mathbf{k}. \tag{6.67}
$$

These are the key results that deﬁne Gaussian process regression. Because the vector $\mathbf{k}$ is a function of the test point input value $\mathbf{x}_{N+1}$, we see that the predictive distribution is a Gaussian whose mean and variance both depend on $\mathbf{x}_{N+1}$. An example of Gaussian process regression is shown in Figure 6.8.

The only restriction on the kernel function is that the covariance matrix given by (6.62) must be positive deﬁnite. If $\lambda_i$ is an eigenvalue of $\mathbf{K}$, then the corresponding eigenvalue of $\mathbf{C}$ will be $\lambda_i + \beta^{-1}$. It is therefore sufﬁcient that the kernel matrix $k(\mathbf{x}_n,\mathbf{x}_m)$ be positive semideﬁnite for any pair of points $\mathbf{x}_n$ and $\mathbf{x}_m$, so that $\lambda_i \ge 0$, because any eigenvalue $\lambda_i$ that is zero will still give rise to a positive eigenvalue for $\mathbf{C}$ because $\beta > 0$. This is the same restriction on the kernel function discussed earlier, and so we can again exploit all of the techniques in Section 6.2 to construct
