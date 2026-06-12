[Page 691]

![Figure 14.9](../../../../../images/imageFile48.png)
**Figure 14.9** The left plot shows the predictive conditional density corresponding to the converged solution in Figure 14.8. This gives a log likelihood value of $-3.0$. A vertical slice through one of these plots at a particular value of $x$ represents the corresponding conditional distribution $p(t|x)$, which we see is bimodal. The plot on the right shows the predictive density for a single linear regression model ﬁtted to the same data set using maximum likelihood. This model has a smaller log likelihood of $-27.6$.

function is then given by

$$
p(\mathbf{t}|\boldsymbol{\theta}) = \prod_{n=1}^N \left( \sum_{k=1}^K \pi_k y_{nk}^{t_n} [1 - y_{nk}]^{1-t_n} \right) \tag{14.46}
$$

where $y_{nk} = \sigma(\mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n)$ and $\mathbf{t} = (t_1, \dots, t_N)^{\text{T}}$. We can maximize this likelihood function iteratively by making use of the EM algorithm. This involves introducing latent variables $z_{nk}$ that correspond to a 1-of-K coded binary indicator variable for each data point $n$. The complete-data likelihood function is then given by

$$
p(\mathbf{t}, \mathbf{Z}|\boldsymbol{\theta}) = \prod_{n=1}^N \prod_{k=1}^K \left\{ \pi_k y_{nk}^{t_n} [1 - y_{nk}]^{1-t_n} \right\}^{z_{nk}} \tag{14.47}
$$

where $\mathbf{Z}$ is the matrix of latent variables with elements $z_{nk}$. We initialize the EM algorithm by choosing an initial value $\boldsymbol{\theta}^{\text{old}}$ for the model parameters. In the E step, we then use these parameter values to evaluate the posterior probabilities of the components $k$ for each data point $n$, which are given by

$$
\gamma_{nk} = \mathbb{E}[z_{nk}] = p(k|\boldsymbol{\phi}_n, \boldsymbol{\theta}^{\text{old}}) = \frac{\pi_k y_{nk}^{t_n} [1 - y_{nk}]^{1-t_n}}{\sum_j \pi_j y_{nj}^{t_n} [1 - y_{nj}]^{1-t_n}}. \tag{14.48}
$$

These responsibilities are then used to ﬁnd the expected complete-data log likelihood as a function of $\boldsymbol{\theta}$, given by

$$
\begin{aligned}
Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}}) &= \mathbb{E}_{\mathbf{Z}}[\ln p(\mathbf{t}, \mathbf{Z}|\boldsymbol{\theta})] \\
&= \sum_{n=1}^N \sum_{k=1}^K \gamma_{nk} \{\ln \pi_k + t_n \ln y_{nk} + (1 - t_n) \ln(1 - y_{nk})\}.
\end{aligned} \tag{14.49}
$$
