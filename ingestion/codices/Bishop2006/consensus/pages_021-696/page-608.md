[Page 608]

Substituting this expansion back into the eigenvector equation, we obtain

$$
\frac{1}{N} \sum_{n=1}^N \phi(\mathbf{x}_n)\phi(\mathbf{x}_n)^{\text{T}} \sum_{m=1}^N a_{im}\phi(\mathbf{x}_m) = \lambda_i \sum_{n=1}^N a_{in}\phi(\mathbf{x}_n). \tag{12.77}
$$

The key step is now to express this in terms of the kernel function $k(\mathbf{x}_n, \mathbf{x}_m) = \phi(\mathbf{x}_n)^{\text{T}}\phi(\mathbf{x}_m)$, which we do by multiplying both sides by $\phi(\mathbf{x}_l)^{\text{T}}$ to give

$$
\frac{1}{N} \sum_{n=1}^N k(\mathbf{x}_l, \mathbf{x}_n) \sum_{m=1}^N a_{im}k(\mathbf{x}_n, \mathbf{x}_m) = \lambda_i \sum_{n=1}^N a_{in}k(\mathbf{x}_l, \mathbf{x}_n). \tag{12.78}
$$

This can be written in matrix notation as

$$
\mathbf{K}^2\mathbf{a}_i = \lambda_i N \mathbf{K} \mathbf{a}_i \tag{12.79}
$$

where $\mathbf{a}_i$ is an $N$-dimensional column vector with elements $a_{in}$ for $n = 1, \dots, N$. We can ﬁnd solutions for $\mathbf{a}_i$ by solving the following eigenvalue problem

$$
\mathbf{K}\mathbf{a}_i = \lambda_i N \mathbf{a}_i \tag{12.80}
$$

in which we have removed a factor of $\mathbf{K}$ from both sides of (12.79). Note that the solutions of (12.79) and (12.80) differ only by eigenvectors of $\mathbf{K}$ having zero eigenvalues that do not affect the principal components projection.

The normalization condition for the coefﬁcients $a_{in}$ is obtained by requiring that the eigenvectors in feature space be normalized. Using (12.76) and (12.80), we have

$$
1 = \mathbf{v}_i^{\text{T}}\mathbf{v}_i = \sum_{n=1}^N \sum_{m=1}^N a_{in}a_{im}\phi(\mathbf{x}_n)^{\text{T}}\phi(\mathbf{x}_m) = \mathbf{a}_i^{\text{T}}\mathbf{K}\mathbf{a}_i = \lambda_i N \mathbf{a}_i^{\text{T}}\mathbf{a}_i. \tag{12.81}
$$

Having solved the eigenvector problem, the resulting principal component projections can then also be cast in terms of the kernel function so that, using (12.76), the projection of a point $\mathbf{x}$ onto eigenvector $i$ is given by

$$
y_i(\mathbf{x}) = \phi(\mathbf{x})^{\text{T}}\mathbf{v}_i = \sum_{n=1}^N a_{in}\phi(\mathbf{x})^{\text{T}}\phi(\mathbf{x}_n) = \sum_{n=1}^N a_{in}k(\mathbf{x}, \mathbf{x}_n) \tag{12.82}
$$

and so again is expressed in terms of the kernel function.

In the original $D$-dimensional $\mathbf{x}$ space there are $D$ orthogonal eigenvectors and hence we can ﬁnd at most $D$ linear principal components. The dimensionality $M$ of the feature space, however, can be much larger than $D$ (even inﬁnite), and thus we can ﬁnd a number of nonlinear principal components that can exceed $D$. Note, however, that the number of nonzero eigenvalues cannot exceed the number $N$ of data points, because (even if $M > N$) the covariance matrix in feature space has rank at most equal to $N$. This is reﬂected in the fact that kernel PCA involves the eigenvector expansion of the $N \times N$ matrix $\mathbf{K}$.
