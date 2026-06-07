[Page 378]

7.8 ( $\star$ ) www For the regression support vector machine considered in Section 7.1.4, show that all training data points for which $\xi_n > 0$ will have $a_n = C$, and similarly all points for which $\widehat{\xi}_n > 0$ will have $\widehat{a}_n = C$.

7.9 ( $\star$ ) Verify the results (7.82) and (7.83) for the mean and covariance of the posterior distribution over weights in the regression RVM.

7.10 ( $\star\star$ ) www Derive the result (7.85) for the marginal likelihood function in the regression RVM, by performing the Gaussian integral over $\mathbf{w}$ in (7.84) using the technique of completing the square in the exponential.

7.11 ( $\star\star$ ) Repeat the above exercise, but this time make use of the general result (2.115).

7.12 ( $\star\star$ ) www Show that direct maximization of the log marginal likelihood (7.85) for the regression relevance vector machine leads to the re-estimation equations (7.87) and (7.88) where $\gamma_i$ is deﬁned by (7.89).

7.13 ( $\star\star$ ) In the evidence framework for RVM regression, we obtained the re-estimation formulae (7.87) and (7.88) by maximizing the marginal likelihood given by (7.85). Extend this approach by inclusion of hyperpriors given by gamma distributions of the form (B.26) and obtain the corresponding re-estimation formulae for $\boldsymbol{\alpha}$ and $\beta$ by maximizing the corresponding posterior probability $p(\mathbf{t}, \boldsymbol{\alpha}, \beta|\mathbf{X})$ with respect to $\boldsymbol{\alpha}$ and $\beta$.

7.14 ( $\star\star$ ) Derive the result (7.90) for the predictive distribution in the relevance vector machine for regression. Show that the predictive variance is given by (7.91).

7.15 ( $\star\star$ ) www Using the results (7.94) and (7.95), show that the marginal likelihood (7.85) can be written in the form (7.96), where $\lambda(\alpha_n)$ is deﬁned by (7.97) and the sparsity and quality factors are deﬁned by (7.98) and (7.99), respectively.

7.16 ( $\star\star$ ) By taking the second derivative of the log marginal likelihood (7.97) for the regression RVM with respect to the hyperparameter $\alpha_i$, show that the stationary point given by (7.101) is a maximum of the marginal likelihood.

7.17 ( $\star\star$ ) Using (7.83) and (7.86), together with the matrix identity (C.7), show that the quantities $S_n$ and $Q_n$ deﬁned by (7.102) and (7.103) can be written in the form (7.106) and (7.107).

7.18 ( $\star$ ) www Show that the gradient vector and Hessian matrix of the log posterior distribution (7.109) for the classiﬁcation relevance vector machine are given by (7.110) and (7.111).

7.19 ( $\star\star$ ) Verify that maximization of the approximate log marginal likelihood function (7.114) for the classiﬁcation relevance vector machine leads to the result (7.116) for re-estimation of the hyperparameters.
