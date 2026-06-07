[Page 171]

Figure 3.6 Plot of squared bias and variance, together with their sum, corresponding to the results shown in Figure 3.5. Also shown is the average test set error for a test data set size of 1000 points. The minimum value of $(\text{bias})^2 + \text{variance}$ occurs around $\ln \lambda = -0.31$, which is close to the value that gives the minimum error on the test data.

![The image is a graph titled Ln A. The graph is a line graph with three lines, each representing different variables. The x-axis is labeled ln(\gamma) and the y-axis is labeled ln(\gamma). The graph is titled Ln A and has a legend at the bottom of the graph that indicates the following: - The blue line represents bias - The red line represents variance - The pink line represents test error The graph has a scale from 0.03 to 0.15 on the y-axis, labeled ln(\gamma) and ln(\gamma). The x-axis is labeled ln(\gamma) and has a scale from -3 to 1. The graph has three lines: 1. The blue line represents bias 2. The red line represents variance](../images/imageFile78.png)

fit a model with 24 Gaussian basis functions by minimizing the regularized error function (3.27) to give a prediction function $y^{(l)}(x)$ as shown in Figure 3.5. The top row corresponds to a large value of the regularization coefficient $\lambda$ that gives low variance (because the red curves in the left plot look similar) but high bias (because the two curves in the right plot are very different). Conversely on the bottom row, for which $\lambda$ is small, there is large variance (shown by the high variability between the red curves in the left plot) but low bias (shown by the good fit between the average model fit and the original sinusoidal function). Note that the result of averaging many solutions for the complex model with $M = 25$ is a very good fit to the regression function, which suggests that averaging may be a beneficial procedure. Indeed, a weighted averaging of multiple solutions lies at the heart of a Bayesian approach, although the averaging is with respect to the posterior distribution of parameters, not with respect to multiple data sets.

We can also examine the bias-variance trade-off quantitatively for this example. The average prediction is estimated from

$$
\bar{y}(x) = \frac{1}{L} \sum_{l=1}^{L} y^{(l)}(x) \tag{3.45}
$$

and the integrated squared bias and integrated variance are then given by

$$
(\text{bias})^2 = \frac{1}{N} \sum_{n=1}^{N} \{\bar{y}(x_n) - h(x_n)\}^2 \tag{3.46}
$$

$$
\text{variance} = \frac{1}{N} \sum_{n=1}^{N} \frac{1}{L} \sum_{l=1}^{L} \{y^{(l)}(x_n) - \bar{y}(x_n)\}^2 \tag{3.47}
$$

where the integral over $x$ weighted by the distribution $p(x)$ is approximated by a finite sum over data points drawn from that distribution. These quantities, along with their sum, are plotted as a function of $\ln \lambda$ in Figure 3.6. We see that small values of $\lambda$ allow the model to become finely tuned to the noise on each individual
