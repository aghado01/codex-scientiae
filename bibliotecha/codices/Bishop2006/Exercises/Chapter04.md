# Chapter 4 Exercises

[Page 240]


## 4.1 Linear Separability and Convex Hulls ($\star$)

Given a set of data points $\{\mathbf{x}_n\}$, we can define the convex hull to be the set of all points $\mathbf{x}$ given by

$$
\mathbf{x} = \sum_{n} \alpha_n \mathbf{x}_n \tag{4.156}
$$

where $\alpha_n \ge 0$ and $\sum_n \alpha_n = 1$. Consider a second set of points $\{\mathbf{y}_n\}$ together with their corresponding convex hull. By definition, the two sets of points will be linearly separable if there exists a vector $\mathbf{w}$ and a scalar $w_0$ such that $\mathbf{w}^{\mathrm{T}}\mathbf{x}_n + w_0 > 0$ for all $\mathbf{x}_n$, and $\mathbf{w}^{\mathrm{T}}\mathbf{y}_n + w_0 < 0$ for all $\mathbf{y}_n$. Show that if their convex hulls intersect, the two sets of points cannot be linearly separable, and conversely that if they are linearly separable, their convex hulls do not intersect.

## 4.2 Linear Constraints in Least Squares ($\star$)

Consider the minimization of a sum-of-squares error function (4.15), and suppose that all of the target vectors in the training set satisfy a linear constraint

$$
\mathbf{a}^{\mathrm{T}}\mathbf{t}_n + b = 0 \tag{4.157}
$$

where $\mathbf{t}_n$ corresponds to the $n^{\mathrm{th}}$ row of the matrix $\mathbf{T}$ in (4.15). Show that as a consequence of this constraint, the elements of the model prediction $\mathbf{y}(\mathbf{x})$ given by the least-squares solution (4.17) also satisfy this constraint, so that

$$
\mathbf{a}^{\mathrm{T}}\mathbf{y}(\mathbf{x}) + b = 0. \tag{4.158}
$$
[Page 241]

To do so, assume that one of the basis functions $\phi_0(\mathbf{x}) = 1$ so that the corresponding parameter $w_0$ plays the role of a bias.

## 4.3 Multiple Constraints in Least Squares

Extend the result of Exercise 4.2 to show that if multiple linear constraints are satisfied simultaneously by the target vectors, then the same constraints will also be satisfied by the least-squares prediction of a linear model.

## 4.4 Maximizing Class Separation Criterion

Show that maximization of the class separation criterion given by (4.23) with respect to $\mathbf{w}$, using a Lagrange multiplier to enforce the constraint $\mathbf{w}^{\mathrm{T}}\mathbf{w} = 1$, leads to the result that $\mathbf{w} \propto (\mathbf{m}_2 - \mathbf{m}_1)$.

## 4.5 Alternative Form of Fisher Criterion

By making use of (4.20), (4.23), and (4.24), show that the Fisher criterion (4.25) can be written in the form (4.26).

## 4.6 Least Squares and Covariance Matrices

Using the definitions of the between-class and within-class covariance matrices given by (4.27) and (4.28), respectively, together with (4.34) and (4.36) and the choice of target values described in Section 4.1.5, show that the expression (4.33) that minimizes the sum-of-squares error function can be written in the form (4.37).

## 4.7 Properties of Logistic Sigmoid Function

Show that the logistic sigmoid function (4.59) satisfies the property $\sigma(-a) = 1 - \sigma(a)$ and that its inverse is given by $\sigma^{-1}(y) = \ln\{y/(1 - y)\}$.

## 4.8 Two-Class Gaussian Generative Model

Using (4.57) and (4.58), derive the result (4.65) for the posterior class probability in the two-class generative model with Gaussian densities, and verify the results (4.66) and (4.67) for the parameters $\mathbf{w}$ and $w_0$.

## 4.9 Maximum Likelihood for Prior Probabilities

