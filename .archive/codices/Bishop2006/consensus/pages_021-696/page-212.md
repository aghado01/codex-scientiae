[Page 212]

These covariance matrices have been defined in the original $\mathbf{x}$-space. We can now define similar matrices in the projected $D$-dimensional $\mathbf{y}$-space

$$
\mathbf{s}_W = \sum_{k=1}^K \sum_{n \in \mathcal{C}_k} (\mathbf{y}_n - \boldsymbol{\mu}_k)(\mathbf{y}_n - \boldsymbol{\mu}_k)^{\mathrm{T}} \tag{4.47}
$$

and

$$
\mathbf{s}_B = \sum_{k=1}^K N_k (\boldsymbol{\mu}_k - \boldsymbol{\mu})(\boldsymbol{\mu}_k - \boldsymbol{\mu})^{\mathrm{T}} \tag{4.48}
$$

where

$$
\boldsymbol{\mu}_k = \frac{1}{N_k} \sum_{n \in \mathcal{C}_k} \mathbf{y}_n, \quad \boldsymbol{\mu} = \frac{1}{N} \sum_{k=1}^K N_k \boldsymbol{\mu}_k. \tag{4.49}
$$

Again we wish to construct a scalar that is large when the between-class covariance is large and when the within-class covariance is small. There are now many possible choices of criterion (Fukunaga, 1990). One example is given by

$$
J(\mathbf{W}) = \operatorname{Tr} \{ \mathbf{s}_W^{-1} \mathbf{s}_B \} . \tag{4.50}
$$

This criterion can then be rewritten as an explicit function of the projection matrix $\mathbf{W}$ in the form

$$
J(\mathbf{W}) = \operatorname{Tr} \left\{ (\mathbf{W}\mathbf{S}_W\mathbf{W}^{\mathrm{T}})^{-1} (\mathbf{W}\mathbf{S}_B\mathbf{W}^{\mathrm{T}}) \right\} . \tag{4.51}
$$

Maximization of such criteria is straightforward, though somewhat involved, and is discussed at length in Fukunaga (1990). The weight values are determined by those eigenvectors of $\mathbf{S}_W^{-1} \mathbf{S}_B$ that correspond to the $D$ largest eigenvalues.

There is one important result that is common to all such criteria, which is worth emphasizing. We first note from (4.46) that $\mathbf{S}_B$ is composed of the sum of $K$ matrices, each of which is an outer product of two vectors and therefore of rank $1$. In addition, only $(K - 1)$ of these matrices are independent as a result of the constraint (4.44). Thus, $\mathbf{S}_B$ has rank at most equal to $(K - 1)$ and so there are at most $(K - 1)$ nonzero eigenvalues. This shows that the projection onto the $(K - 1)$-dimensional subspace spanned by the eigenvectors of $\mathbf{S}_B$ does not alter the value of $J(\mathbf{W})$, and so we are therefore unable to find more than $(K - 1)$ linear ‘features’ by this means (Fukunaga, 1990).

### 4.1.7 The perceptron algorithm

Another example of a linear discriminant model is the perceptron of Rosenblatt (1962), which occupies an important place in the history of pattern recognition algorithms. It corresponds to a two-class model in which the input vector $\mathbf{x}$ is first transformed using a fixed nonlinear transformation to give a feature vector $\boldsymbol{\phi}(\mathbf{x})$, and this is then used to construct a generalized linear model of the form

$$
y(\mathbf{x}) = f(\mathbf{w}^{\mathrm{T}}\boldsymbol{\phi}(\mathbf{x})) \tag{4.52}
$$
