# Chapter 6 Exercises

[Page 340]


## 6.1 Dual Least Squares Formulation

Consider the dual formulation of the least squares linear regression problem given in Section 6.1. Show that the solution for the components $a_n$ of the vector $\mathbf{a}$ can be expressed as a linear combination of the elements of the vector $\boldsymbol{\phi}(\mathbf{x}_n)$. Denoting these coefficients by the vector $\mathbf{w}$, show that the dual of the dual formulation is given by the original representation in terms of the parameter vector $\mathbf{w}$.

## 6.2 Dual Perceptron Learning Algorithm

In this exercise, we develop a dual formulation of the perceptron learning algorithm. Using the perceptron learning rule (4.55), show that the learned weight vector $\mathbf{w}$ can be written as a linear combination of the vectors $t_n\boldsymbol{\phi}(\mathbf{x}_n)$ where $t_n \in \{-1,+1\}$. Denote the coefficients of this linear combination by $\alpha_n$ and derive a formulation of the perceptron learning algorithm, and the predictive function for the perceptron, in terms of the $\alpha_n$. Show that the feature vector $\boldsymbol{\phi}(\mathbf{x})$ enters only in the form of the kernel function $k(\mathbf{x},\mathbf{x}') = \boldsymbol{\phi}(\mathbf{x})^T\boldsymbol{\phi}(\mathbf{x}')$.

## 6.3 Kernel Nearest-Neighbour Classifier

The nearest-neighbour classifier (Section 2.5.2) assigns a new input vector $\mathbf{x}$ to the same class as that of the nearest input vector $\mathbf{x}_n$ from the training set, where in the simplest case, the distance is defined by the Euclidean metric $\|\mathbf{x} - \mathbf{x}_n\|^2$. By expressing this rule in terms of scalar products and then making use of kernel substitution, formulate the nearest-neighbour classifier for a general nonlinear kernel.

## 6.4 Positive Eigenvalues Negative Elements

In Appendix C, we give an example of a matrix that has positive elements but that has a negative eigenvalue and hence that is not positive definite. Find an example of the converse property, namely a $2 \times 2$ matrix with positive eigenvalues yet that has at least one negative element.

## 6.5 Valid Kernel Construction Verification

Verify the results (6.13) and (6.14) for constructing valid kernels.

## 6.6 Valid Kernel Product Verification

Verify the results (6.15) and (6.16) for constructing valid kernels.

## 6.7 Valid Kernel Exponentiation Verification

Verify the results (6.17) and (6.18) for constructing valid kernels.

## 6.8 Valid Kernel Polynomial Verification

Verify the results (6.19) and (6.20) for constructing valid kernels.

## 6.9 Valid Kernel Sum Verification

Verify the results (6.21) and (6.22) for constructing valid kernels.

## 6.10 Optimal Function Based Kernel

Show that an excellent choice of kernel for learning a function $f(\mathbf{x})$ is given by $k(\mathbf{x},\mathbf{x}') = f(\mathbf{x})f(\mathbf{x}')$ by showing that a linear learning machine based on this kernel will always find a solution proportional to $f(\mathbf{x})$.
[Page 341]

## 6.11 Gaussian Kernel Infinite Feature Space

By making use of the expansion (6.25), and then expanding the middle factor as a power series, show that the Gaussian kernel (6.23) can be expressed as the inner product of an infinite-dimensional feature vector.

## 6.12 Subset Space Kernel Function

Consider the space of all possible subsets $A$ of a given fixed set $D$. Show that the kernel function (6.27) corresponds to an inner product in a feature space of dimensionality $2^{|D|}$ defined by the mapping $\phi(A)$ where $A$ is a subset of $D$ and the element $\phi_U(A)$, indexed by the subset $U$, is given by

$$
\phi_U(A) = \begin{cases} 1, & \text{if } U \subseteq A; \\ 0, & \text{otherwise.} \end{cases} \tag{6.95}
$$

Here $U \subseteq A$ denotes that $U$ is either a subset of $A$ or is equal to $A$.

## 6.13 Fisher Kernel Nonlinear Invariance

Show that the Fisher kernel, defined by (6.33), remains invariant if we make a nonlinear transformation of the parameter vector $\boldsymbol{\theta} \to \boldsymbol{\psi}(\boldsymbol{\theta})$, where the function $\boldsymbol{\psi}(\cdot)$ is invertible and differentiable.

## 6.14 Gaussian Distribution Fisher Kernel

Write down the form of the Fisher kernel, defined by (6.33), for the case of a distribution $p(\mathbf{x}|\boldsymbol{\mu}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\mathbf{S})$ that is Gaussian with mean $\boldsymbol{\mu}$ and fixed covariance $\mathbf{S}$.

## 6.15 Kernel Cauchy-Schwartz Inequality

By considering the determinant of a $2 \times 2$ Gram matrix, show that a positivedefinite kernel function $k(\mathbf{x},\mathbf{x}')$ satisfies the Cauchy-Schwartz inequality

$$
k(\mathbf{x}_1,\mathbf{x}_2)^2 \leqslant k(\mathbf{x}_1,\mathbf{x}_1)k(\mathbf{x}_2,\mathbf{x}_2). \tag{6.96}
$$

## 6.16 Error Function Linear Combination

Consider a parametric model governed by the parameter vector $\mathbf{w}$ together with a data set of input values $\mathbf{x}_1,\dots,\mathbf{x}_N$ and a nonlinear feature mapping $\boldsymbol{\phi}(\mathbf{x})$. Suppose that the dependence of the error function on $\mathbf{w}$ takes the form

$$
J(\mathbf{w}) = f(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_1),\dots,\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_N)) + g(\mathbf{w}^T\mathbf{w}) \tag{6.97}
$$

