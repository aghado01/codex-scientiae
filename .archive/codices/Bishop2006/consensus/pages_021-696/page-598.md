[Page 598]

are assumed independent, the complete-data log likelihood function takes the form

$$
\ln p(\mathbf{X}, \mathbf{Z}|\boldsymbol{\mu}, \mathbf{W}, \sigma^2) = \sum_{n=1}^N \{\ln p(\mathbf{x}_n|\mathbf{z}_n) + \ln p(\mathbf{z}_n)\} \tag{12.52}
$$

where the $n^{\text{th}}$ row of the matrix $\mathbf{Z}$ is given by $\mathbf{z}_n$. We already know that the exact maximum likelihood solution for $\boldsymbol{\mu}$ is given by the sample mean $\bar{\mathbf{x}}$ deﬁned by (12.1), and it is convenient to substitute for $\boldsymbol{\mu}$ at this stage. Making use of the expressions (12.31) and (12.32) for the latent and conditional distributions, respectively, and taking the expectation with respect to the posterior distribution over the latent variables, we obtain

$$
\begin{aligned}
\mathbb{E}[\ln p(\mathbf{X}, \mathbf{Z}|\boldsymbol{\mu}, \mathbf{W}, \sigma^2)] &= -\sum_{n=1}^N \left\{ \frac{D}{2} \ln(2\pi\sigma^2) + \frac{1}{2} \text{Tr}(\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}]) \right. \\
&\quad + \frac{1}{2\sigma^2} \|\mathbf{x}_n - \boldsymbol{\mu}\|^2 - \frac{1}{\sigma^2} \mathbb{E}[\mathbf{z}_n]^{\text{T}}\mathbf{W}^{\text{T}}(\mathbf{x}_n - \boldsymbol{\mu}) \\
&\quad \left. + \frac{1}{2\sigma^2} \text{Tr}(\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}]\mathbf{W}^{\text{T}}\mathbf{W}) \right\}. \tag{12.53}
\end{aligned}
$$

Note that this depends on the posterior distribution only through the sufﬁcient statistics of the Gaussian. Thus in the E step, we use the old parameter values to evaluate

$$
\mathbb{E}[\mathbf{z}_n] = \mathbf{M}^{-1}\mathbf{W}^{\text{T}}(\mathbf{x}_n - \bar{\mathbf{x}}) \tag{12.54}
$$

$$
\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] = \sigma^2\mathbf{M}^{-1} + \mathbb{E}[\mathbf{z}_n]\mathbb{E}[\mathbf{z}_n]^{\text{T}} \tag{12.55}
$$

which follow directly from the posterior distribution (12.42) together with the standard result $\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] = \text{cov}[\mathbf{z}_n] + \mathbb{E}[\mathbf{z}_n]\mathbb{E}[\mathbf{z}_n]^{\text{T}}$. Here $\mathbf{M}$ is deﬁned by (12.41).

In the M step, we maximize with respect to $\mathbf{W}$ and $\sigma^2$, keeping the posterior statistics ﬁxed. Maximization with respect to $\sigma^2$ is straightforward. For the maximization with respect to $\mathbf{W}$ we make use of (C.24), and obtain the M-step equations

$$
\mathbf{W}_{\text{new}} = \left[ \sum_{n=1}^N (\mathbf{x}_n - \bar{\mathbf{x}})\mathbb{E}[\mathbf{z}_n]^{\text{T}} \right] \left[ \sum_{n=1}^N \mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] \right]^{-1} \tag{12.56}
$$

$$
\sigma^2_{\text{new}} = \frac{1}{ND} \sum_{n=1}^N \left\{ \|\mathbf{x}_n - \bar{\mathbf{x}}\|^2 - 2\mathbb{E}[\mathbf{z}_n]^{\text{T}}\mathbf{W}_{\text{new}}^{\text{T}}(\mathbf{x}_n - \bar{\mathbf{x}}) + \text{Tr}(\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}]\mathbf{W}_{\text{new}}^{\text{T}}\mathbf{W}_{\text{new}}) \right\}. \tag{12.57}
$$

The EM algorithm for probabilistic PCA proceeds by initializing the parameters and then alternately computing the sufﬁcient statistics of the latent space posterior distribution using (12.54) and (12.55) in the E step and revising the parameter values using (12.56) and (12.57) in the M step.

One of the beneﬁts of the EM algorithm for PCA is computational efﬁciency for large-scale applications (Roweis, 1998). Unlike conventional PCA based on an
