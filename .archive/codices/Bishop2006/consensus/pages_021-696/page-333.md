[Page 333]

Figure 6.10 Illustration of automatic relevance determination in a Gaussian process for a synthetic problem having three inputs $x_1$, $x_2$, and $x_3$, for which the curves show the corresponding values of the hyperparameters $\eta_1$ (red), $\eta_2$ (green), and $\eta_3$ (blue) as a function of the number of iterations when optimizing the marginal likelihood. Details are given in the text. Note the logarithmic scale on the vertical axis.

![The image is a line graph with two lines. The x-axis is labeled as time and the y-axis is labeled as energy. The graph shows a downward trend in energy consumption over time. The lines are colored green, red, and blue. ### Description of the Graph: 1. **X-Axis (Time)**: The x-axis is labeled as time and ranges from 0 to 1000. 2. **Y-Axis (Energy Consumption)**: The y-axis is labeled as energy and ranges from 0 to 1000. ### Analysis: - **Green Line**: The green line starts at a value of 1000 and decreases to 0 at the end of the graph. This indicates that the energy consumption is decreasing over time. - **Red Line**: The red line starts at a value of 1000 and decreases to 0](../images/imageFile140.png)

Gaussian noise. Values of $x_2$ are given by copying the corresponding values of $x_1$ and adding noise, and values of $x_3$ are sampled from an independent Gaussian distribution. Thus $x_1$ is a good predictor of $t$, $x_2$ is a more noisy predictor of $t$, and $x_3$ has only chance correlations with $t$. The marginal likelihood for a Gaussian process with ARD parameters $\eta_1,\eta_2,\eta_3$ is optimized using the scaled conjugate gradients algorithm. We see from Figure 6.10 that $\eta_1$ converges to a relatively large value, $\eta_2$ converges to a much smaller value, and $\eta_3$ becomes very small indicating that $x_3$ is irrelevant for predicting $t$.

The ARD framework is easily incorporated into the exponential-quadratic kernel (6.63) to give the following form of kernel function, which has been found useful for applications of Gaussian processes to a range of regression problems

$$
k(\mathbf{x}_n,\mathbf{x}_m) = \theta_0 \exp\left\{ -\frac{1}{2} \sum_{i=1}^D \eta_i(x_{ni} - x_{mi})^2 \right\} + \theta_2 + \theta_3 \sum_{i=1}^D x_{ni}x_{mi} \tag{6.72}
$$

where $D$ is the dimensionality of the input space.

###### 6.4.5 Gaussian processes for classiﬁcation

In a probabilistic approach to classiﬁcation, our goal is to model the posterior probabilities of the target variable for a new input vector, given a set of training data. These probabilities must lie in the interval $(0,1)$, whereas a Gaussian process model makes predictions that lie on the entire real axis. However, we can easily adapt Gaussian processes to classiﬁcation problems by transforming the output of the Gaussian process using an appropriate nonlinear activation function.

Consider ﬁrst the two-class problem with a target variable $t \in \{0,1\}$. If we deﬁne a Gaussian process over a function $a(\mathbf{x})$ and then transform the function using a logistic sigmoid $y = \sigma(a)$, given by (4.59), then we will obtain a non-Gaussian stochastic process over functions $y(\mathbf{x})$ where $y \in (0,1)$. This is illustrated for the case of a one-dimensional input space in Figure 6.11 in which the probability distri-
