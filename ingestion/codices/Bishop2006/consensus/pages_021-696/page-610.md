[Page 610]

![Figure 12.17](../images/imageFile147.png)

Figure 12.17 Example of kernel PCA, with a Gaussian kernel applied to a synthetic data set in two dimensions, showing the ﬁrst eight eigenfunctions along with their eigenvalues. The contours are lines along which the projection onto the corresponding principal component is constant. Note how the ﬁrst two eigenfunctions separate the three clusters, the next three eigenfunctions split each of the clusters into halves, and the following three eigenfunctions again split the clusters into halves along directions orthogonal to the previous splits.

One obvious disadvantage of kernel PCA is that it involves ﬁnding the eigenvectors of the $N \times N$ matrix $\widetilde{\mathbf{K}}$ rather than the $D \times D$ matrix $\mathbf{S}$ of conventional linear PCA, and so in practice for large data sets approximations are often used.

Finally, we note that in standard linear PCA, we often retain some reduced number $L < D$ of eigenvectors and then approximate a data vector $\mathbf{x}_n$ by its projection $\widehat{\mathbf{x}}_n$ onto the $L$-dimensional principal subspace, deﬁned by

$$
\widehat{\mathbf{x}}_n = \sum_{i=1}^L (\mathbf{x}_n^{\text{T}}\mathbf{u}_i)\mathbf{u}_i. \tag{12.88}
$$

In kernel PCA, this will in general not be possible. To see this, note that the mapping $\phi(\mathbf{x})$ maps the $D$-dimensional $\mathbf{x}$ space into a $D$-dimensional manifold in the $M$-dimensional feature space. The vector $\mathbf{x}$ is known as the pre-image of the corresponding point $\phi(\mathbf{x})$. However, the projection of points in feature space onto the linear PCA subspace in that space will typically not lie on the nonlinear $D$dimensional manifold and so will not have a corresponding pre-image in data space. Techniques have therefore been proposed for ﬁnding approximate pre-images (Bakir et al., 2004).
