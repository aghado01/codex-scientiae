[Page 367]

in the predictions made by the model and so are effectively pruned out, resulting in a sparse model.

Using the result (3.49) for linear regression models, we see that the posterior distribution for the weights is again Gaussian and takes the form

$$
p(\mathbf{w}|\mathbf{t}, \mathbf{X}, \boldsymbol{\alpha}, \beta) = \mathcal{N}(\mathbf{w}|\mathbf{m}, \boldsymbol{\Sigma}) \tag{7.81}
$$

where the mean and covariance are given by

$$
\mathbf{m} = \beta\boldsymbol{\Sigma}\mathbf{\Phi}^T\mathbf{t} \tag{7.82}
$$

$$
\boldsymbol{\Sigma} = (\mathbf{A} + \beta\mathbf{\Phi}^T\mathbf{\Phi})^{-1} \tag{7.83}
$$

where $\mathbf{\Phi}$ is the $N \times M$ design matrix with elements $\Phi_{ni} = \phi_i(\mathbf{x}_n)$, and $\mathbf{A} = \text{diag}(\alpha_i)$. Note that in the speciﬁc case of the model (7.78), we have $\mathbf{\Phi} = \mathbf{K}$, where $\mathbf{K}$ is the symmetric $(N + 1) \times (N + 1)$ kernel matrix with elements $k(\mathbf{x}_n, \mathbf{x}_m)$.

The values of $\boldsymbol{\alpha}$ and $\beta$ are determined using type-2 maximum likelihood, also known as the evidence approximation, in which we maximize the marginal likelihood function obtained by integrating out the weight parameters

$$
p(\mathbf{t}|\mathbf{X}, \boldsymbol{\alpha}, \beta) = \int p(\mathbf{t}|\mathbf{X}, \mathbf{w}, \beta)p(\mathbf{w}|\boldsymbol{\alpha}) \text{d}\mathbf{w}. \tag{7.84}
$$

Because this represents the convolution of two Gaussians, it is readily evaluated to give the log marginal likelihood in the form

$$
\begin{aligned} \ln p(\mathbf{t}|\mathbf{X}, \boldsymbol{\alpha}, \beta) &= \ln \mathcal{N}(\mathbf{t}|\mathbf{0}, \mathbf{C}) \\ &= -\frac{1}{2} \{N \ln(2\pi) + \ln|\mathbf{C}| + \mathbf{t}^T\mathbf{C}^{-1}\mathbf{t}\} \end{aligned} \tag{7.85}
$$

where $\mathbf{t} = (t_1, \ldots, t_N)^T$, and we have deﬁned the $N \times N$ matrix $\mathbf{C}$ given by

$$
\mathbf{C} = \beta^{-1}\mathbf{I} + \mathbf{\Phi}\mathbf{A}^{-1}\mathbf{\Phi}^T. \tag{7.86}
$$

Our goal is now to maximize (7.85) with respect to the hyperparameters $\boldsymbol{\alpha}$ and $\beta$. This requires only a small modiﬁcation to the results obtained in Section 3.5 for the evidence approximation in the linear regression model. Again, we can identify two approaches. In the ﬁrst, we simply set the required derivatives of the marginal likelihood to zero and obtain the following re-estimation equations

$$
\alpha_i^{\text{new}} = \frac{\gamma_i}{m_i^2} \tag{7.87}
$$

$$
(\beta^{\text{new}})^{-1} = \frac{\|\mathbf{t} - \mathbf{\Phi}\mathbf{m}\|^2}{N - \sum_i \gamma_i} \tag{7.88}
$$

where $m_i$ is the $i^{\text{th}}$ component of the posterior mean $\mathbf{m}$ deﬁned by (7.82). The quantity $\gamma_i$ measures how well the corresponding parameter $w_i$ is determined by the data and is deﬁned by
