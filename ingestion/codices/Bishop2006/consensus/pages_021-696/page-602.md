[Page 602]

![Figure 12.13](../images/imageFile139.png)

Figure 12.13 Probabilistic graphical model for Bayesian PCA in which the distribution over the parameter matrix $\mathbf{W}$ is governed by a vector $\boldsymbol{\alpha}$ of hyperparameters.

large and the corresponding posterior distribution is tightly peaked. It involves a speciﬁc choice of prior over $\mathbf{W}$ that allows surplus dimensions in the principal subspace to be pruned out of the model. This corresponds to an example of automatic relevance determination, or ARD, discussed in Section 7.2.2. Speciﬁcally, we deﬁne an independent Gaussian prior over each column of $\mathbf{W}$, which represent the vectors deﬁning the principal subspace. Each such Gaussian has an independent variance governed by a precision hyperparameter $\alpha_i$ so that

$$
p(\mathbf{W}|\boldsymbol{\alpha}) = \prod_{i=1}^M \left(\frac{\alpha_i}{2\pi}\right)^{D/2} \exp\left\{ -\frac{1}{2} \alpha_i \mathbf{w}_i^{\text{T}} \mathbf{w}_i \right\} \tag{12.60}
$$

where $\mathbf{w}_i$ is the $i^{\text{th}}$ column of $\mathbf{W}$. The resulting model can be represented using the directed graph shown in Figure 12.13.

The values for $\alpha_i$ will be found iteratively by maximizing the marginal likelihood function in which $\mathbf{W}$ has been integrated out. As a result of this optimization, some of the $\alpha_i$ may be driven to inﬁnity, with the corresponding parameters vector $\mathbf{w}_i$ being driven to zero (the posterior distribution becomes a delta function at the origin) giving a sparse solution. The effective dimensionality of the principal subspace is then determined by the number of ﬁnite $\alpha_i$ values, and the corresponding vectors $\mathbf{w}_i$ can be thought of as ‘relevant’ for modelling the data distribution. In this way, the Bayesian approach is automatically making the trade-off between improving the ﬁt to the data, by using a larger number of vectors $\mathbf{w}_i$ with their corresponding eigenvalues $\lambda_i$ each tuned to the data, and reducing the complexity of the model by suppressing some of the $\mathbf{w}_i$ vectors. The origins of this sparsity were discussed earlier in the context of relevance vector machines.

The values of $\alpha_i$ are re-estimated during training by maximizing the log marginal likelihood given by

$$
p(\mathbf{X}|\boldsymbol{\alpha}, \boldsymbol{\mu}, \sigma^2) = \int p(\mathbf{X}|\mathbf{W}, \boldsymbol{\mu}, \sigma^2) p(\mathbf{W}|\boldsymbol{\alpha}) \, \text{d}\mathbf{W} \tag{12.61}
$$

where the log of $p(\mathbf{X}|\mathbf{W}, \boldsymbol{\mu}, \sigma^2)$ is given by (12.43). Note that for simplicity we also treat $\boldsymbol{\mu}$ and $\sigma^2$ as parameters to be estimated, rather than deﬁning priors over these parameters.
