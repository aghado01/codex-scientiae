# Chapter 3 Exercises

[Page 193]


## 3.1 Tanh and Sigmoid Function Equivalence

Show that the ‘tanh’ function and the logistic sigmoid function (3.6) are related by
$$
\tanh(a) = 2\sigma(2a) - 1. \tag{3.100}
$$
Hence show that a general linear combination of logistic sigmoid functions of the form
$$
y(x, \mathbf{w}) = w_0 + \sum_{j=1}^M w_j \sigma\left(\frac{x - \mu_j}{s}\right) \tag{3.101}
$$
is equivalent to a linear combination of ‘tanh’ functions of the form
$$
y(x, \mathbf{u}) = u_0 + \sum_{j=1}^M u_j \tanh\left(\frac{x - \mu_j}{s}\right) \tag{3.102}
$$
and find expressions to relate the new parameters $\{u_1, \ldots, u_M\}$ to the original parameters $\{w_1, \ldots, w_M\}$.
[Page 194]

## 3.2 Least-Squares as Orthogonal Projection

Show that the matrix
$$
\mathbf{\Phi}(\mathbf{\Phi}^{\mathrm{T}}\mathbf{\Phi})^{-1}\mathbf{\Phi}^{\mathrm{T}}
\tag{3.103}
$$
takes any vector $\mathbf{v}$ and projects it onto the space spanned by the columns of $\mathbf{\Phi}$. Use this result to show that the least-squares solution (3.15) corresponds to an orthogonal projection of the vector $\mathbf{t}$ onto the manifold $\mathcal{S}$ as shown in Figure 3.2.

## 3.3 Weighted Sum-of-Squares Error Interpretations

Consider a data set in which each data point $t_n$ is associated with a weighting factor $r_n > 0$, so that the sum-of-squares error function becomes
$$
E_D(\mathbf{w}) = \frac{1}{2} \sum_{n=1}^{N} r_n \{ t_n - \mathbf{w}^{\mathrm{T}}\boldsymbol{\phi}(\mathbf{x}_n) \}^2 .
\tag{3.104}
$$
Find an expression for the solution $\mathbf{w}^{\star}$ that minimizes this error function. Give two alternative interpretations of the weighted sum-of-squares error function in terms of (i) data dependent noise variance and (ii) replicated data points.

## 3.4 Input Noise Equivalent to Weight Decay

Consider a linear model of the form
$$
y(\mathbf{x}, \mathbf{w}) = w_0 + \sum_{i=1}^{D} w_i x_i
\tag{3.105}
$$
together with a sum-of-squares error function of the form
$$
E_D(\mathbf{w}) = \frac{1}{2} \sum_{n=1}^{N} \{ y(\mathbf{x}_n, \mathbf{w}) - t_n \}^2 .
\tag{3.106}
$$
Now suppose that Gaussian noise $\epsilon_i$ with zero mean and variance $\sigma^2$ is added independently to each of the input variables $x_i$. By making use of $\mathbb{E}[\epsilon_i] = 0$ and $\mathbb{E}[\epsilon_i \epsilon_j] = \delta_{ij}\sigma^2$, show that minimizing $E_D$ averaged over the noise distribution is equivalent to minimizing the sum-of-squares error for noise-free input variables with the addition of a weight-decay regularization term, in which the bias parameter $w_0$ is omitted from the regularizer.

## 3.5 Regularization via Lagrange Multipliers

Using the technique of Lagrange multipliers, discussed in Appendix E, show that minimization of the regularized error function (3.29) is equivalent to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint (3.30). Discuss the relationship between the parameters $\eta$ and $\lambda$.

## 3.6 Maximum Likelihood for Multivariate Targets

Consider a linear basis function regression model for a multivariate target variable $\mathbf{t}$ having a Gaussian distribution of the form
$$
p(\mathbf{t}|\mathbf{W}, \mathbf{\Sigma}) = \mathcal{N}(\mathbf{t}|\mathbf{y}(\mathbf{x}, \mathbf{W}), \mathbf{\Sigma})
\tag{3.107}
$$
where
$$
\mathbf{y}(\mathbf{x}, \mathbf{W}) = \mathbf{W}^{\mathrm{T}}\boldsymbol{\phi}(\mathbf{x})
\tag{3.108}
$$
together with a training data set comprising input basis vectors $\boldsymbol{\phi}(\mathbf{x}_n)$ and corresponding target vectors $\mathbf{t}_n$, with $n = 1, \ldots, N$. Show that the maximum likelihood solution $\mathbf{W}_{\mathrm{ML}}$ for the parameter matrix $\mathbf{W}$ has the property that each column is given by an expression of the form (3.15), which was the solution for an isotropic noise distribution. Note that this is independent of the covariance matrix $\mathbf{\Sigma}$. Show that the maximum likelihood solution for $\mathbf{\Sigma}$ is given by
[Page 195]

