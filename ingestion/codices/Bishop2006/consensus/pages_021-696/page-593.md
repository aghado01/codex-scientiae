[Page 593]

where the $D \times D$ covariance matrix $\mathbf{C}$ is deﬁned by

$$
\mathbf{C} = \mathbf{W}\mathbf{W}^{\text{T}} + \sigma^2\mathbf{I}. \tag{12.36}
$$

This result can also be derived more directly by noting that the predictive distribution will be Gaussian and then evaluating its mean and covariance using (12.33). This gives

$$
\begin{aligned}
\mathbb{E}[\mathbf{x}] &= \mathbb{E}[\mathbf{W}\mathbf{z} + \boldsymbol{\mu} + \boldsymbol{\epsilon}] = \boldsymbol{\mu} \tag{12.37} \\
\text{cov}[\mathbf{x}] &= \mathbb{E}[(\mathbf{W}\mathbf{z} + \boldsymbol{\epsilon})(\mathbf{W}\mathbf{z} + \boldsymbol{\epsilon})^{\text{T}}] \\
&= \mathbb{E}[\mathbf{W}\mathbf{z}\mathbf{z}^{\text{T}}\mathbf{W}^{\text{T}}] + \mathbb{E}[\boldsymbol{\epsilon}\boldsymbol{\epsilon}^{\text{T}}] = \mathbf{W}\mathbf{W}^{\text{T}} + \sigma^2\mathbf{I} \tag{12.38}
\end{aligned}
$$

where we have used the fact that $\mathbf{z}$ and $\boldsymbol{\epsilon}$ are independent random variables and hence are uncorrelated.

Intuitively, we can think of the distribution $p(\mathbf{x})$ as being deﬁned by taking an isotropic Gaussian ‘spray can’ and moving it across the principal subspace spraying Gaussian ink with density determined by $\sigma^2$ and weighted by the prior distribution. The accumulated ink density gives rise to a ‘pancake’ shaped distribution representing the marginal density $p(\mathbf{x})$.

The predictive distribution $p(\mathbf{x})$ is governed by the parameters $\boldsymbol{\mu}$, $\mathbf{W}$, and $\sigma^2$. However, there is redundancy in this parameterization corresponding to rotations of the latent space coordinates. To see this, consider a matrix $\tilde{\mathbf{W}} = \mathbf{W}\mathbf{R}$ where $\mathbf{R}$ is an orthogonal matrix. Using the orthogonality property $\mathbf{R}\mathbf{R}^{\text{T}} = \mathbf{I}$, we see that the quantity $\tilde{\mathbf{W}}\tilde{\mathbf{W}}^{\text{T}}$ that appears in the covariance matrix $\mathbf{C}$ takes the form

$$
\tilde{\mathbf{W}}\tilde{\mathbf{W}}^{\text{T}} = \mathbf{W}\mathbf{R}\mathbf{R}^{\text{T}}\mathbf{W}^{\text{T}} = \mathbf{W}\mathbf{W}^{\text{T}} \tag{12.39}
$$

and hence is independent of $\mathbf{R}$. Thus there is a whole family of matrices $\tilde{\mathbf{W}}$ all of which give rise to the same predictive distribution. This invariance can be understood in terms of rotations within the latent space. We shall return to a discussion of the number of independent parameters in this model later.

When we evaluate the predictive distribution, we require $\mathbf{C}^{-1}$, which involves the inversion of a $D \times D$ matrix. The computation required to do this can be reduced by making use of the matrix inversion identity (C.7) to give

$$
\mathbf{C}^{-1} = \sigma^{-2}\mathbf{I} - \sigma^{-2}\mathbf{W}\mathbf{M}^{-1}\mathbf{W}^{\text{T}} \tag{12.40}
$$

where the $M \times M$ matrix $\mathbf{M}$ is deﬁned by

$$
\mathbf{M} = \mathbf{W}^{\text{T}}\mathbf{W} + \sigma^2\mathbf{I}. \tag{12.41}
$$

Because we invert $\mathbf{M}$ rather than inverting $\mathbf{C}$ directly, the cost of evaluating $\mathbf{C}^{-1}$ is reduced from $O(D^3)$ to $O(M^3)$.

As well as the predictive distribution $p(\mathbf{x})$, we will also require the posterior distribution $p(\mathbf{z}|\mathbf{x})$, which can again be written down directly using the result (2.116) for linear-Gaussian models to give

$$
p(\mathbf{z}|\mathbf{x}) = \mathcal{N}(\mathbf{z}|\mathbf{M}^{-1}\mathbf{W}^{\text{T}}(\mathbf{x} - \boldsymbol{\mu}), \sigma^2\mathbf{M}^{-1}). \tag{12.42}
$$

Note that the posterior mean depends on $\mathbf{x}$, whereas the posterior covariance is independent of $\mathbf{x}$.
