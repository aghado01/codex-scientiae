[Page 231]

Figure 4.13 Schematic example of a probability density $p(\theta)$ shown by the blue curve, given in this example by a mixture of two Gaussians, along with its cumulative distribution function $f(a)$, shown by the red curve. Note that the value of the blue curve at any point, such as that indicated by the vertical green line, corresponds to the slope of the red curve at the same point. Conversely, the value of the red curve at this point corresponds to the area under the blue curve indicated by the shaded green region. In the stochastic threshold model, the class label takes the value $t = 1$ if the value of $a = \mathbf{w}^{\mathrm{T}}\boldsymbol{\phi}$ exceeds a threshold, otherwise it takes the value $t = 0$. This is equivalent to an activation function given by the cumulative distribution function $f(a)$.

![The image is a graph titled The Cumulative Frequency Distribution of a Sample. The graph shows the cumulative frequency distribution of a sample, which is a type of probability distribution where the frequency of each value is given. The graph is drawn with a light blue line and a red line. The x-axis represents the values of the sample, ranging from 0 to 4. The y-axis represents the cumulative frequency, ranging from 0 to 4. The cumulative frequency is a function of the values on the x-axis. The graph shows the following: 1. **Red Line**: - The red line starts at 0 and increases to 1. - It then decreases to 0.5. - It then increases to 0.5. - It then decreases to 0.5. - It then increases to 0.5. - It then decreases to 0.5. - It then increases](../images/imageFile104.png)

If the value of $\theta$ is drawn from a probability density $p(\theta)$, then the corresponding activation function will be given by the cumulative distribution function
$$
f(a) = \int_{-\infty}^{a} p(\theta) \, d\theta \tag{4.113}
$$
as illustrated in Figure 4.13.

As a specific example, suppose that the density $p(\theta)$ is given by a zero mean, unit variance Gaussian. The corresponding cumulative distribution function is given by
$$
\Phi(a) = \int_{-\infty}^{a} \mathcal{N}(\theta|0,1) \, d\theta \tag{4.114}
$$
which is known as the probit function. It has a sigmoidal shape and is compared with the logistic sigmoid function in Figure 4.9. Note that the use of a more general Gaussian distribution does not change the model because this is equivalent to a re-scaling of the linear coefficients $\mathbf{w}$. Many numerical packages provide for the evaluation of a closely related function defined by
$$
\text{erf}(a) = \frac{2}{\sqrt{\pi}} \int_{0}^{a} \exp(-\theta^2/2) \, d\theta \tag{4.115}
$$
and known as the erf function or error function (not to be confused with the error function of a machine learning model). It is related to the probit function by
$$
\Phi(a) = \frac{1}{2} \left\{ 1 + \frac{1}{\sqrt{2}} \text{erf}(a) \right\} . \tag{4.116}
$$

The generalized linear model based on a probit activation function is known as probit regression.

We can determine the parameters of this model using maximum likelihood, by a straightforward extension of the ideas discussed earlier. In practice, the results found using probit regression tend to be similar to those of logistic regression. We shall,