together with a training data set comprising input basis vectors $\boldsymbol{\phi}(\mathbf{x}_n)$ and corresponding target vectors $\mathbf{t}_n$, with $n = 1,\ldots,N$. Show that the maximum likelihood solution $\mathbf{W}_{\text{ML}}$ for the parameter matrix $\mathbf{W}$ has the property that each column is given by an expression of the form (3.15), which was the solution for an isotropic noise distribution. Note that this is independent of the covariance matrix $\boldsymbol{\Sigma}$. Show that the maximum likelihood solution for $\boldsymbol{\Sigma}$ is given by

$$
\boldsymbol{\Sigma} = \frac{1}{N} \sum_{n=1}^{N} \left( \mathbf{t}_n - \mathbf{W}_{\text{ML}}^{\text{T}} \boldsymbol{\phi}(\mathbf{x}_n) \right) \left( \mathbf{t}_n - \mathbf{W}_{\text{ML}}^{\text{T}} \boldsymbol{\phi}(\mathbf{x}_n) \right)^{\text{T}}. \tag{3.109}
$$

## 3.7 Posterior Distribution via Completing Square ($\star$)

By using the technique of completing the square, verify the result (3.49) for the posterior distribution of the parameters $\mathbf{w}$ in the linear basis function model in which $\mathbf{m}_N$ and $\mathbf{S}_N$ are defined by (3.50) and (3.51) respectively.

## 3.8 Sequential Update of Posterior Distribution ($\star$)

Consider the linear basis function model in Section 3.1, and suppose that we have already observed $N$ data points, so that the posterior distribution over $\mathbf{w}$ is given by (3.49). This posterior can be regarded as the prior for the next observation. By considering an additional data point $(\mathbf{x}_{N+1}, t_{N+1})$, and by completing the square in the exponential, show that the resulting posterior distribution is again given by (3.49) but with $\mathbf{S}_N$ replaced by $\mathbf{S}_{N+1}$ and $\mathbf{m}_N$ replaced by $\mathbf{m}_{N+1}$.

## 3.9 Sequential Update via Linear-Gaussian Models ($\star$)

Repeat the previous exercise but instead of completing the square by hand, make use of the general result for linear-Gaussian models given by (2.116).

## 3.10 Predictive Distribution for Bayesian Regression ($\star$)

By making use of the result (2.115) to evaluate the integral in (3.57), verify that the predictive distribution for the Bayesian linear regression model is given by (3.58) in which the input-dependent variance is given by (3.59).

## 3.11 Monotonic Decrease of Predictive Uncertainty ($\star$)

We have seen that, as the size of a data set increases, the uncertainty associated with the posterior distribution over model parameters decreases. Make use of the matrix identity (Appendix C)

$$
(\mathbf{M} + \mathbf{v}\mathbf{v}^{\text{T}})^{-1} = \mathbf{M}^{-1} - \frac{(\mathbf{M}^{-1}\mathbf{v})(\mathbf{v}^{\text{T}}\mathbf{M}^{-1})}{1 + \mathbf{v}^{\text{T}}\mathbf{M}^{-1}\mathbf{v}} \tag{3.110}
$$

to show that the uncertainty $\sigma_N^2(\mathbf{x})$ associated with the linear regression function given by (3.59) satisfies

$$
\sigma_{N+1}^2(\mathbf{x}) \le \sigma_N^2(\mathbf{x}). \tag{3.111}
$$

## 3.12 Normal-Gamma Conjugate Posterior Derivation ($\star$)

We saw in Section 2.3.6 that the conjugate prior for a Gaussian distribution with unknown mean and unknown precision (inverse variance) is a normal-gamma distribution. This property also holds for the case of the conditional Gaussian distribution $p(t|\mathbf{x}, \mathbf{w}, \beta)$ of the linear regression model. If we consider the likelihood function (3.10), then the conjugate prior for $\mathbf{w}$ and $\beta$ is given by

$$
p(\mathbf{w}, \beta) = \mathcal{N}(\mathbf{w}|\mathbf{m}_0, \beta^{-1}\mathbf{S}_0)\text{Gam}(\beta|a_0, b_0). \tag{3.112}
$$
[Page 196]

Show that the corresponding posterior distribution takes the same functional form, so that

$$
p(\mathbf{w}, \beta | \mathbf{t}) = \mathcal{N}(\mathbf{w} | \mathbf{m}_N, \beta^{-1} \mathbf{S}_N) \text{Gam}(\beta | a_N, b_N) \tag{3.113}
$$

and find expressions for the posterior parameters $\mathbf{m}_N$, $\mathbf{S}_N$, $a_N$, and $b_N$.

## 3.13 Predictive Student's t-Distribution Derivation ($\star$)

Show that the predictive distribution $p(t|\mathbf{x},\mathbf{t})$ for the model discussed in Exercise 3.12 is given by a Student's t-distribution of the form

