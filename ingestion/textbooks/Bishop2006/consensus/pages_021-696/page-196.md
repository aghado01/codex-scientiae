[Page 196]

Show that the corresponding posterior distribution takes the same functional form, so that

$$
p(\mathbf{w}, \beta | \mathbf{t}) = \mathcal{N}(\mathbf{w} | \mathbf{m}_N, \beta^{-1} \mathbf{S}_N) \text{Gam}(\beta | a_N, b_N) \tag{3.113}
$$

and find expressions for the posterior parameters $\mathbf{m}_N$, $\mathbf{S}_N$, $a_N$, and $b_N$.

3.13 ($\star$) Show that the predictive distribution $p(t|\mathbf{x},\mathbf{t})$ for the model discussed in Exercise 3.12 is given by a Student's t-distribution of the form

$$
p(t|\mathbf{x}, \mathbf{t}) = \text{St}(t|\mu, \lambda, \nu) \tag{3.114}
$$

and obtain expressions for $\mu$, $\lambda$ and $\nu$.

3.14 ($\star$) In this exercise, we explore in more detail the properties of the equivalent kernel defined by (3.62), where $\mathbf{S}_N$ is defined by (3.54). Suppose that the basis functions $\phi_j(\mathbf{x})$ are linearly independent and that the number $N$ of data points is greater than the number $M$ of basis functions. Furthermore, let one of the basis functions be constant, say $\phi_0(\mathbf{x}) = 1$. By taking suitable linear combinations of these basis functions, we can construct a new basis set $\psi_j(\mathbf{x})$ spanning the same space but that are orthonormal, so that

$$
\sum_{n=1}^N \psi_j(\mathbf{x}_n)\psi_k(\mathbf{x}_n) = I_{jk} \tag{3.115}
$$

where $I_{jk}$ is defined to be $1$ if $j = k$ and $0$ otherwise, and we take $\psi_0(\mathbf{x}) = 1$. Show that for $\alpha = 0$, the equivalent kernel can be written as $k(\mathbf{x},\mathbf{x}') = \boldsymbol{\psi}(\mathbf{x})^{\text{T}}\boldsymbol{\psi}(\mathbf{x}')$

where $\boldsymbol{\psi} = (\psi_1,\ldots,\psi_M)^{\text{T}}$. Use this result to show that the kernel satisfies the summation constraint

$$
\sum_{n=1}^N k(\mathbf{x},\mathbf{x}_n) = 1. \tag{3.116}
$$

3.15 ($\star$) www Consider a linear basis function model for regression in which the parameters $\alpha$ and $\beta$ are set using the evidence framework. Show that the function $E(\mathbf{m}_N)$ defined by (3.82) satisfies the relation $2E(\mathbf{m}_N) = N$.

3.16 ($\star$) Derive the result (3.86) for the log evidence function $\ln p(\mathbf{t}|\alpha,\beta)$ of the linear regression model by making use of (2.115) to evaluate the integral (3.77) directly.

3.17 ($\star$) Show that the evidence function for the Bayesian linear regression model can be written in the form (3.78) in which $E(\mathbf{w})$ is defined by (3.79).

3.18 ($\star\star$) www By completing the square over $\mathbf{w}$, show that the error function (3.79) in Bayesian linear regression can be written in the form (3.80).

3.19 ($\star\star$) Show that the integration over $\mathbf{w}$ in the Bayesian linear regression model gives the result (3.85). Hence show that the log marginal likelihood is given by (3.86).
