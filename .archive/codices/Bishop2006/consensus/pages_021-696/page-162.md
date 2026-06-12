[Page 162]

Setting this gradient to zero gives
$$
0 = \sum_{n=1}^{N} t_{n} \boldsymbol{\phi}(\mathbf{x}_{n})^{T} - \mathbf{w}^{T} \left( \sum_{n=1}^{N} \boldsymbol{\phi}(\mathbf{x}_{n})\boldsymbol{\phi}(\mathbf{x}_{n})^{T} \right). \tag{3.14}
$$

Solving for $\mathbf{w}$ we obtain
$$
\mathbf{w}_{\text{ML}} = (\mathbf{\Phi}^{T}\mathbf{\Phi})^{-1}\mathbf{\Phi}^{T}\mathbf{t} \tag{3.15}
$$
which are known as the normal equations for the least squares problem. Here $\mathbf{\Phi}$ is an $N \times M$ matrix, called the design matrix, whose elements are given by $\Phi_{nj} = \phi_j(\mathbf{x}_n)$, so that
$$
\mathbf{\Phi} = \begin{pmatrix} 
\phi_{0}(\mathbf{x}_{1}) & \phi_{1}(\mathbf{x}_{1}) & \cdots & \phi_{M-1}(\mathbf{x}_{1}) \\ 
\phi_{0}(\mathbf{x}_{2}) & \phi_{1}(\mathbf{x}_{2}) & \cdots & \phi_{M-1}(\mathbf{x}_{2}) \\ 
\vdots & \vdots & \ddots & \vdots \\ 
\phi_{0}(\mathbf{x}_{N}) & \phi_{1}(\mathbf{x}_{N}) & \cdots & \phi_{M-1}(\mathbf{x}_{N}) 
\end{pmatrix}. \tag{3.16}
$$

The quantity
$$
\mathbf{\Phi}^{\dagger} \equiv (\mathbf{\Phi}^{T}\mathbf{\Phi})^{-1}\mathbf{\Phi}^{T} \tag{3.17}
$$
is known as the Moore-Penrose pseudo-inverse of the matrix $\mathbf{\Phi}$ (Rao and Mitra, 1971; Golub and Van Loan, 1996). It can be regarded as a generalization of the notion of matrix inverse to nonsquare matrices. Indeed, if $\mathbf{\Phi}$ is square and invertible, then using the property $(\mathbf{A}\mathbf{B})^{-1} = \mathbf{B}^{-1}\mathbf{A}^{-1}$ we see that $\mathbf{\Phi}^{\dagger} \equiv \mathbf{\Phi}^{-1}$.

At this point, we can gain some insight into the role of the bias parameter $w_0$. If we make the bias parameter explicit, then the error function (3.12) becomes
$$
E_{D}(\mathbf{w}) = \frac{1}{2} \sum_{n=1}^{N} \left\{ t_{n} - w_{0} - \sum_{j=1}^{M-1} w_{j}\phi_{j}(\mathbf{x}_{n}) \right\}^{2}. \tag{3.18}
$$

Setting the derivative with respect to $w_0$ equal to zero, and solving for $w_0$, we obtain
$$
w_{0} = \bar{t} - \sum_{j=1}^{M-1} w_{j}\overline{\phi}_{j} \tag{3.19}
$$
where we have defined
$$
\bar{t} = \frac{1}{N} \sum_{n=1}^{N} t_{n}, \quad \overline{\phi}_{j} = \frac{1}{N} \sum_{n=1}^{N} \phi_{j}(\mathbf{x}_{n}). \tag{3.20}
$$

Thus the bias $w_0$ compensates for the difference between the averages (over the training set) of the target values and the weighted sum of the averages of the basis function values.

We can also maximize the log likelihood function (3.11) with respect to the noise precision parameter $\beta$, giving
$$
\frac{1}{\beta_{\text{ML}}} = \frac{1}{N} \sum_{n=1}^{N} \{t_{n} - \mathbf{w}_{\text{ML}}^{T}\boldsymbol{\phi}(\mathbf{x}_{n})\}^{2} \tag{3.21}
$$
