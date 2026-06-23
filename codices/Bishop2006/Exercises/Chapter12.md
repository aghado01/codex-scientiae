# Chapter 12 Exercises

[Page 619]


## 12.1 PCA variance maximization induction ($\star\star$)

In this exercise, we use proof by induction to show that the linear projection onto an $M$-dimensional subspace that maximizes the variance of the projected data is defined by the $M$ eigenvectors of the data covariance matrix $\mathbf{S}$, given by (12.3), corresponding to the $M$ largest eigenvalues. In Section 12.1, this result was proven for the case of $M = 1$. Now suppose the result holds for some general value of $M$ and show that it consequently holds for dimensionality $M + 1$. To do this, first set the derivative of the variance of the projected data with respect to a vector $\mathbf{u}_{M+1}$ defining the new direction in data space equal to zero. This should be done subject to the constraints that $\mathbf{u}_{M+1}$ be orthogonal to the existing vectors $\mathbf{u}_1, \dots, \mathbf{u}_M$, and also that it be normalized to unit length. Use Lagrange multipliers to enforce these constraints. Then make use of the orthonormality properties of the vectors $\mathbf{u}_1, \dots, \mathbf{u}_M$ to show that the new vector $\mathbf{u}_{M+1}$ is an eigenvector of $\mathbf{S}$. Finally, show that the variance is maximized if the eigenvector is chosen to be the one corresponding to eigenvector $\lambda_{M+1}$ where the eigenvalues have been ordered in decreasing value.

## 12.2 Minimizing PCA distortion measure ($\star\star$)

Show that the minimum value of the PCA distortion measure $J$ given by (12.15) with respect to the $\mathbf{u}_i$, subject to the orthonormality constraints (12.7), is obtained when the $\mathbf{u}_i$ are eigenvectors of the data covariance matrix $\mathbf{S}$. To do this, introduce a matrix $\mathbf{H}$ of Lagrange multipliers, one for each constraint, so that the modified distortion measure, in matrix notation reads

$$
\widetilde{J} = \text{Tr}\{\widetilde{\mathbf{U}}^{\text{T}}\mathbf{S}\widetilde{\mathbf{U}}\} + \text{Tr}\{\mathbf{H}(\mathbf{I} - \widetilde{\mathbf{U}}^{\text{T}}\widetilde{\mathbf{U}})\} \tag{12.93}
$$

where $\widetilde{\mathbf{U}}$ is a matrix of dimensionality $D \times (D - M)$ whose columns are given by $\mathbf{u}_i$. Now minimize $\widetilde{J}$ with respect to $\widetilde{\mathbf{U}}$ and show that the solution satisfies $\mathbf{S}\widetilde{\mathbf{U}} = \widetilde{\mathbf{U}}\mathbf{H}$. Clearly, one possible solution is that the columns of $\widetilde{\mathbf{U}}$ are eigenvectors of $\mathbf{S}$, in which case $\mathbf{H}$ is a diagonal matrix containing the corresponding eigenvalues. To obtain the general solution, show that $\mathbf{H}$ can be assumed to be a symmetric matrix, and by using its eigenvector expansion show that the general solution to $\mathbf{S}\widetilde{\mathbf{U}} = \widetilde{\mathbf{U}}\mathbf{H}$ gives the same value for $\widetilde{J}$ as the specific solution in which the columns of $\widetilde{\mathbf{U}}$ are
[Page 620]

the eigenvectors of $\mathbf{S}$. Because these solutions are all equivalent, it is convenient to choose the eigenvector solution.

## 12.3 Unit length of PCA eigenvectors ($\star$)

Verify that the eigenvectors defined by (12.30) are normalized to unit length, assuming that the eigenvectors $\mathbf{v}_i$ have unit length.

## 12.4 General Gaussian latent space ($\star$)

Suppose we replace the zero-mean, unit-covariance latent space distribution (12.31) in the probabilistic PCA model by a general Gaussian distribution of the form $\mathcal{N}(\mathbf{z}|\mathbf{m}, \mathbf{\Sigma})$. By redefining the parameters of the model, show that this leads to an identical model for the marginal distribution $p(\mathbf{x})$ over the observed variables for any valid choice of $\mathbf{m}$ and $\mathbf{\Sigma}$.

