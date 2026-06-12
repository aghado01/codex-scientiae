[Page 341]

6.11 ( ) By making use of the expansion (6.25), and then expanding the middle factor as a power series, show that the Gaussian kernel (6.23) can be expressed as the inner product of an inﬁnite-dimensional feature vector.

6.12 ( ) www Consider the space of all possible subsets $A$ of a given ﬁxed set $D$. Show that the kernel function (6.27) corresponds to an inner product in a feature space of dimensionality $2^{|D|}$ deﬁned by the mapping $\phi(A)$ where $A$ is a subset of $D$ and the element $\phi_U(A)$, indexed by the subset $U$, is given by

$$
\phi_U(A) = \begin{cases} 1, & \text{if } U \subseteq A; \\ 0, & \text{otherwise.} \end{cases} \tag{6.95}
$$

Here $U \subseteq A$ denotes that $U$ is either a subset of $A$ or is equal to $A$.

6.13 ( ) Show that the Fisher kernel, deﬁned by (6.33), remains invariant if we make a nonlinear transformation of the parameter vector $\boldsymbol{\theta} \to \boldsymbol{\psi}(\boldsymbol{\theta})$, where the function $\boldsymbol{\psi}(\cdot)$ is invertible and differentiable.

6.14 ( ) www Write down the form of the Fisher kernel, deﬁned by (6.33), for the case of a distribution $p(\mathbf{x}|\boldsymbol{\mu}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\mathbf{S})$ that is Gaussian with mean $\boldsymbol{\mu}$ and ﬁxed covariance $\mathbf{S}$.

6.15 ( ) By considering the determinant of a $2 \times 2$ Gram matrix, show that a positivedeﬁnite kernel function $k(\mathbf{x},\mathbf{x}')$ satisﬁes the Cauchy-Schwartz inequality

$$
k(\mathbf{x}_1,\mathbf{x}_2)^2 \leqslant k(\mathbf{x}_1,\mathbf{x}_1)k(\mathbf{x}_2,\mathbf{x}_2). \tag{6.96}
$$

6.16 ( ) Consider a parametric model governed by the parameter vector $\mathbf{w}$ together with a data set of input values $\mathbf{x}_1,\dots,\mathbf{x}_N$ and a nonlinear feature mapping $\boldsymbol{\phi}(\mathbf{x})$. Suppose that the dependence of the error function on $\mathbf{w}$ takes the form

$$
J(\mathbf{w}) = f(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_1),\dots,\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_N)) + g(\mathbf{w}^T\mathbf{w}) \tag{6.97}
$$

where $g(\cdot)$ is a monotonically increasing function. By writing $\mathbf{w}$ in the form

$$
\mathbf{w} = \sum_{n=1}^N \alpha_n \boldsymbol{\phi}(\mathbf{x}_n) + \mathbf{w}_{\perp} \tag{6.98}
$$

show that the value of $\mathbf{w}$ that minimizes $J(\mathbf{w})$ takes the form of a linear combination of the basis functions $\boldsymbol{\phi}(\mathbf{x}_n)$ for $n = 1,\dots,N$.

6.17 ( ) www Consider the sum-of-squares error function (6.39) for data having noisy inputs, where $\nu(\boldsymbol{\xi})$ is the distribution of the noise. Use the calculus of variations to minimize this error function with respect to the function $y(\mathbf{x})$, and hence show that the optimal solution is given by an expansion of the form (6.40) in which the basis functions are given by (6.41).
