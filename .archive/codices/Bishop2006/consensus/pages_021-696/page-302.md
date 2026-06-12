[Page 302]

this framework that arise when it is applied to classiﬁcation. Here we shall consider a network having a single logistic sigmoid output corresponding to a two-class classiﬁcation problem. The extension to networks with multiclass softmax outputs

Exercise 5.40 is straightforward. We shall build extensively on the analogous results for linear classiﬁcation models discussed in Section 4.5, and so we encourage the reader to familiarize themselves with that material before studying this section.

The log likelihood function for this model is given by

$$
\ln p(\mathcal{D}|\mathbf{w}) = \sum_{n=1}^N \{t_n \ln y_n + (1 - t_n)\ln(1 - y_n)\} \tag{5.181}
$$

where $t_n \in \{0,1\}$ are the target values, and $y_n \equiv y(\mathbf{x}_n,\mathbf{w})$. Note that there is no hyperparameter $\beta$, because the data points are assumed to be correctly labelled. As before, the prior is taken to be an isotropic Gaussian of the form (5.162).

The ﬁrst stage in applying the Laplace framework to this model is to initialize the hyperparameter $\alpha$, and then to determine the parameter vector $\mathbf{w}$ by maximizing the log posterior distribution. This is equivalent to minimizing the regularized error function

$$
E(\mathbf{w}) = -\ln p(\mathcal{D}|\mathbf{w}) + \frac{\alpha}{2} \mathbf{w}^T\mathbf{w} \tag{5.182}
$$

and can be achieved using error backpropagation combined with standard optimization algorithms, as discussed in Section 5.3.

Having found a solution $\mathbf{w}_{\text{MAP}}$ for the weight vector, the next step is to evaluate the Hessian matrix $\mathbf{H}$ comprising the second derivatives of the negative log likelihood function. This can be done, for instance, using the exact method of Section 5.4.5, or using the outer product approximation given by (5.85). The second derivatives of the negative log posterior can again be written in the form (5.166), and the Gaussian approximation to the posterior is then given by (5.167).

To optimize the hyperparameter $\alpha$, we again maximize the marginal likelihood,

Exercise 5.41 which is easily shown to take the form

$$
\ln p(\mathcal{D}|\alpha) \simeq -E(\mathbf{w}_{\text{MAP}}) - \frac{1}{2} \ln |\mathbf{A}| + \frac{W}{2} \ln \alpha + \text{const} \tag{5.183}
$$

where the regularized error function is deﬁned by

$$
E(\mathbf{w}_{\text{MAP}}) = - \sum_{n=1}^N \{t_n \ln y_n + (1 - t_n)\ln(1 - y_n)\} + \frac{\alpha}{2} \mathbf{w}_{\text{MAP}}^T \mathbf{w}_{\text{MAP}} \tag{5.184}
$$

in which $y_n \equiv y(\mathbf{x}_n,\mathbf{w}_{\text{MAP}})$. Maximizing this evidence function with respect to $\alpha$ again leads to the re-estimation equation given by (5.178).

The use of the evidence procedure to determine $\alpha$ is illustrated in Figure 5.22 for the synthetic two-dimensional data discussed in Appendix A.

Finally, we need the predictive distribution, which is deﬁned by (5.168). Again, this integration is intractable due to the nonlinearity of the network function. The
