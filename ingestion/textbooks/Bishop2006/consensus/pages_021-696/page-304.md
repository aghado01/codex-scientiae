[Page 304]

![The image consists of two parallel graphs, each with a blue line and a red line. The x-axis is labeled as days and the y-axis is labeled as total number of people. The graph on the left shows a pattern of the number of people over time, while the graph on the right shows a pattern of the number of people over time. The blue line on the left graph is a straight line with a positive slope, indicating that the number of people increases over time. The red line on the right graph is a straight line with a negative slope, indicating that the number of people decreases over time. The graph on the left has a larger number of people than the graph on the right. This is because the blue line on the left is more curved, which means it is more likely to be a straight line. The red line on the right is more curved, which means it is more likely to be a straight line. The graph](../images/imageFile129.png)

Figure 5.23 An illustration of the Laplace approximation for a Bayesian neural network having 8 hidden units with ‘tanh’ activation functions and a single logistic-sigmoid output unit. The weight parameters were found using scaled conjugate gradients, and the hyperparameter $\alpha$ was optimized using the evidence framework. On the left is the result of using the simple approximation (5.185) based on a point estimate $\mathbf{w}_{\text{MAP}}$ of the parameters, in which the green curve shows the $y = 0.5$ decision boundary, and the other contours correspond to output probabilities of $y = 0.1$, $0.3$, $0.7$, and $0.9$. On the right is the corresponding result obtained using (5.190). Note that the effect of marginalization is to spread out the contours and to make the predictions less conﬁdent, so that at each input point $\mathbf{x}$, the posterior probabilities are shifted towards $0.5$, while the $y = 0.5$ contour itself is unaffected.

The convolution of a Gaussian with a logistic sigmoid is intractable. We therefore apply the approximation (4.153) to (5.189) giving

$$
p(t = 1|\mathbf{x},\mathcal{D}) = \sigma \left( \kappa(\sigma_a^2) \mathbf{b}^T \mathbf{w}_{\text{MAP}} \right) \tag{5.190}
$$

where $\kappa(\cdot)$ is deﬁned by (4.154). Recall that both $\sigma_a^2$ and $\mathbf{b}$ are functions of $\mathbf{x}$. Figure 5.23 shows an example of this framework applied to the synthetic classiﬁcation data set described in Appendix A.

### Exercises

5.1 ( $\star$ ) Consider a two-layer network function of the form (5.7) in which the hiddenunit nonlinear activation functions $g(\cdot)$ are given by logistic sigmoid functions of the form

$$
\sigma(a) = \{1 + \exp(-a)\}^{-1}. \tag{5.191}
$$

Show that there exists an equivalent network, which computes exactly the same function, but with hidden unit activation functions given by $\tanh(a)$ where the $\tanh$ function is deﬁned by (5.59). Hint: ﬁrst ﬁnd the relation between $\sigma(a)$ and $\tanh(a)$, and then show that the parameters of the two networks differ by linear transformations.

5.2 ( $\star$ ) www Show that maximizing the likelihood function under the conditional distribution (5.16) for a multioutput neural network is equivalent to minimizing the sum-of-squares error function (5.11).
