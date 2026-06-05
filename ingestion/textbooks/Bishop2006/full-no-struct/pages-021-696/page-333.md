[Page 333]

![The image is a line graph with two lines. The x-axis is labeled as time and the y-axis is labeled as energy. The graph shows a downward trend in energy consumption over time. The lines are colored green, red, and blue. ### Description of the Graph: 1. **X-Axis (Time)**: The x-axis is labeled as time and ranges from 0 to 1000. 2. **Y-Axis (Energy Consumption)**: The y-axis is labeled as energy and ranges from 0 to 1000. ### Analysis: - **Green Line**: The green line starts at a value of 1000 and decreases to 0 at the end of the graph. This indicates that the energy consumption is decreasing over time. - **Red Line**: The red line starts at a value of 1000 and decreases to 0](../images/imageFile140.png)

2

10 2

0

10 0

-2

10

-4

10

0

20

40

60

80

100

Gaussian noise. Values of x 2 are given by copying the corresponding values of x 1 and adding noise, and values of x 3 are sampled from an independent Gaussian distribution. Thus x 1 is a good predictor of t , x 2 is a more noisy predictor of t , and x 3 has only chance correlations with t . The marginal likelihood for a Gaussian process with ARD parameters η 1 ,η 2 ,η 3 is optimized using the scaled conjugate gradients algorithm. We see from Figure 6.10 that η 1 converges to a relatively large value, η 2 converges to a much smaller value, and η 3 becomes very small indicating that x 3 is irrelevant for predicting t .

The ARD framework is easily incorporated into the exponential-quadratic kernel (6.63) to give the following form of kernel function, which has been found useful for applications of Gaussian processes to a range of regression problems

$$
\text {applications of Gaussian processes to a range of regression problems} \\ k ( x _ { n } , x _ { m } ) = \theta _ { 0 } \exp \left \{ - \frac { 1 } { 2 } \sum _ { i = 1 } ^ { D } \eta _ { i } ( x _ { n i } - x _ { m i } ) ^ { 2 } \right \} + \theta _ { 2 } + \theta _ { 3 } \sum _ { i = 1 } ^ { D } x _ { n i } x _ { m i } \ \ ( 6 . 7 2 ) \\ \\ \text {where } D \text { is the dimensionality of the input space}
$$

where D is the dimensionality of the input space.

# 6.4.5 Gaussian processes for classiﬁcation

In a probabilistic approach to classiﬁcation, our goal is to model the posterior probabilities of the target variable for a new input vector, given a set of training data. These probabilities must lie in the interval (0 , 1) , whereas a Gaussian process model makes predictions that lie on the entire real axis. However, we can easily adapt Gaussian processes to classiﬁcation problems by transforming the output of the Gaussian process using an appropriate nonlinear activation function.

Consider ﬁrst the two-class problem with a target variable t ∈ { 0 , 1 } . If we deﬁne a Gaussian process over a function a ( x ) and then transform the function using a logistic sigmoid y = σ ( a ) , given by (4.59), then we will obtain a non-Gaussian stochastic process over functions y ( x ) where y ∈ (0 , 1) . This is illustrated for the case of a one-dimensional input space in Figure 6.11 in which the probability distri-
