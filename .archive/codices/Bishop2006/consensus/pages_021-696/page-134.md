[Page 134]

which we can solve for $\mu$ to give $\mu = \sigma(\eta)$, where

$$
\sigma(\eta) = \frac{1}{1 + \exp(-\eta)} \tag{2.199}
$$

is called the logistic sigmoid function. Thus we can write the Bernoulli distribution using the standard representation (2.194) in the form

$$
p(x|\eta) = \sigma(-\eta)\exp(\eta x) \tag{2.200}
$$

where we have used $1 - \sigma(\eta) = \sigma(-\eta)$, which is easily proved from (2.199). Comparison with (2.194) shows that

$$
\begin{align}
u(x) &= x \tag{2.201} \\
h(x) &= 1 \tag{2.202} \\
g(\eta) &= \sigma(-\eta). \tag{2.203}
\end{align}
$$

Next consider the multinomial distribution that, for a single observation $\mathbf{x}$, takes the form

$$
p(\mathbf{x}|\boldsymbol{\mu}) = \prod_{k=1}^M \mu_k^{x_k} = \exp \left\{ \sum_{k=1}^M x_k \ln \mu_k \right\} \tag{2.204}
$$

where $\mathbf{x} = (x_1, \ldots, x_M)^{\text{T}}$. Again, we can write this in the standard representation (2.194) so that

$$
p(\mathbf{x}|\boldsymbol{\eta}) = \exp(\boldsymbol{\eta}^{\text{T}}\mathbf{x}) \tag{2.205}
$$

where $\eta_k = \ln \mu_k$, and we have defined $\boldsymbol{\eta} = (\eta_1, \ldots, \eta_M)^{\text{T}}$. Again, comparing with (2.194) we have

$$
\begin{align}
\mathbf{u}(\mathbf{x}) &= \mathbf{x} \tag{2.206} \\
h(\mathbf{x}) &= 1 \tag{2.207} \\
g(\boldsymbol{\eta}) &= 1. \tag{2.208}
\end{align}
$$

Note that the parameters $\eta_k$ are not independent because the parameters $\mu_k$ are subject to the constraint

$$
\sum_{k=1}^M \mu_k = 1 \tag{2.209}
$$

so that, given any $M - 1$ of the parameters $\mu_k$, the value of the remaining parameter is fixed. In some circumstances, it will be convenient to remove this constraint by expressing the distribution in terms of only $M - 1$ parameters. This can be achieved by using the relationship (2.209) to eliminate $\mu_M$ by expressing it in terms of the remaining $\{\mu_k\}$ where $k = 1, \ldots, M - 1$, thereby leaving $M - 1$ parameters. Note that these remaining parameters are still subject to the constraints

$$
0 \leqslant \mu_k \leqslant 1, \quad \sum_{k=1}^{M-1} \mu_k \leqslant 1. \tag{2.210}
$$
