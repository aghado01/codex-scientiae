[Page 583]

![Figure 12.2](../../../../../images/imageFile120.png)

amongst all possible directions orthogonal to those already considered. If we consider the general case of an $M$-dimensional projection space, the optimal linear projection for which the variance of the projected data is maximized is now deﬁned by the $M$ eigenvectors $\mathbf{u}_1, \dots, \mathbf{u}_M$ of the data covariance matrix $\mathbf{S}$ corresponding to the $M$ largest eigenvalues $\lambda_1, \dots, \lambda_M$. This is easily shown using proof by induction.

To summarize, principal component analysis involves evaluating the mean $\bar{\mathbf{x}}$ and the covariance matrix $\mathbf{S}$ of the data set and then ﬁnding the $M$ eigenvectors of $\mathbf{S}$ corresponding to the $M$ largest eigenvalues. Algorithms for ﬁnding eigenvectors and eigenvalues, as well as additional theorems related to eigenvector decomposition, can be found in Golub and Van Loan (1996). Note that the computational cost of computing the full eigenvector decomposition for a matrix of size $D \times D$ is $O(D^3)$. If we plan to project our data onto the ﬁrst $M$ principal components, then we only need to ﬁnd the ﬁrst $M$ eigenvalues and eigenvectors. This can be done with more efﬁcient techniques, such as the power method (Golub and Van Loan, 1996), that scale like $O(MD^2)$, or alternatively we can make use of the EM algorithm.

#### 12.1.2 Minimum-error formulation

We now discuss an alternative formulation of PCA based on projection error minimization. To do this, we introduce a complete orthonormal set of $D$-dimensional basis vectors $\{\mathbf{u}_i\}$ where $i = 1, \dots, D$ that satisfy

$$
\mathbf{u}_i^{\text{T}} \mathbf{u}_j = \delta_{ij}. \tag{12.7}
$$

Because this basis is complete, each data point can be represented exactly by a linear combination of the basis vectors

$$
\mathbf{x}_n = \sum_{i=1}^D \alpha_{ni} \mathbf{u}_i \tag{12.8}
$$

where the coefﬁcients $\alpha_{ni}$ will be different for different data points. This simply corresponds to a rotation of the coordinate system to a new system deﬁned by the $\{\mathbf{u}_i\}$, and the original $D$ components $\{x_{n1}, \dots, x_{nD}\}$ are replaced by an equivalent set $\{\alpha_{n1}, \dots, \alpha_{nD}\}$. Taking the inner product with $\mathbf{u}_j$, and making use of the orthonormality property, we obtain $\alpha_{nj} = \mathbf{x}_n^{\text{T}} \mathbf{u}_j$, and so without loss of generality we can write

$$
\mathbf{x}_n = \sum_{i=1}^D (\mathbf{x}_n^{\text{T}} \mathbf{u}_i) \mathbf{u}_i. \tag{12.9}
$$

Our goal, however, is to approximate this data point using a representation involving a restricted number $M < D$ of variables corresponding to a projection onto a lower-dimensional subspace. The $M$-dimensional linear subspace can be represented, without loss of generality, by the ﬁrst $M$ of the basis vectors, and so we approximate each data point $\mathbf{x}_n$ by

$$
\tilde{\mathbf{x}}_n = \sum_{i=1}^M z_{ni} \mathbf{u}_i + \sum_{i=M+1}^D b_i \mathbf{u}_i \tag{12.10}
$$
