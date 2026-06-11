[Page 601]

![Figure 12.12](../images/imageFile138.png)

Figure 12.12 Synthetic data illustrating the EM algorithm for PCA deﬁned by (12.58) and (12.59). (a) A data set $\mathbf{X}$ with the data points shown in green, together with the true principal components (shown as eigenvectors scaled by the square roots of the eigenvalues). (b) Initial conﬁguration of the principal subspace deﬁned by $\mathbf{W}$, shown in red, together with the projections of the latent points $\mathbf{Z}$ into the data space, given by $\mathbf{Z}\mathbf{W}^{\text{T}}$, shown in cyan. (c) After one M step, the latent space has been updated with $\mathbf{Z}$ held ﬁxed. (d) After the successive E step, the values of $\mathbf{Z}$ have been updated, given by orthogonal projections, with $\mathbf{W}$ held ﬁxed. (e) After the second M step. (f) After the second E step.

Because the probabilistic PCA model has a well-deﬁned likelihood function, we could employ cross-validation to determine the value of dimensionality by selecting the largest log likelihood on a validation data set. Such an approach, however, can become computationally costly, particularly if we consider a probabilistic mixture of PCA models (Tipping and Bishop, 1999a) in which we seek to determine the appropriate dimensionality separately for each component in the mixture.

Given that we have a probabilistic formulation of PCA, it seems natural to seek a Bayesian approach to model selection. To do this, we need to marginalize out the model parameters $\boldsymbol{\mu}$, $\mathbf{W}$, and $\sigma^2$ with respect to appropriate prior distributions. This can be done by using a variational framework to approximate the analytically intractable marginalizations (Bishop, 1999b). The marginal likelihood values, given by the variational lower bound, can then be computed for a range of different values of $M$, and the value giving the largest marginal likelihood selected.

Here we consider a simpler approach introduced by Bishop (1999a) based on the evidence approximation, which is appropriate when the number of data points is relatively