## 12.5 Affine transformation of Gaussian ($\star\star$)

Let $\mathbf{x}$ be a $D$-dimensional random variable having a Gaussian distribution given by $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu}, \mathbf{\Sigma})$, and consider the $M$-dimensional random variable given by $\mathbf{y} = \mathbf{A}\mathbf{x} + \mathbf{b}$ where $\mathbf{A}$ is an $M \times D$ matrix. Show that $\mathbf{y}$ also has a Gaussian distribution, and find expressions for its mean and covariance. Discuss the form of this Gaussian distribution for $M < D$, for $M = D$, and for $M > D$.

## 12.6 Probabilistic PCA independence structure ($\star$)

Draw a directed probabilistic graph for the probabilistic PCA model described in Section 12.2 in which the components of the observed variable $\mathbf{x}$ are shown explicitly as separate nodes. Hence verify that the probabilistic PCA model has the same independence structure as the naive Bayes model discussed in Section 8.2.2.

## 12.7 Probabilistic PCA marginal distribution ($\star\star$)

By making use of the results (2.270) and (2.271) for the mean and covariance of a general distribution, derive the result (12.35) for the marginal distribution $p(\mathbf{x})$ in the probabilistic PCA model.

## 12.8 Probabilistic PCA posterior distribution ($\star\star$)

By making use of the result (2.116), show that the posterior distribution $p(\mathbf{z}|\mathbf{x})$ for the probabilistic PCA model is given by (12.42).

## 12.9 Maximum likelihood mean in PPCA ($\star$)

Verify that maximizing the log likelihood (12.43) for the probabilistic PCA model with respect to the parameter $\boldsymbol{\mu}$ gives the result $\boldsymbol{\mu}_{\text{ML}} = \bar{\mathbf{x}}$ where $\bar{\mathbf{x}}$ is the mean of the data vectors.

## 12.10 Unique maximum for PPCA mean ($\star\star$)

By evaluating the second derivatives of the log likelihood function (12.43) for the probabilistic PCA model with respect to the parameter $\boldsymbol{\mu}$, show that the stationary point $\boldsymbol{\mu}_{\text{ML}} = \bar{\mathbf{x}}$ represents the unique maximum.

## 12.11 Zero variance limit of PPCA ($\star\star$)

Show that in the limit $\sigma^2 \to 0$, the posterior mean for the probabilistic PCA model becomes an orthogonal projection onto the principal subspace, as in conventional PCA.

## 12.12 Posterior mean shrinkage in PPCA ($\star\star$)

For $\sigma^2 > 0$ show that the posterior mean in the probabilistic PCA model is shifted towards the origin relative to the orthogonal projection.

## 12.13 Least squares reconstruction in PPCA ($\star\star$)

Show that the optimal reconstruction of a data point under probabilistic PCA, according to the least squares projection cost of conventional PCA, is given by

$$
\widetilde{\mathbf{x}} = \mathbf{W}_{\text{ML}}(\mathbf{W}_{\text{ML}}^{\text{T}}\mathbf{W}_{\text{ML}})^{-1}\mathbf{M}\mathbb{E}[\mathbf{z}|\mathbf{x}]. \tag{12.94}
$$
[Page 621]

## 12.14 Independent parameters in PPCA ($\star$)

The number of independent parameters in the covariance matrix for the probabilistic PCA model with an $M$-dimensional latent space and a $D$-dimensional data space is given by (12.51). Verify that in the case of $M = D - 1$, the number of independent parameters is the same as in a general covariance Gaussian, whereas for $M = 0$ it is the same as for a Gaussian with an isotropic covariance.

## 12.15 EM algorithm for probabilistic PCA ($\star\star$)

Derive the M-step equations (12.56) and (12.57) for the probabilistic PCA model by maximization of the expected complete-data log likelihood function given by (12.53).

## 12.16 PPCA with missing data values ($\star\star\star$)