where $g(\cdot)$ is a monotonically increasing function. By writing $\mathbf{w}$ in the form

$$
\mathbf{w} = \sum_{n=1}^N \alpha_n \boldsymbol{\phi}(\mathbf{x}_n) + \mathbf{w}_{\perp} \tag{6.98}
$$

show that the value of $\mathbf{w}$ that minimizes $J(\mathbf{w})$ takes the form of a linear combination of the basis functions $\boldsymbol{\phi}(\mathbf{x}_n)$ for $n = 1,\dots,N$.

## 6.17 Noisy Input Calculus Variations

Consider the sum-of-squares error function (6.39) for data having noisy inputs, where $\nu(\boldsymbol{\xi})$ is the distribution of the noise. Use the calculus of variations to minimize this error function with respect to the function $y(\mathbf{x})$, and hence show that the optimal solution is given by an expansion of the form (6.40) in which the basis functions are given by (6.41).
[Page 342]

## 6.18 Nadaraya-Watson Conditional Moments

Consider a Nadaraya-Watson model with one input variable $x$ and one target variable $t$ having Gaussian components with isotropic covariances, so that the covariance matrix is given by $\sigma^2\mathbf{I}$ where $\mathbf{I}$ is the unit matrix. Write down expressions for the conditional density $p(t|x)$ and for the conditional mean $\mathbb{E}[t|x]$ and variance $\operatorname{var}[t|x]$, in terms of the kernel function $k(x,x_n)$.

## 6.19 Kernel Regression Noisy Targets

Another viewpoint on kernel regression comes from a consideration of regression problems in which the input variables as well as the target variables are corrupted with additive noise. Suppose each target value $t_n$ is generated as usual by taking a function $y(\mathbf{z}_n)$ evaluated at a point $\mathbf{z}_n$, and adding Gaussian noise. The value of $\mathbf{z}_n$ is not directly observed, however, but only a noise corrupted version $\mathbf{x}_n = \mathbf{z}_n + \boldsymbol{\xi}_n$ where the random variable $\boldsymbol{\xi}$ is governed by some distribution $g(\boldsymbol{\xi})$. Consider a set of observations $\{\mathbf{x}_n,t_n\}$, where $n = 1,\dots,N$, together with a corresponding sum-of-squares error function defined by averaging over the distribution of input noise to give

$$
E = \frac{1}{2} \sum_{n=1}^N \int \{y(\mathbf{x}_n - \boldsymbol{\xi}_n) - t_n\}^2 g(\boldsymbol{\xi}_n) d\boldsymbol{\xi}_n. \tag{6.99}
$$

By minimizing $E$ with respect to the function $y(\mathbf{z})$ using the calculus of variations (Appendix D), show that optimal solution for $y(\mathbf{x})$ is given by a Nadaraya-Watson kernel regression solution of the form (6.45) with a kernel of the form (6.46).

## 6.20 Gaussian Process Regression Verification

Verify the results (6.66) and (6.67).

## 6.21 Gaussian Process Fixed Basis

Consider a Gaussian process regression model in which the kernel function is defined in terms of a fixed set of nonlinear basis functions. Show that the predictive distribution is identical to the result (3.58) obtained in Section 3.3.2 for the Bayesian linear regression model. To do this, note that both models have Gaussian predictive distributions, and so it is only necessary to show that the conditional mean and variance are the same. For the mean, make use of the matrix identity (C.6), and for the variance, make use of the matrix identity (C.7).

## 6.22 Gaussian Process Joint Predictive

Consider a regression problem with $N$ training set input vectors $\mathbf{x}_1,\dots,\mathbf{x}_N$ and $L$ test set input vectors $\mathbf{x}_{N+1},\dots,\mathbf{x}_{N+L}$, and suppose we define a Gaussian process prior over functions $t(\mathbf{x})$. Derive an expression for the joint predictive distribution for $t(\mathbf{x}_{N+1}),\dots,t(\mathbf{x}_{N+L})$, given the values of $t(\mathbf{x}_1),\dots,t(\mathbf{x}_N)$. Show the marginal of this distribution for one of the test observations $t_j$ where $N + 1 \leqslant j \leqslant N + L$ is given by the usual Gaussian process regression result (6.66) and (6.67).

## 6.23 Multidimensional Target Gaussian Process

Consider a Gaussian process regression model in which the target variable $\mathbf{t}$ has dimensionality $D$. Write down the conditional distribution of $\mathbf{t}_{N+1}$ for a test input vector $\mathbf{x}_{N+1}$, given a training set of input vectors $\mathbf{x}_1,\dots,\mathbf{x}_{N+1}$ and corresponding target observations $\mathbf{t}_1,\dots,\mathbf{t}_N$.

## 6.24 Positive Definite Matrix Sum

Show that a diagonal matrix $\mathbf{W}$ whose elements satisfy $0 < W_{ii} < 1$ is positive definite. Show that the sum of two positive definite matrices is itself positive definite.
[Page 343]

## 6.25 Gaussian Process Newton-Raphson Update

Using the Newton-Raphson formula (4.92), derive the iterative update formula (6.83) for finding the mode $\mathbf{a}_N^\star$ of the posterior distribution in the Gaussian process classification model.

## 6.26 Gaussian Process Posterior Moments

Using the result (2.115), derive the expressions (6.87) and (6.88) for the mean and variance of the posterior distribution $p(a_{N+1}|\mathbf{t}_N)$ in the Gaussian process classification model.

## 6.27 Laplace Approximation Log Likelihood

Derive the result (6.90) for the log likelihood function in the Laplace approximation framework for Gaussian process classification. Similarly, derive the results (6.91), (6.92), and (6.94) for the terms in the gradient of the log likelihood.
[Page 344]
