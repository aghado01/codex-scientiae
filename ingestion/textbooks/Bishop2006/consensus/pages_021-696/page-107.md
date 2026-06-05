[Page 107]

Now consider all of the terms in (2.70) that are linear in $\mathbf{x}_a$

$$
\mathbf{x}_a^T\left\{\Lambda_{aa}\boldsymbol{\mu}_a - \Lambda_{ab}(\mathbf{x}_b - \boldsymbol{\mu}_b)\right\} \tag{2.74}
$$

where we have used $\Lambda_{ba}^T = \Lambda_{ab}$. From our discussion of the general form (2.71), the coefﬁcient of $\mathbf{x}_a$ in this expression must equal $\Sigma_{a|b}^{-1}\boldsymbol{\mu}_{a|b}$ and hence

$$
\boldsymbol{\mu}_{a|b} = \Sigma_{a|b}\left\{\Lambda_{aa}\boldsymbol{\mu}_a - \Lambda_{ab}(\mathbf{x}_b - \boldsymbol{\mu}_b)\right\}
$$

$$
= \boldsymbol{\mu}_a - \Lambda_{aa}^{-1}\Lambda_{ab}(\mathbf{x}_b - \boldsymbol{\mu}_b). \tag{2.75}
$$

where we have made use of (2.73).

The results (2.73) and (2.75) are expressed in terms of the partitioned precision matrix of the original joint distribution $p(\mathbf{x}_a, \mathbf{x}_b)$. We can also express these results in terms of the corresponding partitioned covariance matrix. To do this, we make use of the following identity for the inverse of a partitioned matrix

$$
\begin{pmatrix} A & B \\ C & D \end{pmatrix}^{-1} = \begin{pmatrix} M & -MBD^{-1} \\ -D^{-1}CM & D^{-1} + D^{-1}CMBD^{-1} \end{pmatrix} \tag{2.76}
$$

where we have deﬁned

$$
M = (A - BD^{-1}C)^{-1}. \tag{2.77}
$$

The quantity $M^{-1}$ is known as the Schur complement of the matrix on the left-hand side of (2.76) with respect to the submatrix $D$. Using the deﬁnition

$$
\begin{pmatrix} \Sigma_{aa} & \Sigma_{ab} \\ \Sigma_{ba} & \Sigma_{bb} \end{pmatrix}^{-1} = \begin{pmatrix} \Lambda_{aa} & \Lambda_{ab} \\ \Lambda_{ba} & \Lambda_{bb} \end{pmatrix} \tag{2.78}
$$

and making use of (2.76), we have

$$
\Lambda_{aa} = (\Sigma_{aa} - \Sigma_{ab}\Sigma_{bb}^{-1}\Sigma_{ba})^{-1} \tag{2.79}
$$

$$
\Lambda_{ab} = -(\Sigma_{aa} - \Sigma_{ab}\Sigma_{bb}^{-1}\Sigma_{ba})^{-1}\Sigma_{ab}\Sigma_{bb}^{-1}. \tag{2.80}
$$

From these we obtain the following expressions for the mean and covariance of the conditional distribution $p(\mathbf{x}_a \mid \mathbf{x}_b)$

$$
\boldsymbol{\mu}_{a|b} = \boldsymbol{\mu}_a + \Sigma_{ab}\Sigma_{bb}^{-1}(\mathbf{x}_b - \boldsymbol{\mu}_b) \tag{2.81}
$$

$$
\Sigma_{a|b} = \Sigma_{aa} - \Sigma_{ab}\Sigma_{bb}^{-1}\Sigma_{ba}. \tag{2.82}
$$

Comparing (2.73) and (2.82), we see that the conditional distribution $p(\mathbf{x}_a \mid \mathbf{x}_b)$ takes a simpler form when expressed in terms of the partitioned precision matrix than when it is expressed in terms of the partitioned covariance matrix. Note that the mean of the conditional distribution $p(\mathbf{x}_a \mid \mathbf{x}_b)$, given by (2.81), is a linear function of $\mathbf{x}_b$ and that the covariance, given by (2.82), is independent of $\mathbf{x}_a$. This represents an example of a linear-Gaussian model, discussed further in Section 8.1.4.
