[Page 111]

a linear Gaussian model (Roweis and Ghahramani, 1999), which we shall study in greater generality in Section 8.1.4. We wish to ﬁnd the marginal distribution $p(\mathbf{y})$ and the conditional distribution $p(\mathbf{x} \mid \mathbf{y})$. This is a problem that will arise frequently in subsequent chapters, and it will prove convenient to derive the general results here.

We shall take the marginal and conditional distributions to be

$$
p(\mathbf{x}) = \mathcal{N}(\mathbf{x} \mid \boldsymbol{\mu}, \Lambda^{-1}) \tag{2.99}
$$

$$
p(\mathbf{y} \mid \mathbf{x}) = \mathcal{N}(\mathbf{y} \mid A\mathbf{x} + \mathbf{b}, L^{-1}) \tag{2.100}
$$

where $\boldsymbol{\mu}$, $A$, and $\mathbf{b}$ are parameters governing the means, and $\Lambda$ and $L$ are precision matrices. If $\mathbf{x}$ has dimensionality $M$ and $\mathbf{y}$ has dimensionality $D$, then the matrix $A$ has size $D \times M$.

First we ﬁnd an expression for the joint distribution over $\mathbf{x}$ and $\mathbf{y}$. To do this, we deﬁne

$$
\mathbf{z} = \begin{pmatrix} \mathbf{x} \\ \mathbf{y} \end{pmatrix} \tag{2.101}
$$

and then consider the log of the joint distribution

$$
\ln p(\mathbf{z}) = \ln p(\mathbf{x}) + \ln p(\mathbf{y} \mid \mathbf{x})
$$

$$
= -\frac{1}{2}(\mathbf{x} - \boldsymbol{\mu})^T\Lambda(\mathbf{x} - \boldsymbol{\mu}) - \frac{1}{2}(\mathbf{y} - A\mathbf{x} - \mathbf{b})^TL(\mathbf{y} - A\mathbf{x} - \mathbf{b}) + \text{const}. \tag{2.102}
$$

where ‘const’ denotes terms independent of $\mathbf{x}$ and $\mathbf{y}$. As before, we see that this is a quadratic function of the components of $\mathbf{z}$, and hence $p(\mathbf{z})$ is a Gaussian distribution. To ﬁnd the precision of this Gaussian, we consider the second-order terms in (2.102), which can be written as

$$
-\frac{1}{2}\mathbf{x}^T(\Lambda + A^TLA)\mathbf{x} - \frac{1}{2}\mathbf{y}^TL\mathbf{y} + \mathbf{x}^TA^TL\mathbf{y}
$$

$$
= -\frac{1}{2}
\begin{pmatrix} \mathbf{x} \\ \mathbf{y} \end{pmatrix}^T
\begin{pmatrix} \Lambda + A^TLA & -A^TL \\ -LA & L \end{pmatrix}
\begin{pmatrix} \mathbf{x} \\ \mathbf{y} \end{pmatrix}
$$

$$
= -\frac{1}{2}\mathbf{z}^TR\mathbf{z}. \tag{2.103}
$$

and so the Gaussian distribution over $\mathbf{z}$ has precision (inverse covariance) matrix given by

$$
R = \begin{pmatrix} \Lambda + A^TLA & -A^TL \\ -LA & L \end{pmatrix}. \tag{2.104}
$$

The covariance matrix is found by taking the inverse of the precision, which can be done using the matrix inversion formula (2.76) to give

$$
\operatorname{cov}[\mathbf{z}] = R^{-1} = \begin{pmatrix} \Lambda^{-1} & \Lambda^{-1}A^T \\ A\Lambda^{-1} & L^{-1} + A\Lambda^{-1}A^T \end{pmatrix}. \tag{2.105}
$$
