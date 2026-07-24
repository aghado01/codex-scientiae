# Chapter 7 Exercises

[Page 377]


## 7.1 Parzen Kernel Density Classification ($\star$)

Suppose we have a data set of input vectors $\{\mathbf{x}_n\}$ with corresponding target values $t_n \in \{-1, 1\}$, and suppose that we model the density of input vectors within each class separately using a Parzen kernel density estimator (see Section 2.5.1) with a kernel $k(\mathbf{x}, \mathbf{x}')$. Write down the minimum misclassification-rate decision rule assuming the two classes have equal prior probability. Show also that, if the kernel is chosen to be $k(\mathbf{x}, \mathbf{x}') = \mathbf{x}^T\mathbf{x}'$, then the classification rule reduces to simply assigning a new input vector to the class having the closest mean. Finally, show that, if the kernel takes the form $k(\mathbf{x}, \mathbf{x}') = \phi(\mathbf{x})^T\boldsymbol{\phi}(\mathbf{x}')$, that the classification is based on the closest mean in the feature space $\boldsymbol{\phi}(\mathbf{x})$.

## 7.2 Maximum Margin Constant Invariance ($\star$)

Show that, if the $1$ on the right-hand side of the constraint (7.5) is replaced by some arbitrary constant $\gamma > 0$, the solution for the maximum margin hyperplane is unchanged.

## 7.3 Two Point Margin Hyperplane ($\star$)

Show that, irrespective of the dimensionality of the data space, a data set consisting of just two data points, one from each class, is sufficient to determine the location of the maximum-margin hyperplane.

## 7.4 Maximum Margin Value Expression ($\star\star$)

Show that the value $\rho$ of the margin for the maximum-margin hyperplane is given by

$$
\frac{1}{\rho^2} = \sum_{n=1}^N a_n \tag{7.123}
$$

where $\{a_n\}$ are given by maximizing (7.10) subject to the constraints (7.11) and (7.12).

## 7.5 Margin Value Alternative Forms ($\star\star$)

Show that the values of $\rho$ and $\{a_n\}$ in the previous exercise also satisfy

$$
\frac{1}{\rho^2} = 2 \widetilde{L}(\mathbf{a}) \tag{7.124}
$$

where $\widetilde{L}(\mathbf{a})$ is defined by (7.10). Similarly, show that

$$
\frac{1}{\rho^2} = \|\mathbf{w}\|^2. \tag{7.125}
$$

## 7.6 Regularized Logistic Regression Formulation ($\star$)

Consider the logistic regression model with a target variable $t \in \{-1, 1\}$. If we define $p(t = 1|y) = \sigma(y)$ where $y(\mathbf{x})$ is given by (7.1), show that the negative log likelihood, with the addition of a quadratic regularization term, takes the form (7.47).

## 7.7 Regression SVM Dual Lagrangian ($\star\star$)

Consider the Lagrangian (7.56) for the regression support vector machine. By setting the derivatives of the Lagrangian with respect to $\mathbf{w}$, $b$, $\xi_n$, and $\widehat{\xi}_n$ to zero and then back substituting to eliminate the corresponding variables, show that the dual Lagrangian is given by (7.61).
[Page 378]

## 7.8 Regression SVM Slack Variables ($\star$)

For the regression support vector machine considered in Section 7.1.4, show that all training data points for which $\xi_n > 0$ will have $a_n = C$, and similarly all points for which $\widehat{\xi}_n > 0$ will have $\widehat{a}_n = C$.

## 7.9 Regression RVM Posterior Weights ($\star$)

Verify the results (7.82) and (7.83) for the mean and covariance of the posterior distribution over weights in the regression RVM.

## 7.10 RVM Marginal Likelihood Integration ($\star\star$)

Derive the result (7.85) for the marginal likelihood function in the regression RVM, by performing the Gaussian integral over $\mathbf{w}$ in (7.84) using the technique of completing the square in the exponential.

## 7.11 RVM Marginal Likelihood General ($\star\star$)

Repeat the above exercise, but this time make use of the general result (2.115).

## 7.12 RVM Marginal Likelihood Maximization ($\star\star$)

Show that direct maximization of the log marginal likelihood (7.85) for the regression relevance vector machine leads to the re-estimation equations (7.87) and (7.88) where $\gamma_i$ is defined by (7.89).

## 7.13 Regression RVM Gamma Hyperpriors ($\star\star$)

In the evidence framework for RVM regression, we obtained the re-estimation formulae (7.87) and (7.88) by maximizing the marginal likelihood given by (7.85). Extend this approach by inclusion of hyperpriors given by gamma distributions of the form (B.26) and obtain the corresponding re-estimation formulae for $\boldsymbol{\alpha}$ and $\beta$ by maximizing the corresponding posterior probability $p(\mathbf{t}, \boldsymbol{\alpha}, \beta|\mathbf{X})$ with respect to $\boldsymbol{\alpha}$ and $\beta$.

## 7.14 RVM Predictive Distribution Variance ($\star\star$)

Derive the result (7.90) for the predictive distribution in the relevance vector machine for regression. Show that the predictive variance is given by (7.91).

## 7.15 RVM Sparsity Quality Factors ($\star\star$)

Using the results (7.94) and (7.95), show that the marginal likelihood (7.85) can be written in the form (7.96), where $\lambda(\alpha_n)$ is defined by (7.97) and the sparsity and quality factors are defined by (7.98) and (7.99), respectively.

## 7.16 RVM Marginal Likelihood Maximum ($\star\star$)

By taking the second derivative of the log marginal likelihood (7.97) for the regression RVM with respect to the hyperparameter $\alpha_i$, show that the stationary point given by (7.101) is a maximum of the marginal likelihood.

## 7.17 RVM Matrix Identity Quantities ($\star\star$)

Using (7.83) and (7.86), together with the matrix identity (C.7), show that the quantities $S_n$ and $Q_n$ defined by (7.102) and (7.103) can be written in the form (7.106) and (7.107).

## 7.18 Classification RVM Gradient Hessian ($\star$)

Show that the gradient vector and Hessian matrix of the log posterior distribution (7.109) for the classification relevance vector machine are given by (7.110) and (7.111).

## 7.19 Classification RVM Hyperparameter Reestimation ($\star\star$)

Verify that maximization of the approximate log marginal likelihood function (7.114) for the classification relevance vector machine leads to the result (7.116) for re-estimation of the hyperparameters.
