[Page 313]

###### 6.1. Dual Representations

Many linear models for regression and classiﬁcation can be reformulated in terms of a dual representation in which the kernel function arises naturally. This concept will play an important role when we consider support vector machines in the next chapter. Here we consider a linear regression model whose parameters are determined by minimizing a regularized sum-of-squares error function given by

$$
J(\mathbf{w}) = \frac{1}{2} \sum_{n=1}^N \left\{ \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) - t_n \right\}^2 + \frac{\lambda}{2} \mathbf{w}^T\mathbf{w} \tag{6.2}
$$

where $\lambda > 0$. If we set the gradient of $J(\mathbf{w})$ with respect to $\mathbf{w}$ equal to zero, we see that the solution for $\mathbf{w}$ takes the form of a linear combination of the vectors $\boldsymbol{\phi}(\mathbf{x}_n)$, with coefﬁcients that are functions of $\mathbf{w}$, of the form

$$
\mathbf{w} = -\frac{1}{\lambda} \sum_{n=1}^N \left\{ \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) - t_n \right\} \boldsymbol{\phi}(\mathbf{x}_n) = \sum_{n=1}^N a_n \boldsymbol{\phi}(\mathbf{x}_n) = \boldsymbol{\Phi}^T\mathbf{a} \tag{6.3}
$$

where $\boldsymbol{\Phi}$ is the design matrix, whose $n^{\text{th}}$ row is given by $\boldsymbol{\phi}(\mathbf{x}_n)^T$. Here the vector $\mathbf{a} = (a_1,\dots,a_N)^T$, and we have deﬁned

$$
a_n = -\frac{1}{\lambda} \left\{ \mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) - t_n \right\}. \tag{6.4}
$$

Instead of working with the parameter vector $\mathbf{w}$, we can now reformulate the least-squares algorithm in terms of the parameter vector $\mathbf{a}$, giving rise to a dual representation. If we substitute $\mathbf{w} = \boldsymbol{\Phi}^T\mathbf{a}$ into $J(\mathbf{w})$, we obtain

$$
J(\mathbf{a}) = \frac{1}{2} \mathbf{a}^T\boldsymbol{\Phi}\boldsymbol{\Phi}^T\boldsymbol{\Phi}\boldsymbol{\Phi}^T\mathbf{a} - \mathbf{a}^T\boldsymbol{\Phi}\boldsymbol{\Phi}^T\mathbf{t} + \frac{1}{2} \mathbf{t}^T\mathbf{t} + \frac{\lambda}{2} \mathbf{a}^T\boldsymbol{\Phi}\boldsymbol{\Phi}^T\mathbf{a} \tag{6.5}
$$

where $\mathbf{t} = (t_1,\dots,t_N)^T$. We now deﬁne the Gram matrix $\mathbf{K} = \boldsymbol{\Phi}\boldsymbol{\Phi}^T$, which is an $N \times N$ symmetric matrix with elements

$$
K_{nm} = \boldsymbol{\phi}(\mathbf{x}_n)^T\boldsymbol{\phi}(\mathbf{x}_m) = k(\mathbf{x}_n,\mathbf{x}_m) \tag{6.6}
$$

where we have introduced the kernel function $k(\mathbf{x},\mathbf{x}')$ deﬁned by (6.1). In terms of the Gram matrix, the sum-of-squares error function can be written as

$$
J(\mathbf{a}) = \frac{1}{2} \mathbf{a}^T\mathbf{K}\mathbf{K}\mathbf{a} - \mathbf{a}^T\mathbf{K}\mathbf{t} + \frac{1}{2} \mathbf{t}^T\mathbf{t} + \frac{\lambda}{2} \mathbf{a}^T\mathbf{K}\mathbf{a}. \tag{6.7}
$$

Setting the gradient of $J(\mathbf{a})$ with respect to $\mathbf{a}$ to zero, we obtain the following solution

$$
\mathbf{a} = (\mathbf{K} + \lambda\mathbf{I}_N)^{-1} \mathbf{t}. \tag{6.8}
$$
