[Page 112]

Similarly, we can ﬁnd the mean of the Gaussian distribution over $\mathbf{z}$ by identifying the linear terms in (2.102), which are given by

$$
\mathbf{x}^T\Lambda\boldsymbol{\mu} - \mathbf{x}^TA^TL\mathbf{b} + \mathbf{y}^TL\mathbf{b} = \begin{pmatrix} \mathbf{x} \\ \mathbf{y} \end{pmatrix}^T \begin{pmatrix} \Lambda\boldsymbol{\mu} - A^TL\mathbf{b} \\ L\mathbf{b} \end{pmatrix}. \tag{2.106}
$$

Using our earlier result (2.71) obtained by completing the square over the quadratic form of a multivariate Gaussian, we ﬁnd that the mean of $\mathbf{z}$ is given by

$$
\mathbb{E}[\mathbf{z}] = R^{-1}\begin{pmatrix} \Lambda\boldsymbol{\mu} - A^TL\mathbf{b} \\ L\mathbf{b} \end{pmatrix}. \tag{2.107}
$$

Making use of (2.105), we then obtain

$$
\mathbb{E}[\mathbf{z}] = \begin{pmatrix} \boldsymbol{\mu} \\ A\boldsymbol{\mu} + \mathbf{b} \end{pmatrix}. \tag{2.108}
$$

Next we ﬁnd an expression for the marginal distribution $p(\mathbf{y})$ in which we have marginalized over $\mathbf{x}$. Recall that the marginal distribution over a subset of the components of a Gaussian random vector takes a particularly simple form when expressed in terms of the partitioned covariance matrix. Speciﬁcally, its mean and covariance are given by (2.92) and (2.93), respectively. Making use of (2.105) and (2.108) we see that the mean and covariance of the marginal distribution $p(\mathbf{y})$ are given by

$$
\mathbb{E}[\mathbf{y}] = A\boldsymbol{\mu} + \mathbf{b} \tag{2.109}
$$

$$
\operatorname{cov}[\mathbf{y}] = L^{-1} + A\Lambda^{-1}A^T. \tag{2.110}
$$

A special case of this result is when $A = I$, in which case it reduces to the convolution of two Gaussians, for which we see that the mean of the convolution is the sum of the means of the two Gaussians, and the covariance of the convolution is the sum of their covariances.

Finally, we seek an expression for the conditional $p(\mathbf{x} \mid \mathbf{y})$. Recall that the results for the conditional distribution are most easily expressed in terms of the partitioned precision matrix, using (2.73) and (2.75). Applying these results to (2.105) and (2.108) we see that the conditional distribution $p(\mathbf{x} \mid \mathbf{y})$ has mean and covariance given by

$$
\mathbb{E}[\mathbf{x} \mid \mathbf{y}] = (\Lambda + A^TLA)^{-1}\left\{A^TL(\mathbf{y} - \mathbf{b}) + \Lambda\boldsymbol{\mu}\right\} \tag{2.111}
$$

$$
\operatorname{cov}[\mathbf{x} \mid \mathbf{y}] = (\Lambda + A^TLA)^{-1}. \tag{2.112}
$$

The evaluation of this conditional can be seen as an example of Bayes’ theorem. We can interpret the distribution $p(\mathbf{x})$ as a prior distribution over $\mathbf{x}$. If the variable $\mathbf{y}$ is observed, then the conditional distribution $p(\mathbf{x} \mid \mathbf{y})$ represents the corresponding posterior distribution over $\mathbf{x}$. Having found the marginal and conditional distributions, we have effectively expressed the joint distribution $p(\mathbf{z}) = p(\mathbf{x})p(\mathbf{y} \mid \mathbf{x})$ in the form $p(\mathbf{x} \mid \mathbf{y})p(\mathbf{y})$. These results are summarized below.