Consider a generative classification model for $K$ classes defined by prior class probabilities $p(\mathcal{C}_k) = \pi_k$ and general class-conditional densities $p(\boldsymbol{\phi}|\mathcal{C}_k)$ where $\boldsymbol{\phi}$ is the input feature vector. Suppose we are given a training data set $\{\boldsymbol{\phi}_n, \mathbf{t}_n\}$ where $n = 1,\ldots,N$, and $\mathbf{t}_n$ is a binary target vector of length $K$ that uses the 1-of-$K$ coding scheme, so that it has components $t_{nj} = I_{jk}$ if pattern $n$ is from class $\mathcal{C}_k$. Assuming that the data points are drawn independently from this model, show that the maximum-likelihood solution for the prior probabilities is given by
$$
\pi_k = \frac{N_k}{N} \tag{4.159}
$$
where $N_k$ is the number of data points assigned to class $\mathcal{C}_k$.

## 4.10 Maximum Likelihood for Shared Covariance

Consider the classification model of Exercise 4.9 and now suppose that the class-conditional densities are given by Gaussian distributions with a shared covariance matrix, so that
$$
p(\boldsymbol{\phi}|\mathcal{C}_k) = \mathcal{N}(\boldsymbol{\phi}|\boldsymbol{\mu}_k, \boldsymbol{\Sigma}). \tag{4.160}
$$
Show that the maximum likelihood solution for the mean of the Gaussian distribution for class $\mathcal{C}_k$ is given by
$$
\boldsymbol{\mu}_k = \frac{1}{N_k} \sum_{n=1}^N t_{nk} \boldsymbol{\phi}_n \tag{4.161}
$$
[Page 242]

which represents the mean of those feature vectors assigned to class $\mathcal{C}_k$. Similarly, show that the maximum likelihood solution for the shared covariance matrix is given by

$$
\mathbf{\Sigma} = \sum_{k=1}^K \frac{N_k}{N} \mathbf{S}_k \tag{4.162}
$$

where

$$
\mathbf{S}_k = \frac{1}{N_k} \sum_{n=1}^N t_{nk} (\boldsymbol{\phi}_n - \boldsymbol{\mu}_k)(\boldsymbol{\phi}_n - \boldsymbol{\mu}_k)^{\mathrm{T}}. \tag{4.163}
$$

Thus $\mathbf{\Sigma}$ is given by a weighted average of the covariances of the data associated with each class, in which the weighting coefficients are given by the prior probabilities of the classes.

## 4.11 Naive Bayes and Linear Functions ($\star$)

Consider a classification problem with $K$ classes for which the feature vector $\boldsymbol{\phi}$ has $M$ components each of which can take $L$ discrete states. Let the values of the components be represented by a 1-of-$L$ binary coding scheme. Further suppose that, conditioned on the class $\mathcal{C}_k$, the $M$ components of $\boldsymbol{\phi}$ are independent, so that the class-conditional density factorizes with respect to the feature vector components. Show that the quantities $a_k$ given by (4.63), which appear in the argument to the softmax function describing the posterior class probabilities, are linear functions of the components of $\boldsymbol{\phi}$. Note that this represents an example of the naive Bayes model which is discussed in Section 8.2.2.

## 4.12 Derivative of Logistic Sigmoid Function ($\star$)

Verify the relation (4.88) for the derivative of the logistic sigmoid function defined by (4.59).

## 4.13 Logistic Regression Error Function Derivative ($\star$)

By making use of the result (4.88) for the derivative of the logistic sigmoid, show that the derivative of the error function (4.90) for the logistic regression model is given by (4.91).

## 4.14 Logistic Regression on Separable Data ($\star$)

Show that for a linearly separable data set, the maximum likelihood solution for the logistic regression model is obtained by finding a vector $\mathbf{w}$ whose decision boundary $\mathbf{w}^{\mathrm{T}}\boldsymbol{\phi}(\mathbf{x}) = 0$ separates the classes and then taking the magnitude of $\mathbf{w}$ to infinity.

## 4.15 Hessian Matrix for Logistic Regression ($\star\star$)

Show that the Hessian matrix $\mathbf{H}$ for the logistic regression model, given by (4.97), is positive definite. Here $\mathbf{R}$ is a diagonal matrix with elements $y_n(1 - y_n)$, and $y_n$ is the output of the logistic regression model for input vector $\mathbf{x}_n$. Hence show that the error function is a concave function of $\mathbf{w}$ and that it has a unique minimum.

## 4.16 Log Likelihood with Mislabelled Data ($\star$)

