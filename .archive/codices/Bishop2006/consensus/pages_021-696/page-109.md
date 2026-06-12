[Page 109]

(2.70) that depend on $\mathbf{x}_a$, we obtain

$$
\begin{aligned}
&\frac{1}{2} \left[ \boldsymbol{\Lambda}_{bb}\boldsymbol{\mu}_{b} - \boldsymbol{\Lambda}_{ba}(\mathbf{x}_{a} - \boldsymbol{\mu}_{a}) \right]^{\mathrm{T}} \boldsymbol{\Lambda}_{bb}^{-1} \left[ \boldsymbol{\Lambda}_{bb}\boldsymbol{\mu}_{b} - \boldsymbol{\Lambda}_{ba}(\mathbf{x}_{a} - \boldsymbol{\mu}_{a}) \right] \\
& - \frac{1}{2} \mathbf{x}_{a}^{\mathrm{T}} \boldsymbol{\Lambda}_{aa} \mathbf{x}_{a} + \mathbf{x}_{a}^{\mathrm{T}} (\boldsymbol{\Lambda}_{aa} \boldsymbol{\mu}_{a} + \boldsymbol{\Lambda}_{ab} \boldsymbol{\mu}_{b}) + \text{const} \\
&= -\frac{1}{2} \mathbf{x}_{a}^{\mathrm{T}} (\boldsymbol{\Lambda}_{aa} - \boldsymbol{\Lambda}_{ab} \boldsymbol{\Lambda}_{bb}^{-1} \boldsymbol{\Lambda}_{ba}) \mathbf{x}_{a} \\
&\quad + \mathbf{x}_{a}^{\mathrm{T}} (\boldsymbol{\Lambda}_{aa} - \boldsymbol{\Lambda}_{ab} \boldsymbol{\Lambda}_{bb}^{-1} \boldsymbol{\Lambda}_{ba}) \boldsymbol{\mu}_{a} + \text{const} \tag{2.87}
\end{aligned}
$$

where 'const' denotes quantities independent of $\mathbf{x}_a$. Again, by comparison with (2.71), we see that the covariance of the marginal distribution of $p(\mathbf{x}_a)$ is given by

$$
\boldsymbol{\Sigma}_{a} = (\boldsymbol{\Lambda}_{aa} - \boldsymbol{\Lambda}_{ab} \boldsymbol{\Lambda}_{bb}^{-1} \boldsymbol{\Lambda}_{ba})^{-1}. \tag{2.88}
$$

Similarly, the mean is given by

$$
\boldsymbol{\Sigma}_{a} (\boldsymbol{\Lambda}_{aa} - \boldsymbol{\Lambda}_{ab} \boldsymbol{\Lambda}_{bb}^{-1} \boldsymbol{\Lambda}_{ba}) \boldsymbol{\mu}_{a} = \boldsymbol{\mu}_{a} \tag{2.89}
$$

where we have used (2.88). The covariance in (2.88) is expressed in terms of the partitioned precision matrix given by (2.69). We can rewrite this in terms of the corresponding partitioning of the covariance matrix given by (2.67), as we did for the conditional distribution. These partitioned matrices are related by

$$
\begin{pmatrix}
\boldsymbol{\Lambda}_{aa} & \boldsymbol{\Lambda}_{ab} \\
\boldsymbol{\Lambda}_{ba} & \boldsymbol{\Lambda}_{bb}
\end{pmatrix}^{-1}
=
\begin{pmatrix}
\boldsymbol{\Sigma}_{aa} & \boldsymbol{\Sigma}_{ab} \\
\boldsymbol{\Sigma}_{ba} & \boldsymbol{\Sigma}_{bb}
\end{pmatrix}. \tag{2.90}
$$

Making use of (2.76), we then have

$$
(\boldsymbol{\Lambda}_{aa} - \boldsymbol{\Lambda}_{ab} \boldsymbol{\Lambda}_{bb}^{-1} \boldsymbol{\Lambda}_{ba})^{-1} = \boldsymbol{\Sigma}_{aa}. \tag{2.91}
$$

Thus we obtain the intuitively satisfying result that the marginal distribution $p(\mathbf{x}_a)$ has mean and covariance given by

$$
\mathbb{E}[\mathbf{x}_a] = \boldsymbol{\mu}_a \tag{2.92}
$$

$$
\text{cov}[\mathbf{x}_a] = \boldsymbol{\Sigma}_{aa}. \tag{2.93}
$$

We see that for a marginal distribution, the mean and covariance are most simply expressed in terms of the partitioned covariance matrix, in contrast to the conditional distribution for which the partitioned precision matrix gives rise to simpler expressions.

Our results for the marginal and conditional distributions of a partitioned Gaussian are summarized below.

**Partitioned Gaussians**

Given a joint Gaussian distribution $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu}, \boldsymbol{\Sigma})$ with $\boldsymbol{\Lambda} \equiv \boldsymbol{\Sigma}^{-1}$ and

$$
\mathbf{x} = \begin{pmatrix} \mathbf{x}_a \\ \mathbf{x}_b \end{pmatrix}, \quad \boldsymbol{\mu} = \begin{pmatrix} \boldsymbol{\mu}_a \\ \boldsymbol{\mu}_b \end{pmatrix} \tag{2.94}
$$