In Figure 12.11, we showed an application of probabilistic PCA to a data set in which some of the data values were missing at random. Derive the EM algorithm for maximizing the likelihood function for the probabilistic PCA model in this situation. Note that the $\{\mathbf{z}_n\}$, as well as the missing data values that are components of the vectors $\{\mathbf{x}_n\}$, are now latent variables. Show that in the special case in which all of the data values are observed, this reduces to the EM algorithm for probabilistic PCA derived in Section 12.2.2.

## 12.17 Minimizing sum-of-squares reconstruction cost ($\star\star$)

Let $\mathbf{W}$ be a $D \times M$ matrix whose columns define a linear subspace of dimensionality $M$ embedded within a data space of dimensionality $D$, and let $\boldsymbol{\mu}$ be a $D$-dimensional vector. Given a data set $\{\mathbf{x}_n\}$ where $n = 1, \dots, N$, we can approximate the data points using a linear mapping from a set of $M$-dimensional vectors $\{\mathbf{z}_n\}$, so that $\mathbf{x}_n$ is approximated by $\mathbf{W} \mathbf{z}_n + \boldsymbol{\mu}$. The associated sum-of-squares reconstruction cost is given by

$$
J = \sum_{n=1}^N \|\mathbf{x}_n - \boldsymbol{\mu} - \mathbf{W}\mathbf{z}_n\|^2. \tag{12.95}
$$

First show that minimizing $J$ with respect to $\boldsymbol{\mu}$ leads to an analogous expression with $\mathbf{x}_n$ and $\mathbf{z}_n$ replaced by zero-mean variables $\mathbf{x}_n - \bar{\mathbf{x}}$ and $\mathbf{z}_n - \bar{\mathbf{z}}$, respectively, where $\bar{\mathbf{x}}$ and $\bar{\mathbf{z}}$ denote sample means. Then show that minimizing $J$ with respect to $\mathbf{z}_n$, where $\mathbf{W}$ is kept fixed, gives rise to the PCA E step (12.58), and that minimizing $J$ with respect to $\mathbf{W}$, where $\{\mathbf{z}_n\}$ is kept fixed, gives rise to the PCA M step (12.59).

## 12.18 Independent parameters in factor analysis ($\star$)

Derive an expression for the number of independent parameters in the factor analysis model described in Section 12.2.4.

## 12.19 Rotation invariance of factor analysis ($\star\star$)

Show that the factor analysis model described in Section 12.2.4 is invariant under rotations of the latent space coordinates.

## 12.20 Maximum likelihood mean for FA ($\star\star$)

By considering second derivatives, show that the only stationary point of the log likelihood function for the factor analysis model discussed in Section 12.2.4 with respect to the parameter $\boldsymbol{\mu}$ is given by the sample mean defined by (12.1). Furthermore, show that this stationary point is a maximum.

## 12.21 E-step for factor analysis ($\star\star$)

Derive the formulae (12.66) and (12.67) for the E step of the EM algorithm for factor analysis. Note that from the result of Exercise 12.20, the parameter $\boldsymbol{\mu}$ can be replaced by the sample mean $\bar{\mathbf{x}}$.
[Page 622]

## 12.22 M-step for factor analysis ($\star\star$)

Write down an expression for the expected complete-data log likelihood function for the factor analysis model, and hence derive the corresponding M step equations (12.69) and (12.70).

## 12.23 Mixture of probabilistic PCA models ($\star$)

Draw a directed probabilistic graphical model representing a discrete mixture of probabilistic PCA models in which each PCA model has its own values of $\mathbf{W}$, $\boldsymbol{\mu}$, and $\sigma^2$. Now draw a modified graph in which these parameter values are shared between the components of the mixture.

## 12.24 EM for multivariate Student distribution ($\star\star\star$)

We saw in Section 2.3.7 that Student’s t-distribution can be viewed as an infinite mixture of Gaussians in which we marginalize with respect to a continuous latent variable. By exploiting this representation, formulate an EM algorithm for maximizing the log likelihood function for a multivariate Student’s t-distribution given an observed set of data points, and derive the forms of the E and M step equations.

## 12.25 Covariance of linear-Gaussian models ($\star\star$)

