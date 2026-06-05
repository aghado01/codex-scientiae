[Page 105]

such complex distributions is that of probabilistic graphical models, which will form the subject of Chapter 8.

###### 2.3.1 Conditional Gaussian distributions

An important property of the multivariate Gaussian distribution is that if two sets of variables are jointly Gaussian, then the conditional distribution of one set conditioned on the other is again Gaussian. Similarly, the marginal distribution of either set is also Gaussian.

Consider ﬁrst the case of conditional distributions. Suppose $\mathbf{x}$ is a $D$-dimensional vector with Gaussian distribution $\mathcal{N}(\mathbf{x} \mid \boldsymbol{\mu}, \Sigma)$ and that we partition $\mathbf{x}$ into two disjoint subsets $\mathbf{x}_a$ and $\mathbf{x}_b$. Without loss of generality, we can take $\mathbf{x}_a$ to form the ﬁrst $M$ components of $\mathbf{x}$, with $\mathbf{x}_b$ comprising the remaining $D - M$ components, so that

$$
\mathbf{x} = \begin{pmatrix} \mathbf{x}_a \\ \mathbf{x}_b \end{pmatrix}. \tag{2.65}
$$

We also deﬁne corresponding partitions of the mean vector $\boldsymbol{\mu}$ given by

$$
\boldsymbol{\mu} = \begin{pmatrix} \boldsymbol{\mu}_a \\ \boldsymbol{\mu}_b \end{pmatrix} \tag{2.66}
$$

and of the covariance matrix $\Sigma$ given by

$$
\Sigma = \begin{pmatrix} \Sigma_{aa} & \Sigma_{ab} \\ \Sigma_{ba} & \Sigma_{bb} \end{pmatrix}. \tag{2.67}
$$

Note that the symmetry $\Sigma^T = \Sigma$ of the covariance matrix implies that $\Sigma_{aa}$ and $\Sigma_{bb}$ are symmetric, while $\Sigma_{ba} = \Sigma_{ab}^T$.

In many situations, it will be convenient to work with the inverse of the covariance matrix

$$
\Lambda \equiv \Sigma^{-1} \tag{2.68}
$$

which is known as the precision matrix. In fact, we shall see that some properties of Gaussian distributions are most naturally expressed in terms of the covariance, whereas others take a simpler form when viewed in terms of the precision. We therefore also introduce the partitioned form of the precision matrix

$$
\Lambda = \begin{pmatrix} \Lambda_{aa} & \Lambda_{ab} \\ \Lambda_{ba} & \Lambda_{bb} \end{pmatrix} \tag{2.69}
$$

corresponding to the partitioning (2.65) of the vector $\mathbf{x}$. Because the inverse of a symmetric matrix is also symmetric, we see that $\Lambda_{aa}$ and $\Lambda_{bb}$ are symmetric, while $\Lambda_{ab}^T = \Lambda_{ba}$. It should be stressed at this point that, for instance, $\Lambda_{aa}$ is not simply given by the inverse of $\Sigma_{aa}$. In fact, we shall shortly examine the relation between the inverse of a partitioned matrix and the inverses of its partitions.

Let us begin by ﬁnding an expression for the conditional distribution p(xa|xb). From the product rule of probability, we see that this conditional distribution can be
