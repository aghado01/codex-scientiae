[Page 508]

where

$$
\mathbf{m}_N = \beta \mathbf{S}_N \boldsymbol{\Phi}^{\text{T}} \mathbf{t} \tag{10.100}
$$

$$
\mathbf{S}_N = (\mathbb{E}[\alpha]\mathbf{I} + \beta \boldsymbol{\Phi}^{\text{T}}\boldsymbol{\Phi})^{-1}. \tag{10.101}
$$

Note the close similarity to the posterior distribution (3.52) obtained when $\alpha$ was treated as a ﬁxed parameter. The difference is that here $\alpha$ is replaced by its expectation $\mathbb{E}[\alpha]$ under the variational distribution. Indeed, we have chosen to use the same notation for the covariance matrix $\mathbf{S}_N$ in both cases.

Using the standard results (B.27), (B.38), and (B.39), we can obtain the required moments as follows

$$
\mathbb{E}[\alpha] = a_N / b_N \tag{10.102}
$$

$$
\mathbb{E}[\mathbf{w}\mathbf{w}^{\text{T}}] = \mathbf{m}_N \mathbf{m}_N^{\text{T}} + \mathbf{S}_N. \tag{10.103}
$$

The evaluation of the variational posterior distribution begins by initializing the parameters of one of the distributions $q(\mathbf{w})$ or $q(\alpha)$, and then alternately re-estimates these factors in turn until a suitable convergence criterion is satisﬁed (usually speciﬁed in terms of the lower bound to be discussed shortly).

It is instructive to relate the variational solution to that found using the evidence framework in Section 3.5. To do this consider the case $a_0 = b_0 = 0$, corresponding to the limit of an inﬁnitely broad prior over $\alpha$. The mean of the variational posterior distribution $q(\alpha)$ is then given by

$$
\mathbb{E}[\alpha] = \frac{a_N}{b_N} = \frac{M/2}{\mathbb{E}[\mathbf{w}^{\text{T}}\mathbf{w}]/2} = \frac{M}{\mathbf{m}_N^{\text{T}}\mathbf{m}_N + \text{Tr}(\mathbf{S}_N)}. \tag{10.104}
$$

Comparison with (9.63) shows that in the case of this particularly simple model, the variational approach gives precisely the same expression as that obtained by maximizing the evidence function using EM except that the point estimate for $\alpha$ is replaced by its expected value. Because the distribution $q(\mathbf{w})$ depends on $q(\alpha)$ only through the expectation $\mathbb{E}[\alpha]$, we see that the two approaches will give identical results for the case of an inﬁnitely broad prior.

### 10.3.2 Predictive distribution

The predictive distribution over $t$, given a new input $\mathbf{x}$, is easily evaluated for this model using the Gaussian variational posterior for the parameters

$$
\begin{aligned}
p(t|\mathbf{x}, \mathbf{t}) &= \int p(t|\mathbf{x}, \mathbf{w})p(\mathbf{w}|\mathbf{t}) \text{d}\mathbf{w} \\
&\simeq \int p(t|\mathbf{x}, \mathbf{w})q(\mathbf{w}) \text{d}\mathbf{w} \\
&= \int \mathcal{N}(t|\mathbf{w}^{\text{T}}\boldsymbol{\phi}(\mathbf{x}), \beta^{-1}) \mathcal{N}(\mathbf{w}|\mathbf{m}_N, \mathbf{S}_N) \text{d}\mathbf{w} \\
&= \mathcal{N}(t|\mathbf{m}_N^{\text{T}}\boldsymbol{\phi}(\mathbf{x}), \sigma^2(\mathbf{x}))
\end{aligned} \tag{10.105}
$$
