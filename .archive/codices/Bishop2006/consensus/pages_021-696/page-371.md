[Page 371]

basis vectors $\boldsymbol{\phi}_1, \ldots, \boldsymbol{\phi}_M$ a similar intuition holds, namely that if a particular basis vector is poorly aligned with the data vector $\mathbf{t}$, then it is likely to be pruned from the model.

We now investigate the mechanism for sparsity from a more mathematical perspective, for a general case involving $M$ basis functions. To motivate this analysis we ﬁrst note that, in the result (7.87) for re-estimating the parameter $\alpha_i$, the terms on the right-hand side are themselves also functions of $\alpha_i$. These results therefore represent implicit solutions, and iteration would be required even to determine a single $\alpha_i$ with all other $\alpha_j$ for $j \neq i$ ﬁxed.

This suggests a different approach to solving the optimization problem for the RVM, in which we make explicit all of the dependence of the marginal likelihood (7.85) on a particular $\alpha_i$ and then determine its stationary points explicitly (Faul and Tipping, 2002; Tipping and Faul, 2003). To do this, we ﬁrst pull out the contribution from $\alpha_i$ in the matrix $\mathbf{C}$ deﬁned by (7.86) to give

$$
\begin{aligned} \mathbf{C} &= \beta^{-1}\mathbf{I} + \sum_{j \neq i} \alpha_j^{-1}\boldsymbol{\phi}_j\boldsymbol{\phi}_j^T + \alpha_i^{-1}\boldsymbol{\phi}_i\boldsymbol{\phi}_i^T \\ &= \mathbf{C}_{-i} + \alpha_i^{-1}\boldsymbol{\phi}_i\boldsymbol{\phi}_i^T \end{aligned} \tag{7.93}
$$

where $\boldsymbol{\phi}_i$ denotes the $i^{\text{th}}$ column of $\mathbf{\Phi}$, in other words the $N$-dimensional vector with elements $(\phi_i(\mathbf{x}_1), \ldots, \phi_i(\mathbf{x}_N))$, in contrast to $\boldsymbol{\phi}_n$, which denotes the $n^{\text{th}}$ row of $\mathbf{\Phi}$. The matrix $\mathbf{C}_{-i}$ represents the matrix $\mathbf{C}$ with the contribution from basis function $i$ removed. Using the matrix identities (C.7) and (C.15), the determinant and inverse of $\mathbf{C}$ can then be written

$$
|\mathbf{C}| = |\mathbf{C}_{-i}| |1 + \alpha_i^{-1}\boldsymbol{\phi}_i^T\mathbf{C}_{-i}^{-1}\boldsymbol{\phi}_i| \tag{7.94}
$$

$$
\mathbf{C}^{-1} = \mathbf{C}_{-i}^{-1} - \frac{\mathbf{C}_{-i}^{-1}\boldsymbol{\phi}_i\boldsymbol{\phi}_i^T\mathbf{C}_{-i}^{-1}}{\alpha_i + \boldsymbol{\phi}_i^T\mathbf{C}_{-i}^{-1}\boldsymbol{\phi}_i}. \tag{7.95}
$$

Using these results, we can then write the log marginal likelihood function (7.85) in the form

$$
L(\boldsymbol{\alpha}) = L(\boldsymbol{\alpha}_{-i}) + \lambda(\alpha_i) \tag{7.96}
$$

where $L(\boldsymbol{\alpha}_{-i})$ is simply the log marginal likelihood with basis function $\boldsymbol{\phi}_i$ omitted, and the quantity $\lambda(\alpha_i)$ is deﬁned by

$$
\lambda(\alpha_i) = \frac{1}{2} \left[ \ln \alpha_i - \ln(\alpha_i + s_i) + \frac{q_i^2}{\alpha_i + s_i} \right] \tag{7.97}
$$

and contains all of the dependence on $\alpha_i$. Here we have introduced the two quantities

$$
s_i = \boldsymbol{\phi}_i^T\mathbf{C}_{-i}^{-1}\boldsymbol{\phi}_i \tag{7.98}
$$

$$
q_i = \boldsymbol{\phi}_i^T\mathbf{C}_{-i}^{-1}\mathbf{t}. \tag{7.99}
$$

Here $s_i$ is called the sparsity and $q_i$ is known as the quality of $\boldsymbol{\phi}_i$, and as we shall see, a large value of $s_i$ relative to the value of $q_i$ means that the basis function $\boldsymbol{\phi}_i$
