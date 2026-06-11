[Page 522]

![image 246](../images/imageFile246.png)

Figure 10.13 Illustration of the Bayesian approach to logistic regression for a simple linearly separable data set. The plot on the left shows the predictive distribution obtained using variational inference. We see that the decision boundary lies roughly mid way between the clusters of data points, and that the contours of the predictive distribution splay out away from the data reﬂecting the greater uncertainty in the classiﬁcation of such regions. The plot on the right shows the decision boundaries corresponding to ﬁve samples of the parameter vector $\mathbf{w}$ drawn from the posterior distribution $p(\mathbf{w}|\mathbf{t})$.

$$
\begin{aligned}
\mathcal{L}(\boldsymbol{\xi}) &= \frac{1}{2} \ln |\mathbf{S}_N| - \frac{1}{2} \ln |\mathbf{S}_0| - \frac{1}{2} \mathbf{m}_N^{\text{T}}\mathbf{S}_N^{-1}\mathbf{m}_N + \frac{1}{2} \mathbf{m}_0^{\text{T}}\mathbf{S}_0^{-1}\mathbf{m}_0 \\
&\quad + \sum_{n=1}^N \left\{ \ln \sigma(\xi_n) - \frac{1}{2} \xi_n - \lambda(\xi_n)\xi_n^2 \right\}.
\end{aligned} \tag{10.164}
$$

This variational framework can also be applied to situations in which the data is arriving sequentially (Jaakkola and Jordan, 2000). In this case we maintain a Gaussian posterior distribution over $\mathbf{w}$, which is initialized using the prior $p(\mathbf{w})$. As each data point arrives, the posterior is updated by making use of the bound (10.151) and then normalized to give an updated posterior distribution.

The predictive distribution is obtained by marginalizing over the posterior distribution, and takes the same form as for the Laplace approximation discussed in Section 4.5.2. Figure 10.13 shows the variational predictive distributions for a synthetic data set. This example provides interesting insights into the concept of ‘large margin’, which was discussed in Section 7.1 and which has qualitatively similar behaviour to the Bayesian solution.

#### 10.6.3 Inference of hyperparameters

So far, we have treated the hyperparameter $\alpha$ in the prior distribution as a known constant. We now extend the Bayesian logistic regression model to allow the value of this parameter to be inferred from the data set. This can be achieved by combining the global and local variational approximations into a single framework, so as to maintain a lower bound on the marginal likelihood at each stage. Such a combined approach was adopted by Bishop and Svensén (2003) in the context of a Bayesian treatment of the hierarchical mixture of experts model.
