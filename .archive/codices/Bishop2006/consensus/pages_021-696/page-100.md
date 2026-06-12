[Page 100]

functional dependence of the Gaussian on $\mathbf{x}$ is through the quadratic form
$$
\Delta^2 = (\mathbf{x} - \boldsymbol{\mu})^T \boldsymbol{\Sigma}^{-1} (\mathbf{x} - \boldsymbol{\mu}) \tag{2.44}
$$
which appears in the exponent. The quantity $\Delta$ is called the Mahalanobis distance from $\boldsymbol{\mu}$ to $\mathbf{x}$ and reduces to the Euclidean distance when $\boldsymbol{\Sigma}$ is the identity matrix. The Gaussian distribution will be constant on surfaces in $\mathbf{x}$-space for which this quadratic form is constant.

First of all, we note that the matrix $\boldsymbol{\Sigma}$ can be taken to be symmetric, without loss of generality, because any antisymmetric component would disappear from the exponent. Now consider the eigenvector equation for the covariance matrix
$$
\boldsymbol{\Sigma} \mathbf{u}_i = \lambda_i \mathbf{u}_i \tag{2.45}
$$
where $i = 1, \ldots, D$. Because $\boldsymbol{\Sigma}$ is a real, symmetric matrix its eigenvalues will be real, and its eigenvectors can be chosen to form an orthonormal set, so that
$$
\mathbf{u}_i^T \mathbf{u}_j = I_{ij} \tag{2.46}
$$
where $I_{ij}$ is the $i,j$ element of the identity matrix and satisfies
$$
I_{ij} = \begin{cases} 1, & \text{if } i = j \\ 0, & \text{otherwise.} \end{cases} \tag{2.47}
$$

The covariance matrix $\boldsymbol{\Sigma}$ can be expressed as an expansion in terms of its eigenvectors in the form
$$
\boldsymbol{\Sigma} = \sum_{i=1}^D \lambda_i \mathbf{u}_i \mathbf{u}_i^T \tag{2.48}
$$
and similarly the inverse covariance matrix $\boldsymbol{\Sigma}^{-1}$ can be expressed as
$$
\boldsymbol{\Sigma}^{-1} = \sum_{i=1}^D \frac{1}{\lambda_i} \mathbf{u}_i \mathbf{u}_i^T . \tag{2.49}
$$

Substituting (2.49) into (2.44), the quadratic form becomes
$$
\Delta^2 = \sum_{i=1}^D \frac{y_i^2}{\lambda_i} \tag{2.50}
$$
where we have defined
$$
y_i = \mathbf{u}_i^T (\mathbf{x} - \boldsymbol{\mu}) . \tag{2.51}
$$

We can interpret $\{y_i\}$ as a new coordinate system defined by the orthonormal vectors $\mathbf{u}_i$ that are shifted and rotated with respect to the original $x_i$ coordinates. Forming the vector $\mathbf{y} = (y_1, \ldots, y_D)^T$, we have
$$
\mathbf{y} = \mathbf{U}(\mathbf{x} - \boldsymbol{\mu}) \tag{2.52}
$$
