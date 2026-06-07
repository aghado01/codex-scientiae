[Page 590]

dimensional centred data matrix, whose $n^{\text{th}}$ row is given by $(\mathbf{x}_n - \bar{\mathbf{x}})^{\text{T}}$. The covariance matrix (12.3) can then be written as $\mathbf{S} = N^{-1}\mathbf{X}^{\text{T}}\mathbf{X}$, and the corresponding eigenvector equation becomes

$$
\frac{1}{N} \mathbf{X}^{\text{T}} \mathbf{X} \mathbf{u}_i = \lambda_i \mathbf{u}_i. \tag{12.26}
$$

Now pre-multiply both sides by $\mathbf{X}$ to give

$$
\frac{1}{N} \mathbf{X} \mathbf{X}^{\text{T}} (\mathbf{X}\mathbf{u}_i) = \lambda_i (\mathbf{X}\mathbf{u}_i). \tag{12.27}
$$

If we now deﬁne $\mathbf{v}_i = \mathbf{X}\mathbf{u}_i$, we obtain

$$
\frac{1}{N} \mathbf{X} \mathbf{X}^{\text{T}} \mathbf{v}_i = \lambda_i \mathbf{v}_i \tag{12.28}
$$

which is an eigenvector equation for the $N \times N$ matrix $N^{-1}\mathbf{X}\mathbf{X}^{\text{T}}$. We see that this has the same $N - 1$ eigenvalues as the original covariance matrix (which itself has an additional $D - N + 1$ eigenvalues of value zero). Thus we can solve the eigenvector problem in spaces of lower dimensionality with computational cost $O(N^3)$ instead of $O(D^3)$. In order to determine the eigenvectors, we multiply both sides of (12.28) by $\mathbf{X}^{\text{T}}$ to give

$$
\left(\frac{1}{N} \mathbf{X}^{\text{T}} \mathbf{X}\right)(\mathbf{X}^{\text{T}}\mathbf{v}_i) = \lambda_i(\mathbf{X}^{\text{T}}\mathbf{v}_i) \tag{12.29}
$$

from which we see that $(\mathbf{X}^{\text{T}}\mathbf{v}_i)$ is an eigenvector of $\mathbf{S}$ with eigenvalue $\lambda_i$. Note, however, that these eigenvectors need not be normalized. To determine the appropriate normalization, we re-scale $\mathbf{u}_i \propto \mathbf{X}^{\text{T}}\mathbf{v}_i$ by a constant such that $\|\mathbf{u}_i\| = 1$, which, assuming $\mathbf{v}_i$ has been normalized to unit length, gives

$$
\mathbf{u}_i = \frac{1}{(N\lambda_i)^{1/2}} \mathbf{X}^{\text{T}} \mathbf{v}_i. \tag{12.30}
$$

In summary, to apply this approach we ﬁrst evaluate $\mathbf{X}\mathbf{X}^{\text{T}}$ and then ﬁnd its eigenvectors and eigenvalues and then compute the eigenvectors in the original data space using (12.30).

### 12.2. Probabilistic PCA

The formulation of PCA discussed in the previous section was based on a linear projection of the data onto a subspace of lower dimensionality than the original data space. We now show that PCA can also be expressed as the maximum likelihood solution of a probabilistic latent variable model. This reformulation of PCA, known as probabilistic PCA, brings several advantages compared with conventional PCA:

- Probabilistic PCA represents a constrained form of the Gaussian distribution in which the number of free parameters can be restricted while still allowing the model to capture the dominant correlations in a data set.
