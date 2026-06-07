[Page 607]

![Figure 12.16](../images/imageFile144.png)

Figure 12.16 Schematic illustration of kernel PCA. A data set in the original data space (left-hand plot) is projected by a nonlinear transformation $\phi(\mathbf{x})$ into a feature space (right-hand plot). By performing PCA in the feature space, we obtain the principal components, of which the ﬁrst is shown by the blue line. The green lines in feature space indicate the linear projections onto the ﬁrst principal component, which correspond to nonlinear projections in the original data space. Note that in general it is not possible to represent the linear principal component in feature space by a corresponding line in data space.

now perform standard PCA in the feature space, which implicitly deﬁnes a nonlinear principal component model in the original data space, as is illustrated in Figure 12.16.

For the moment, let us assume that the projected data set also has zero mean, so that $\sum_n \phi(\mathbf{x}_n) = \mathbf{0}$. We shall return to this point shortly. The $M \times M$ sample covariance matrix in feature space is given by

$$
\mathbf{C} = \frac{1}{N} \sum_{n=1}^N \phi(\mathbf{x}_n)\phi(\mathbf{x}_n)^{\text{T}} \tag{12.73}
$$

and its eigenvector expansion is deﬁned by

$$
\mathbf{C}\mathbf{v}_i = \lambda_i\mathbf{v}_i \tag{12.74}
$$

$i = 1, \dots, M$. Our goal is to solve this eigenvalue problem without having to work explicitly in the feature space. From the deﬁnition of $\mathbf{C}$, the eigenvector equations tell us that $\mathbf{v}_i$ satisﬁes

$$
\frac{1}{N} \sum_{n=1}^N \phi(\mathbf{x}_n)\{\phi(\mathbf{x}_n)^{\text{T}}\mathbf{v}_i\} = \lambda_i\mathbf{v}_i \tag{12.75}
$$

and so we see that (provided $\lambda_i > 0$) the vector $\mathbf{v}_i$ is given by a linear combination of the $\phi(\mathbf{x}_n)$ and so can be written in the form

$$
\mathbf{v}_i = \sum_{n=1}^N a_{in}\phi(\mathbf{x}_n). \tag{12.76}
$$