$$
p(t|\mathbf{x}, \mathbf{t}) = \text{St}(t|\mu, \lambda, \nu) \tag{3.114}
$$

and obtain expressions for $\mu$, $\lambda$ and $\nu$.

## 3.14 Summation Constraint for Equivalent Kernel ($\star$)

In this exercise, we explore in more detail the properties of the equivalent kernel defined by (3.62), where $\mathbf{S}_N$ is defined by (3.54). Suppose that the basis functions $\phi_j(\mathbf{x})$ are linearly independent and that the number $N$ of data points is greater than the number $M$ of basis functions. Furthermore, let one of the basis functions be constant, say $\phi_0(\mathbf{x}) = 1$. By taking suitable linear combinations of these basis functions, we can construct a new basis set $\psi_j(\mathbf{x})$ spanning the same space but that are orthonormal, so that

$$
\sum_{n=1}^N \psi_j(\mathbf{x}_n)\psi_k(\mathbf{x}_n) = I_{jk} \tag{3.115}
$$

where $I_{jk}$ is defined to be $1$ if $j = k$ and $0$ otherwise, and we take $\psi_0(\mathbf{x}) = 1$. Show that for $\alpha = 0$, the equivalent kernel can be written as $k(\mathbf{x},\mathbf{x}') = \boldsymbol{\psi}(\mathbf{x})^{\text{T}}\boldsymbol{\psi}(\mathbf{x}')$

where $\boldsymbol{\psi} = (\psi_1,\ldots,\psi_M)^{\text{T}}$. Use this result to show that the kernel satisfies the summation constraint

$$
\sum_{n=1}^N k(\mathbf{x},\mathbf{x}_n) = 1. \tag{3.116}
$$

## 3.15 Evidence Framework Energy Relation ($\star$)

Consider a linear basis function model for regression in which the parameters $\alpha$ and $\beta$ are set using the evidence framework. Show that the function $E(\mathbf{m}_N)$ defined by (3.82) satisfies the relation $2E(\mathbf{m}_N) = N$.

## 3.16 Direct Evaluation of Log Evidence ($\star$)

Derive the result (3.86) for the log evidence function $\ln p(\mathbf{t}|\alpha,\beta)$ of the linear regression model by making use of (2.115) to evaluate the integral (3.77) directly.

## 3.17 Evidence Function Form Derivation ($\star$)

Show that the evidence function for the Bayesian linear regression model can be written in the form (3.78) in which $E(\mathbf{w})$ is defined by (3.79).

## 3.18 Error Function by Completing the Square ($\star\star$)

By completing the square over $\mathbf{w}$, show that the error function (3.79) in Bayesian linear regression can be written in the form (3.80).

## 3.19 Marginal Likelihood Integration Derivation ($\star\star$)

Show that the integration over $\mathbf{w}$ in the Bayesian linear regression model gives the result (3.85). Hence show that the log marginal likelihood is given by (3.86).
[Page 197]

- 3.20 ( ) www Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to $\alpha$ leads to the re-estimation equation (3.92).

- 3.21 ( ) An alternative way to derive the result (3.92) for the optimal value of $\alpha$ in the evidence framework is to make use of the identity
$$
\frac{d}{d\alpha} \ln |\mathbf{A}| = \text{Tr} \left( \mathbf{A}^{-1} \frac{d}{d\alpha} \mathbf{A} \right) \tag{3.117}
$$
Prove this identity by considering the eigenvalue expansion of a real, symmetric matrix $\mathbf{A}$, and making use of the standard results for the determinant and trace of $\mathbf{A}$ expressed in terms of its eigenvalues (Appendix C). Then make use of (3.117) to derive (3.92) starting from (3.86).

- 3.22 ( ) Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to $\beta$ leads to the re-estimation equation (3.95).

- 3.23 ( ) www Show that the marginal probability of the data, in other words the model evidence, for the model described in Exercise 3.12 is given by
$$
p(\mathbf{t}) = \frac{1}{(2\pi)^{N/2}} \frac{b_0^{a_0}}{b_N^{a_N}} \frac{\Gamma(a_N)}{\Gamma(a_0)} \frac{|\mathbf{S}_N|^{1/2}}{|\mathbf{S}_0|^{1/2}} \tag{3.118}
$$
by first marginalizing with respect to $\mathbf{w}$ and then with respect to $\beta$.

- 3.24 ( ) Repeat the previous exercise but now use Bayes’ theorem in the form
$$
p(\mathbf{t}) = \frac{p(\mathbf{t}|\mathbf{w},\beta)p(\mathbf{w},\beta)}{p(\mathbf{w},\beta|\mathbf{t})} \tag{3.119}
$$
and then substitute for the prior and posterior distributions and the likelihood function in order to derive the result (3.118).
[Page 198]