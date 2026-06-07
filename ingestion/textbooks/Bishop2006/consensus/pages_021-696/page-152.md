[Page 152]

Mahalanobis distance $\Delta$ is given by

$$
V_{D} |\boldsymbol{\Sigma}|^{1/2} \Delta^{D} \tag{2.286}
$$

where $V_{D}$ is the volume of the unit sphere in $D$ dimensions, and the Mahalanobis distance is deﬁned by (2.44).

2.24 ( ) www Prove the identity (2.76) by multiplying both sides by the matrix

$$
\begin{pmatrix}
\mathbf{A} & \mathbf{B} \\
\mathbf{C} & \mathbf{D}
\end{pmatrix}
\tag{2.287}
$$

and making use of the deﬁnition (2.77).

2.25 ( ) In Sections 2.3.1 and 2.3.2, we considered the conditional and marginal distributions for a multivariate Gaussian. More generally, we can consider a partitioning of the components of $\mathbf{x}$ into three groups $\mathbf{x}_{a}$, $\mathbf{x}_{b}$, and $\mathbf{x}_{c}$, with a corresponding partitioning of the mean vector $\boldsymbol{\mu}$ and of the covariance matrix $\boldsymbol{\Sigma}$ in the form

$$
\boldsymbol{\mu} =
\begin{pmatrix}
\boldsymbol{\mu}_{a} \\
\boldsymbol{\mu}_{b} \\
\boldsymbol{\mu}_{c}
\end{pmatrix},
\quad
\boldsymbol{\Sigma} =
\begin{pmatrix}
\boldsymbol{\Sigma}_{aa} & \boldsymbol{\Sigma}_{ab} & \boldsymbol{\Sigma}_{ac} \\
\boldsymbol{\Sigma}_{ba} & \boldsymbol{\Sigma}_{bb} & \boldsymbol{\Sigma}_{bc} \\
\boldsymbol{\Sigma}_{ca} & \boldsymbol{\Sigma}_{cb} & \boldsymbol{\Sigma}_{cc}
\end{pmatrix}.
\tag{2.288}
$$

By making use of the results of Section 2.3, ﬁnd an expression for the conditional distribution $p(\mathbf{x}_{a}|\mathbf{x}_{b})$ in which $\mathbf{x}_{c}$ has been marginalized out.

2.26 ( ) A very useful result from linear algebra is the Woodbury matrix inversion formula given by

$$
(\mathbf{A} + \mathbf{B}\mathbf{C}\mathbf{D})^{-1} = \mathbf{A}^{-1} - \mathbf{A}^{-1}\mathbf{B}(\mathbf{C}^{-1} + \mathbf{D}\mathbf{A}^{-1}\mathbf{B})^{-1}\mathbf{D}\mathbf{A}^{-1}. \tag{2.289}
$$

By multiplying both sides by $(\mathbf{A} + \mathbf{B}\mathbf{C}\mathbf{D})$ prove the correctness of this result.

2.27 ( ) Let $\mathbf{x}$ and $\mathbf{z}$ be two independent random vectors, so that $p(\mathbf{x},\mathbf{z}) = p(\mathbf{x})p(\mathbf{z})$. Show that the mean of their sum $\mathbf{y} = \mathbf{x}+\mathbf{z}$ is given by the sum of the means of each of the variable separately. Similarly, show that the covariance matrix of $\mathbf{y}$ is given by the sum of the covariance matrices of $\mathbf{x}$ and $\mathbf{z}$. Conﬁrm that this result agrees with that of Exercise 1.10.

2.28 ( ) www Consider a joint distribution over the variable

$$
\mathbf{z} =
\begin{pmatrix}
\mathbf{x} \\
\mathbf{y}
\end{pmatrix}
\tag{2.290}
$$

whose mean and covariance are given by (2.108) and (2.105) respectively. By making use of the results (2.92) and (2.93) show that the marginal distribution $p(\mathbf{x})$ is given (2.99). Similarly, by making use of the results (2.81) and (2.82) show that the conditional distribution $p(\mathbf{y}|\mathbf{x})$ is given by (2.100).