Consider a linear-Gaussian latent-variable model having a latent space distribution $p(\mathbf{z}) = \mathcal{N}(\mathbf{z}|\mathbf{0}, \mathbf{I})$ and a conditional distribution for the observed variable $p(\mathbf{x}|\mathbf{z}) = \mathcal{N}(\mathbf{x}|\mathbf{W}\mathbf{z} + \boldsymbol{\mu}, \mathbf{\Phi})$ where $\mathbf{\Phi}$ is an arbitrary symmetric, positive-definite noise covariance matrix. Now suppose that we make a nonsingular linear transformation of the data variables $\mathbf{x} \to \mathbf{A}\mathbf{x}$, where $\mathbf{A}$ is a $D \times D$ matrix. If $\boldsymbol{\mu}_{\text{ML}}$, $\mathbf{W}_{\text{ML}}$, and $\mathbf{\Phi}_{\text{ML}}$ represent the maximum likelihood solution corresponding to the original untransformed data, show that $\mathbf{A}\boldsymbol{\mu}_{\text{ML}}$, $\mathbf{A}\mathbf{W}_{\text{ML}}$, and $\mathbf{A}\mathbf{\Phi}_{\text{ML}}\mathbf{A}^{\text{T}}$ will represent the corresponding maximum likelihood solution for the transformed data set. Finally, show that the form of the model is preserved in two cases: (i) $\mathbf{A}$ is a diagonal matrix and $\mathbf{\Phi}$ is a diagonal matrix. This corresponds to the case of factor analysis. The transformed $\mathbf{\Phi}$ remains diagonal, and hence factor analysis is covariant under component-wise re-scaling of the data variables; (ii) $\mathbf{A}$ is orthogonal and $\mathbf{\Phi}$ is proportional to the unit matrix so that $\mathbf{\Phi} = \sigma^2\mathbf{I}$. This corresponds to probabilistic PCA. The transformed $\mathbf{\Phi}$ matrix remains proportional to the unit matrix, and hence probabilistic PCA is covariant under a rotation of the axes of data space, as is the case for conventional PCA.

## 12.26 Kernel PCA eigenvector solutions ($\star\star$)

Show that any vector $\mathbf{a}_i$ that satisfies (12.80) will also satisfy (12.79). Also, show that for any solution of (12.80) having eigenvalue $\lambda$, we can add any multiple of an eigenvector of $\mathbf{K}$ having zero eigenvalue, and obtain a solution to (12.79) that also has eigenvalue $\lambda$. Finally, show that such modifications do not affect the principal-component projection given by (12.82).

## 12.27 Linear kernel recovers standard PCA ($\star\star$)

Show that the conventional linear PCA algorithm is recovered as a special case of kernel PCA if we choose the linear kernel function given by $k(\mathbf{x}, \mathbf{x}') = \mathbf{x}^{\text{T}}\mathbf{x}'$.

## 12.28 Nonlinear transformation of probability density ($\star\star$)

Use the transformation property (1.27) of a probability density under a change of variable to show that any density $p(y)$ can be obtained from a fixed density $q(x)$ that is everywhere nonzero by making a nonlinear change of variable $y = f(x)$ in which $f(x)$ is a monotonic function so that $0 \le f'(x) < \infty$. Write down the differential equation satisfied by $f(x)$ and draw a diagram illustrating the transformation of the density.
[Page 623]

## 12.29 Zero correlation and independence relation ($\star\star$)

Suppose that two variables $z_1$ and $z_2$ are independent so that $p(z_1, z_2) = p(z_1)p(z_2)$. Show that the covariance matrix between these variables is diagonal. This shows that independence is a sufficient condition for two variables to be uncorrelated. Now consider two variables $y_1$ and $y_2$ in which $-1 \le y_1 \le 1$ and $y_2 = y_1^2$. Write down the conditional distribution $p(y_2|y_1)$ and observe that this is dependent on $y_1$, showing that the two variables are not independent. Now show that the covariance matrix between these two variables is again diagonal. To do this, use the relation $p(y_1, y_2) = p(y_1)p(y_2|y_1)$ to show that the off-diagonal terms are zero. This counter-example shows that zero correlation is not a sufficient condition for independence.
[Page 624]
