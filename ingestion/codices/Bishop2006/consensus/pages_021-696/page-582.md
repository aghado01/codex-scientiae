[Page 582]

chapter, we shall consider techniques to determine an appropriate value of $M$ from the data.

To begin with, consider the projection onto a one-dimensional space ($M = 1$). We can deﬁne the direction of this space using a $D$-dimensional vector $\mathbf{u}_1$, which for convenience (and without loss of generality) we shall choose to be a unit vector so that $\mathbf{u}_1^{\text{T}}\mathbf{u}_1 = 1$ (note that we are only interested in the direction deﬁned by $\mathbf{u}_1$, not in the magnitude of $\mathbf{u}_1$ itself). Each data point $\mathbf{x}_n$ is then projected onto a scalar value $\mathbf{u}_1^{\text{T}}\mathbf{x}_n$. The mean of the projected data is $\mathbf{u}_1^{\text{T}}\bar{\mathbf{x}}$ where $\bar{\mathbf{x}}$ is the sample set mean given by

$$
\bar{\mathbf{x}} = \frac{1}{N} \sum_{n=1}^N \mathbf{x}_n \tag{12.1}
$$

and the variance of the projected data is given by

$$
\frac{1}{N} \sum_{n=1}^N \{\mathbf{u}_1^{\text{T}}\mathbf{x}_n - \mathbf{u}_1^{\text{T}}\bar{\mathbf{x}}\}^2 = \mathbf{u}_1^{\text{T}}\mathbf{S}\mathbf{u}_1 \tag{12.2}
$$

where $\mathbf{S}$ is the data covariance matrix deﬁned by

$$
\mathbf{S} = \frac{1}{N} \sum_{n=1}^N (\mathbf{x}_n - \bar{\mathbf{x}})(\mathbf{x}_n - \bar{\mathbf{x}})^{\text{T}}. \tag{12.3}
$$

We now maximize the projected variance $\mathbf{u}_1^{\text{T}}\mathbf{S}\mathbf{u}_1$ with respect to $\mathbf{u}_1$. Clearly, this has to be a constrained maximization to prevent $\|\mathbf{u}_1\| \to \infty$. The appropriate constraint comes from the normalization condition $\mathbf{u}_1^{\text{T}}\mathbf{u}_1 = 1$. To enforce this constraint, we introduce a Lagrange multiplier that we shall denote by $\lambda_1$, and then make an unconstrained maximization of

$$
\mathbf{u}_1^{\text{T}}\mathbf{S}\mathbf{u}_1 + \lambda_1(1 - \mathbf{u}_1^{\text{T}}\mathbf{u}_1). \tag{12.4}
$$

By setting the derivative with respect to $\mathbf{u}_1$ equal to zero, we see that this quantity will have a stationary point when

$$
\mathbf{S}\mathbf{u}_1 = \lambda_1 \mathbf{u}_1 \tag{12.5}
$$

which says that $\mathbf{u}_1$ must be an eigenvector of $\mathbf{S}$. If we left-multiply by $\mathbf{u}_1^{\text{T}}$ and make use of $\mathbf{u}_1^{\text{T}}\mathbf{u}_1 = 1$, we see that the variance is given by

$$
\mathbf{u}_1^{\text{T}}\mathbf{S}\mathbf{u}_1 = \lambda_1 \tag{12.6}
$$

and so the variance will be a maximum when we set $\mathbf{u}_1$ equal to the eigenvector having the largest eigenvalue $\lambda_1$. This eigenvector is known as the ﬁrst principal component.

We can deﬁne additional principal components in an incremental fashion by choosing each new direction to be that which maximizes the projected variance
