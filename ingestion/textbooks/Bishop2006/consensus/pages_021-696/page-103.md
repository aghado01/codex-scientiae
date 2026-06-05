[Page 103]

where again we have changed variables using $\mathbf{z} = \mathbf{x} - \boldsymbol{\mu}$. Note that the cross-terms involving $\boldsymbol{\mu}\mathbf{z}^T$ and $\mathbf{z}\boldsymbol{\mu}^T$ will again vanish by symmetry. The term $\boldsymbol{\mu}\boldsymbol{\mu}^T$ is constant and can be taken outside the integral, which itself is unity because the Gaussian distribution is normalized. Consider the term involving $\mathbf{z}\mathbf{z}^T$. Again, we can make use of the eigenvector expansion of the covariance matrix given by (2.45), together with the completeness of the set of eigenvectors, to write

$$
\mathbf{z} = \sum_{j=1}^{D} y_j \mathbf{u}_j \tag{2.60}
$$

where $y_j = \mathbf{u}_j^T \mathbf{z}$, which gives

$$
\frac{1}{(2\pi)^{D/2}} \frac{1}{|\Sigma|^{1/2}} \int \exp\left\{-\frac{1}{2}\mathbf{z}^T\Sigma^{-1}\mathbf{z}\right\} \mathbf{z}\mathbf{z}^T \, d\mathbf{z}
$$

$$
= \frac{1}{(2\pi)^{D/2}} \frac{1}{|\Sigma|^{1/2}} \sum_{i=1}^{D} \sum_{j=1}^{D} \mathbf{u}_i \mathbf{u}_j^T \int y_i y_j \prod_{k=1}^{D} \exp\left(-\frac{y_k^2}{2\lambda_k}\right) d\mathbf{y}
$$

$$
= \sum_{i=1}^{D} \lambda_i \mathbf{u}_i \mathbf{u}_i^T = \Sigma. \tag{2.61}
$$

where we have made use of the eigenvector equation (2.45), together with the fact that the integral on the right-hand side of the middle line vanishes by symmetry unless $i = j$, and in the ﬁnal line we have made use of the results (1.50) and (2.55), together with (2.48). Thus we have

$$
\mathbb{E}[\mathbf{x}\mathbf{x}^T] = \boldsymbol{\mu}\boldsymbol{\mu}^T + \Sigma. \tag{2.62}
$$

For single random variables, we subtracted the mean before taking second moments in order to deﬁne a variance. Similarly, in the multivariate case it is again convenient to subtract off the mean, giving rise to the covariance of a random vector $\mathbf{x}$ deﬁned by

$$
\operatorname{cov}[\mathbf{x}] = \mathbb{E}\left[(\mathbf{x} - \mathbb{E}[\mathbf{x}])(\mathbf{x} - \mathbb{E}[\mathbf{x}])^T\right]. \tag{2.63}
$$

For the speciﬁc case of a Gaussian distribution, we can make use of $\mathbb{E}[\mathbf{x}] = \boldsymbol{\mu}$, together with the result (2.62), to give

$$
\operatorname{cov}[\mathbf{x}] = \Sigma. \tag{2.64}
$$

Because the parameter matrix $\Sigma$ governs the covariance of $\mathbf{x}$ under the Gaussian distribution, it is called the covariance matrix.

Although the Gaussian distribution (2.43) is widely used as a density model, it suffers from some signiﬁcant limitations. Consider the number of free parameters in the distribution. A general symmetric covariance matrix $\Sigma$ will have $D(D + 1)/2$ independent parameters, and there are another $D$ independent parameters in $\boldsymbol{\mu}$, giving $D(D + 3)/2$ parameters in total. For large $D$, the total number of parameters
