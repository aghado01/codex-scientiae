[Page 325]

$\mathbf{x}_1,\dots,\mathbf{x}_N$. We are therefore interested in the joint distribution of the function values $y(\mathbf{x}_1),\dots,y(\mathbf{x}_N)$, which we denote by the vector $\mathbf{y}$ with elements $y_n = y(\mathbf{x}_n)$ for $n = 1,\dots,N$. From (6.49), this vector is given by

$$
\mathbf{y} = \boldsymbol{\Phi}\mathbf{w} \tag{6.51}
$$

where $\boldsymbol{\Phi}$ is the design matrix with elements $\Phi_{nk} = \phi_k(\mathbf{x}_n)$. We can ﬁnd the probability distribution of $\mathbf{y}$ as follows. First of all we note that $\mathbf{y}$ is a linear combination of Gaussian distributed variables given by the elements of $\mathbf{w}$ and hence is itself Gaussian. We therefore need only to ﬁnd its mean and covariance, which are given from (6.50) by

$$
\begin{aligned}
\mathbb{E}[\mathbf{y}] &= \boldsymbol{\Phi}\mathbb{E}[\mathbf{w}] = \mathbf{0} \tag{6.52} \\
\operatorname{cov}[\mathbf{y}] &= \mathbb{E}[\mathbf{y}\mathbf{y}^T] = \boldsymbol{\Phi}\mathbb{E}[\mathbf{w}\mathbf{w}^T]\boldsymbol{\Phi}^T = \frac{1}{\alpha}\boldsymbol{\Phi}\boldsymbol{\Phi}^T = \mathbf{K} \tag{6.53}
\end{aligned}
$$

where $\mathbf{K}$ is the Gram matrix with elements

$$
K_{nm} = k(\mathbf{x}_n,\mathbf{x}_m) = \frac{1}{\alpha}\boldsymbol{\phi}(\mathbf{x}_n)^T\boldsymbol{\phi}(\mathbf{x}_m) \tag{6.54}
$$

and $k(\mathbf{x},\mathbf{x}')$ is the kernel function.

This model provides us with a particular example of a Gaussian process. In general, a Gaussian process is deﬁned as a probability distribution over functions $y(\mathbf{x})$ such that the set of values of $y(\mathbf{x})$ evaluated at an arbitrary set of points $\mathbf{x}_1,\dots,\mathbf{x}_N$ jointly have a Gaussian distribution. In cases where the input vector $\mathbf{x}$ is two dimensional, this may also be known as a Gaussian random ﬁeld. More generally, a stochastic process $y(\mathbf{x})$ is speciﬁed by giving the joint probability distribution for any ﬁnite set of values $y(\mathbf{x}_1),\dots,y(\mathbf{x}_N)$ in a consistent manner.

A key point about Gaussian stochastic processes is that the joint distribution over $N$ variables $y_1,\dots,y_N$ is speciﬁed completely by the second-order statistics, namely the mean and the covariance. In most applications, we will not have any prior knowledge about the mean of $y(\mathbf{x})$ and so by symmetry we take it to be zero. This is equivalent to choosing the mean of the prior over weight values $p(\mathbf{w}|\alpha)$ to be zero in the basis function viewpoint. The speciﬁcation of the Gaussian process is then completed by giving the covariance of $y(\mathbf{x})$ evaluated at any two values of $\mathbf{x}$, which is given by the kernel function

$$
\mathbb{E}[y(\mathbf{x}_n)y(\mathbf{x}_m)] = k(\mathbf{x}_n,\mathbf{x}_m). \tag{6.55}
$$

For the speciﬁc case of a Gaussian process deﬁned by the linear regression model (6.49) with a weight prior (6.50), the kernel function is given by (6.54).

We can also deﬁne the kernel function directly, rather than indirectly through a choice of basis function. Figure 6.4 shows samples of functions drawn from Gaussian processes for two different choices of kernel function. The ﬁrst of these is a ‘Gaussian’ kernel of the form (6.23), and the second is the exponential kernel given by

$$
k(\mathbf{x},\mathbf{x}') = \exp(-\theta|\mathbf{x} - \mathbf{x}'|) \tag{6.56}
$$

which corresponds to the Ornstein-Uhlenbeck process originally introduced by Uhlenbeck and Ornstein (1930) to describe Brownian motion.