Consider a binary classification problem in which each observation $\mathbf{x}_n$ is known to belong to one of two classes, corresponding to $t = 0$ and $t = 1$, and suppose that the procedure for collecting training data is imperfect, so that training points are sometimes mislabelled. For every data point $\mathbf{x}_n$, instead of having a value $t$ for the class label, we have instead a value $\pi_n$ representing the probability that $t_n = 1$. Given a probabilistic model $p(t = 1|\boldsymbol{\phi})$, write down the log likelihood function appropriate to such a data set.
[Page 243]

## 4.17 Derivatives of Softmax Activation Function

Show that the derivatives of the softmax activation function (4.104), where the $a_k$ are defined by (4.105), are given by (4.106).

## 4.18 Gradients of Cross-Entropy Error

Using the result (4.91) for the derivatives of the softmax activation function, show that the gradients of the cross-entropy error (4.108) are given by (4.109).

## 4.19 Probit Regression Gradient and Hessian

Write down expressions for the gradient of the log likelihood, as well as the corresponding Hessian matrix, for the probit regression model defined in Section 4.3.5. These are the quantities that would be required to train such a model using IRLS.

## 4.20 Multiclass Logistic Regression Hessian Matrix

Show that the Hessian matrix for the multiclass logistic regression problem, defined by (4.110), is positive semidefinite. Note that the full Hessian matrix for this problem is of size $MK \times MK$, where $M$ is the number of parameters and $K$ is the number of classes. To prove the positive semidefinite property, consider the product $\mathbf{u}^T \mathbf{H} \mathbf{u}$ where $\mathbf{u}$ is an arbitrary vector of length $MK$, and then apply Jensen’s inequality.

## 4.21 Relationship Between Probit and Erf

Show that the probit function (4.114) and the erf function (4.115) are related by (4.116).

## 4.22 Laplace Approximation Log Model Evidence

Using the result (4.135), derive the expression (4.137) for the log model evidence under the Laplace approximation.

## 4.23 Deriving BIC from Laplace Approximation

In this exercise, we derive the BIC result (4.139) starting from the Laplace approximation to the model evidence given by (4.137). Show that if the prior over parameters is Gaussian of the form $p(\theta) = \mathcal{N}(\theta|m,V_0)$, the log model evidence under the Laplace approximation takes the form

$$
\ln p(\mathcal{D}) \simeq \ln p(\mathcal{D}|\theta_{\text{MAP}}) - \frac{1}{2} (\theta_{\text{MAP}} - m)^T V_0^{-1} (\theta_{\text{MAP}} - m) - \frac{1}{2} \ln |H| + \text{const}
$$

where $H$ is the matrix of second derivatives of the log likelihood $\ln p(\mathcal{D}|\theta)$ evaluated at $\theta_{\text{MAP}}$. Now assume that the prior is broad so that $V_0^{-1}$ is small and the second term on the right-hand side above can be neglected. Furthermore, consider the case of independent, identically distributed data so that $H$ is the sum of terms one for each data point. Show that the log model evidence can then be written approximately in the form of the BIC expression (4.139).

## 4.24 Marginalization of Logistic Regression Model

Use the results from Section 2.3.2 to derive the result (4.151) for the marginalization of the logistic regression model with respect to a Gaussian posterior distribution over the parameters $\mathbf{w}$.

## 4.25 Approximating Sigmoid with Probit Function

Suppose we wish to approximate the logistic sigmoid $\sigma(a)$ defined by (4.59) by a scaled probit function $\Phi(\lambda a)$, where $\Phi(a)$ is defined by (4.114). Show that if $\lambda$ is chosen so that the derivatives of the two functions are equal at $a = 0$, then $\lambda^2 = \pi/8$.
[Page 244]

## 4.26 Convolution of Probit and Gaussian

In this exercise, we prove the relation (4.152) for the convolution of a probit function with a Gaussian distribution. To do this, show that the derivative of the lefthand side with respect to $\mu$ is equal to the derivative of the right-hand side, and then integrate both sides with respect to $\mu$ and then show that the constant of integration vanishes. Note that before differentiating the left-hand side, it is convenient first to introduce a change of variable given by $a = \mu + \sigma z$ so that the integral over $a$ is replaced by an integral over $z$. When we differentiate the left-hand side of the relation (4.152), we will then obtain a Gaussian integral over $z$ that can be evaluated analytically.
