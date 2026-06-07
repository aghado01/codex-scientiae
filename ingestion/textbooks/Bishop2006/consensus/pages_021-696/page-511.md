[Page 511]

distribution that factorizes between the latent variables and the parameters, so that $q(\mathbf{Z}, \boldsymbol{\eta}) = q(\mathbf{Z})q(\boldsymbol{\eta})$. Using the general result (10.9), we can solve for the two factors as follows

$$
\begin{aligned}
\ln q^\star(\mathbf{Z}) &= \mathbb{E}_{\boldsymbol{\eta}}[\ln p(\mathbf{X}, \mathbf{Z}|\boldsymbol{\eta})] + \text{const} \\
&= \sum_{n=1}^N \left\{ \ln h(\mathbf{x}_n, \mathbf{z}_n) + \mathbb{E}[\boldsymbol{\eta}^{\text{T}}]\mathbf{u}(\mathbf{x}_n, \mathbf{z}_n) \right\} + \text{const}.
\end{aligned} \tag{10.115}
$$

Thus we see that this decomposes into a sum of independent terms, one for each value of $n$, and hence the solution for $q^\star(\mathbf{Z})$ will factorize over $n$ so that $q(\mathbf{Z}) = \prod_n q(\mathbf{z}_n)$. This is an example of an induced factorization. Taking the exponential of both sides, we have

$$
q^\star(\mathbf{z}_n) = h(\mathbf{x}_n, \mathbf{z}_n)g(\mathbb{E}[\boldsymbol{\eta}]) \exp \left\{ \mathbb{E}[\boldsymbol{\eta}^{\text{T}}]\mathbf{u}(\mathbf{x}_n, \mathbf{z}_n) \right\} \tag{10.116}
$$

where the normalization coefﬁcient has been re-instated by comparison with the standard form for the exponential family.

Similarly, for the variational distribution over the parameters, we have

$$
\ln q^\star(\boldsymbol{\eta}) = \ln p(\boldsymbol{\eta}|\nu_0, \boldsymbol{\chi}_0) + \mathbb{E}_{\mathbf{Z}}[\ln p(\mathbf{X}, \mathbf{Z}|\boldsymbol{\eta})] + \text{const} \tag{10.117}
$$

$$
\begin{aligned}
\ln q^\star(\boldsymbol{\eta}) &= \nu_0 \ln g(\boldsymbol{\eta}) + \boldsymbol{\eta}^{\text{T}}\boldsymbol{\chi}_0 \\
&\quad + \sum_{n=1}^N \left\{ \ln g(\boldsymbol{\eta}) + \boldsymbol{\eta}^{\text{T}}\mathbb{E}_{\mathbf{z}_n}[\mathbf{u}(\mathbf{x}_n, \mathbf{z}_n)] \right\} + \text{const}.
\end{aligned} \tag{10.118}
$$

Again, taking the exponential of both sides, and re-instating the normalization coefﬁcient by inspection, we have

$$
q^\star(\boldsymbol{\eta}) = f(\nu_N, \boldsymbol{\chi}_N)g(\boldsymbol{\eta})^{\nu_N} \exp \left\{ \boldsymbol{\eta}^{\text{T}}\boldsymbol{\chi}_N \right\} \tag{10.119}
$$

where we have deﬁned

$$
\nu_N = \nu_0 + N \tag{10.120}
$$

$$
\boldsymbol{\chi}_N = \boldsymbol{\chi}_0 + \sum_{n=1}^N \mathbb{E}_{\mathbf{z}_n}[\mathbf{u}(\mathbf{x}_n, \mathbf{z}_n)]. \tag{10.121}
$$

Note that the solutions for $q(\mathbf{z}_n)$ and $q(\boldsymbol{\eta})$ are coupled, and so we solve them iteratively in a two-stage procedure. In the variational E step, we evaluate the expected sufﬁcient statistics $\mathbb{E}[\mathbf{u}(\mathbf{x}_n, \mathbf{z}_n)]$ using the current posterior distribution $q(\mathbf{z}_n)$ over the latent variables and use this to compute a revised posterior distribution $q(\boldsymbol{\eta})$ over the parameters. Then in the subsequent variational M step, we use this revised parameter posterior distribution to ﬁnd the expected natural parameters $\mathbb{E}[\boldsymbol{\eta}^{\text{T}}]$, which gives rise to a revised variational distribution over the latent variables.

### 10.4.1 Variational message passing

We have illustrated the application of variational methods by considering a speciﬁc model, the Bayesian mixture of Gaussians, in some detail. This model can be
