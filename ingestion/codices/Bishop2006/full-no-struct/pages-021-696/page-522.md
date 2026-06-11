[Page 522]

![The image is a scatter plot with two axes. The x-axis is labeled x and the y-axis is labeled y. The plot is divided into two sections, each with a different color. The first section is colored red and contains 10 red dots, while the second section is colored blue and contains 10 blue dots. The dots in the first section are scattered around the x-axis, while the dots in the second section are scattered around the y-axis. The plot is drawn with a linear scale of range 0 to 2 on the x-axis, and a linear scale of range 0 to 6 on the y-axis. The dots in the first section are scattered around the x-axis, while the dots in the second section are scattered around the y-axis. The plot is labeled as scatter plot and has a title. The title is written in a bold, sans-serif font](../images/imageFile246.png)

6

6

4

4

2

2

0

0

0.99

0.75

0.25

0.01

−2

−2

−4

−4

-6

-6

-4

−2

0

2

4

-4

−2

0

2

4

Figure 10.13 Illustration of the Bayesian approach to logistic regression for a simple linearly separable data set. The plot on the left shows the predictive distribution obtained using variational inference. We see that the decision boundary lies roughly mid way between the clusters of data points, and that the contours of the predictive distribution splay out away from the data reﬂecting the greater uncertainty in the classiﬁcation of such regions. The plot on the right shows the decision boundaries corresponding to ﬁve samples of the parameter vector w drawn from the posterior distribution p ( w | t ) .

$$
\mathcal { L } ( \xi ) \ = \ \frac { 1 } { 2 } \ln \left | S _ { 1 } \right | - \frac { 1 } { 2 } m _ { N } ^ { T } S _ { N } ^ { - 1 } m _ { N } + \frac { 1 } { 2 } m _ { 0 } ^ { T } S _ { 0 } ^ { - 1 } m _ { 0 } \\ + \sum _ { n = 1 } ^ { N } \left \{ \ln \sigma ( \xi _ { n } ) - \frac { 1 } { 2 } \xi _ { n } - \lambda ( \xi _ { n } ) \xi _ { n } ^ { 2 } \right \} . \quad ( 1 0 . 1 6 ) \\ \intertext { This variational framework can also be applied to situations in which the data }
$$

This variational framework can also be applied to situations in which the data is arriving sequentially (Jaakkola and Jordan, 2000). In this case we maintain a Gaussian posterior distribution over w , which is initialized using the prior p ( w ) . As each data point arrives, the posterior is updated by making use of the bound (10.151) and then normalized to give an updated posterior distribution.

The predictive distribution is obtained by marginalizing over the posterior distribution, and takes the same form as for the Laplace approximation discussed in Section 4.5.2. Figure 10.13 shows the variational predictive distributions for a synthetic data set. This example provides interesting insights into the concept of ‘large margin’, which was discussed in Section 7.1 and which has qualitatively similar behaviour to the Bayesian solution.

# 10.6.3 Inference of hyperparameters

So far, we have treated the hyperparameter α in the prior distribution as a known constant. We now extend the Bayesian logistic regression model to allow the value of this parameter to be inferred from the data set. This can be achieved by combining the global and local variational approximations into a single framework, so as to maintain a lower bound on the marginal likelihood at each stage. Such a combined approach was adopted by Bishop and Svens´ en (2003) in the context of a Bayesian treatment of the hierarchical mixture of experts model.
