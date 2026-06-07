[Page 509]

where we have evaluated the integral by making use of the result (2.115) for the linear-Gaussian model. Here the input-dependent variance is given by

$$
\sigma^2(\mathbf{x}) = \frac{1}{\beta} + \boldsymbol{\phi}(\mathbf{x})^{\text{T}}\mathbf{S}_N\boldsymbol{\phi}(\mathbf{x}). \tag{10.106}
$$

Note that this takes the same form as the result (3.59) obtained with ﬁxed $\alpha$ except that now the expected value $\mathbb{E}[\alpha]$ appears in the deﬁnition of $\mathbf{S}_N$.

### 10.3.3 Lower bound

Another quantity of importance is the lower bound $\mathcal{L}$ deﬁned by

$$
\begin{aligned}
\mathcal{L}(q) &= \mathbb{E}[\ln p(\mathbf{w}, \alpha, \mathbf{t})] - \mathbb{E}[\ln q(\mathbf{w}, \alpha)] \\
&= \mathbb{E}_{\mathbf{w}}[\ln p(\mathbf{t}|\mathbf{w})] + \mathbb{E}_{\mathbf{w}, \alpha}[\ln p(\mathbf{w}|\alpha)] + \mathbb{E}_{\alpha}[\ln p(\alpha)] \\
&\quad - \mathbb{E}_{\mathbf{w}}[\ln q(\mathbf{w})] - \mathbb{E}_{\alpha}[\ln q(\alpha)].
\end{aligned} \tag{10.107}
$$

Evaluation of the various terms is straightforward, making use of results obtained in previous chapters, and gives

$$
\begin{aligned}
\mathbb{E}_{\mathbf{w}}[\ln p(\mathbf{t}|\mathbf{w})] &= \frac{N}{2} \ln \left( \frac{\beta}{2\pi} \right) - \frac{\beta}{2} \mathbf{t}^{\text{T}}\mathbf{t} + \beta \mathbf{m}_N^{\text{T}} \boldsymbol{\Phi}^{\text{T}}\mathbf{t} \\
&\quad - \frac{\beta}{2} \text{Tr} \left[ \boldsymbol{\Phi}^{\text{T}}\boldsymbol{\Phi} (\mathbf{m}_N \mathbf{m}_N^{\text{T}} + \mathbf{S}_N) \right]
\end{aligned} \tag{10.108}
$$

$$
\begin{aligned}
\mathbb{E}_{\mathbf{w}, \alpha}[\ln p(\mathbf{w}|\alpha)] &= -\frac{M}{2} \ln(2\pi) + \frac{M}{2} (\psi(a_N) - \ln b_N) \\
&\quad - \frac{a_N}{2b_N} [\mathbf{m}_N^{\text{T}}\mathbf{m}_N + \text{Tr}(\mathbf{S}_N)]
\end{aligned} \tag{10.109}
$$

$$
\begin{aligned}
\mathbb{E}_{\alpha}[\ln p(\alpha)] &= a_0 \ln b_0 + (a_0 - 1)[\psi(a_N) - \ln b_N] \\
&\quad - b_0 \frac{a_N}{b_N} - \ln \Gamma(a_N)
\end{aligned} \tag{10.110}
$$

$$
-\mathbb{E}_{\mathbf{w}}[\ln q(\mathbf{w})] = \frac{1}{2} \ln |\mathbf{S}_N| + \frac{M}{2} [1 + \ln(2\pi)] \tag{10.111}
$$

$$
-\mathbb{E}_{\alpha}[\ln q(\alpha)] = \ln \Gamma(a_N) - (a_N - 1)\psi(a_N) - \ln b_N + a_N. \tag{10.112}
$$

Figure 10.9 shows a plot of the lower bound $\mathcal{L}(q)$ versus the degree of a polynomial model for a synthetic data set generated from a degree three polynomial. Here the prior parameters have been set to $a_0 = b_0 = 0$, corresponding to the noninformative prior $p(\alpha) \propto 1/\alpha$, which is uniform over $\ln \alpha$ as discussed in Section 2.3.6. As we saw in Section 10.1, the quantity $\mathcal{L}$ represents lower bound on the log marginal likelihood $p(\mathbf{t}|\mathcal{M})$ for the model. If we assign equal prior probabilities $p(\mathcal{M})$ to the different values of $M$, then we can interpret $\mathcal{L}$ as an approximation to the posterior model probability $p(\mathcal{M}|\mathbf{t})$. Thus the variational framework assigns the highest probability to the model with $M = 3$. This should be contrasted with the maximum likelihood result, which assigns ever smaller residual error to models of increasing complexity until the residual error is driven to zero, causing maximum likelihood to favour severely over-ﬁtted models.
