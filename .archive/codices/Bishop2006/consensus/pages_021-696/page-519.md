[Page 519]

we reproduce here for convenience

$$
\sigma(z) \geqslant \sigma(\xi) \exp \left\{ (z - \xi)/2 - \lambda(\xi)(z^2 - \xi^2) \right\} \tag{10.149}
$$

where

$$
\lambda(\xi) = \frac{1}{2\xi} \left[ \sigma(\xi) - \frac{1}{2} \right]. \tag{10.150}
$$

We can therefore write

$$
p(t|\mathbf{w}) = e^{at}\sigma(-a) \geqslant e^{at}\sigma(\xi) \exp \left\{ -(a + \xi)/2 - \lambda(\xi)(a^2 - \xi^2) \right\}. \tag{10.151}
$$

Note that because this bound is applied to each of the terms in the likelihood function separately, there is a variational parameter $\xi_n$ corresponding to each training set observation $(\boldsymbol{\phi}_n, t_n)$. Using $a = \mathbf{w}^{\text{T}}\boldsymbol{\phi}$, and multiplying by the prior distribution, we obtain the following bound on the joint distribution of $\mathbf{t}$ and $\mathbf{w}$

$$
p(\mathbf{t}, \mathbf{w}) = p(\mathbf{t}|\mathbf{w})p(\mathbf{w}) \geqslant h(\mathbf{w}, \boldsymbol{\xi})p(\mathbf{w}) \tag{10.152}
$$

where $\boldsymbol{\xi}$ denotes the set $\{\xi_n\}$ of variational parameters, and

$$
\begin{aligned}
h(\mathbf{w}, \boldsymbol{\xi}) &= \prod_{n=1}^N \sigma(\xi_n) \exp \left\{ \mathbf{w}^{\text{T}}\boldsymbol{\phi}_n t_n - (\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n + \xi_n)/2 \right. \\
&\quad \left. - \lambda(\xi_n)([\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n]^2 - \xi_n^2) \right\}.
\end{aligned} \tag{10.153}
$$

Evaluation of the exact posterior distribution would require normalization of the lefthand side of this inequality. Because this is intractable, we work instead with the right-hand side. Note that the function on the right-hand side cannot be interpreted as a probability density because it is not normalized. Once it is normalized to give a variational posterior distribution $q(\mathbf{w})$, however, it no longer represents a bound.

Because the logarithm function is monotonically increasing, the inequality $A \geqslant B$ implies $\ln A \geqslant \ln B$. This gives a lower bound on the log of the joint distribution of $\mathbf{t}$ and $\mathbf{w}$ of the form

$$
\begin{aligned}
\ln \{p(\mathbf{t}|\mathbf{w})p(\mathbf{w})\} &\geqslant \ln p(\mathbf{w}) + \sum_{n=1}^N \left\{ \ln \sigma(\xi_n) + \mathbf{w}^{\text{T}}\boldsymbol{\phi}_n t_n \right. \\
&\quad \left. - (\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n + \xi_n)/2 - \lambda(\xi_n)([\mathbf{w}^{\text{T}}\boldsymbol{\phi}_n]^2 - \xi_n^2) \right\}.
\end{aligned} \tag{10.154}
$$

Substituting for the prior $p(\mathbf{w})$, the right-hand side of this inequality becomes, as a function of $\mathbf{w}$

$$
-\frac{1}{2} (\mathbf{w} - \mathbf{m}_0)^{\text{T}}\mathbf{S}_0^{-1}(\mathbf{w} - \mathbf{m}_0) + \sum_{n=1}^N \left\{ \mathbf{w}^{\text{T}}\boldsymbol{\phi}_n(t_n - 1/2) - \lambda(\xi_n)\mathbf{w}^{\text{T}}(\boldsymbol{\phi}_n\boldsymbol{\phi}_n^{\text{T}})\mathbf{w} \right\} + \text{const}. \tag{10.155}
$$
