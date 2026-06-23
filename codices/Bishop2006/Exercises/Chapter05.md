# Chapter 5 Exercises

[Page 304]


## 5.1 Equivalent Tanh Activation Network ($\star$)

Consider a two-layer network function of the form (5.7) in which the hiddenunit nonlinear activation functions $g(\cdot)$ are given by logistic sigmoid functions of the form

$$
\sigma(a) = \{1 + \exp(-a)\}^{-1}. \tag{5.191}
$$

Show that there exists an equivalent network, which computes exactly the same function, but with hidden unit activation functions given by $\tanh(a)$ where the $\tanh$ function is defined by (5.59). Hint: first find the relation between $\sigma(a)$ and $\tanh(a)$, and then show that the parameters of the two networks differ by linear transformations.

## 5.2 Multioutput Sum-of-Squares Equivalence ($\star$)

Show that maximizing the likelihood function under the conditional distribution (5.16) for a multioutput neural network is equivalent to minimizing the sum-of-squares error function (5.11).
[Page 305]

## 5.3 Gaussian Noise Target Covariance ($\star$)

Consider a regression problem involving multiple target variables in which it is assumed that the distribution of the targets, conditioned on the input vector $\mathbf{x}$, is a Gaussian of the form

$$
p(\mathbf{t}|\mathbf{x},\mathbf{w}) = \mathcal{N}(\mathbf{t}|\mathbf{y}(\mathbf{x},\mathbf{w}),\boldsymbol{\Sigma}) \tag{5.192}
$$

where $\mathbf{y}(\mathbf{x},\mathbf{w})$ is the output of a neural network with input vector $\mathbf{x}$ and weight vector $\mathbf{w}$, and $\boldsymbol{\Sigma}$ is the covariance of the assumed Gaussian noise on the targets. Given a set of independent observations of $\mathbf{x}$ and $\mathbf{t}$, write down the error function that must be minimized in order to find the maximum likelihood solution for $\mathbf{w}$, if we assume that $\boldsymbol{\Sigma}$ is fixed and known. Now assume that $\boldsymbol{\Sigma}$ is also to be determined from the data, and write down an expression for the maximum likelihood solution for $\boldsymbol{\Sigma}$. Note that the optimizations of $\mathbf{w}$ and $\boldsymbol{\Sigma}$ are now coupled, in contrast to the case of independent target variables discussed in Section 5.2.

## 5.4 Robust Binary Classification Error ($\star$)

Consider a binary classification problem in which the target values are $t \in \{0,1\}$, with a network output $y(\mathbf{x},\mathbf{w})$ that represents $p(t = 1|\mathbf{x})$, and suppose that there is a probability $\epsilon$ that the class label on a training data point has been incorrectly set. Assuming independent and identically distributed data, write down the error function corresponding to the negative log likelihood. Verify that the error function (5.21) is obtained when $\epsilon = 0$. Note that this error function makes the model robust to incorrectly labelled data, in contrast to the usual error function.

## 5.5 Multiclass Cross-Entropy Likelihood Equivalence ($\star$)

Show that maximizing likelihood for a multiclass neural network model in which the network outputs have the interpretation $y_k(\mathbf{x},\mathbf{w}) = p(t_k = 1|\mathbf{x})$ is equivalent to the minimization of the cross-entropy error function (5.24).

## 5.6 Logistic Sigmoid Error Derivative ($\star$)

Show the derivative of the error function (5.21) with respect to the activation $a_k$ for an output unit having a logistic sigmoid activation function satisfies (5.18).

## 5.7 Softmax Cross-Entropy Error Derivative ($\star$)

Show the derivative of the error function (5.24) with respect to the activation $a_k$ for output units having a softmax activation function satisfies (5.18).

## 5.8 Tanh Activation Function Derivative ($\star$)

We saw in (4.88) that the derivative of the logistic sigmoid activation function can be expressed in terms of the function value itself. Derive the corresponding result for the '$\tanh$' activation function defined by (5.59).

## 5.9 Bipolar Target Error Function ($\star$)

The error function (5.21) for binary classification problems was derived for a network having a logistic-sigmoid output activation function, so that $0 \le y(\mathbf{x},\mathbf{w}) \le 1$, and data having target values $t \in \{0,1\}$. Derive the corresponding error function if we consider a network having an output $-1 \le y(\mathbf{x},\mathbf{w}) \le 1$ and target values $t = 1$ for class $\mathcal{C}_1$ and $t = -1$ for class $\mathcal{C}_2$. What would be the appropriate choice of output unit activation function?

## 5.10 Positive Definite Hessian Eigenvalues ($\star$)

Consider a Hessian matrix $\mathbf{H}$ with eigenvector equation (5.33). By setting the vector $\mathbf{v}$ in (5.39) equal to each of the eigenvectors $\mathbf{u}_i$ in turn, show that $\mathbf{H}$ is positive definite if, and only if, all of its eigenvalues are positive.
[Page 306]

## 5.11 Quadratic Error Elliptical Contours ($\star$)

Consider a quadratic error function defined by (5.32), in which the Hessian matrix $\mathbf{H}$ has an eigenvalue equation given by (5.33). Show that the contours of constant error are ellipses whose axes are aligned with the eigenvectors $\mathbf{u}_i$, with lengths that are inversely proportional to the square root of the corresponding eigenvalues $\lambda_i$.

## 5.12 Positive Definite Hessian Minimum ($\star$)

By considering the local Taylor expansion (5.32) of an error function about a stationary point $\mathbf{w}^{\star}$, show that the necessary and sufficient condition for the stationary point to be a local minimum of the error function is that the Hessian matrix $\mathbf{H}$, defined by (5.30) with $\mathbf{w} = \mathbf{w}^{\star}$, be positive definite.

## 5.13 Independent Elements of Hessian ($\star$)

Show that as a consequence of the symmetry of the Hessian matrix $\mathbf{H}$, the number of independent elements in the quadratic error function (5.28) is given by $W(W + 3)/2$.

## 5.14 Taylor Expansion Term Cancellation ($\star$)

By making a Taylor expansion, verify that the terms that are $O(\epsilon)$ cancel on the right-hand side of (5.69).

## 5.15 Jacobian via Forward Propagation ($\star\star$)

In Section 5.3.4, we derived a procedure for evaluating the Jacobian matrix of a neural network using a backpropagation procedure. Derive an alternative formalism for finding the Jacobian based on forward propagation equations.

## 5.16 Multiple Output Hessian Approximation ($\star$)

The outer product approximation to the Hessian matrix for a neural network using a sum-of-squares error function is given by (5.84). Extend this result to the case of multiple outputs.

## 5.17 Second Derivative Squared Loss ($\star$)

Consider a squared loss function of the form

$$
E = \frac{1}{2} \iint \{y(\mathbf{x},\mathbf{w}) - t\}^2 p(\mathbf{x},t) \, d\mathbf{x} \, dt \tag{5.193}
$$

where $y(\mathbf{x},\mathbf{w})$ is a parametric function such as a neural network. The result (1.89) shows that the function $y(\mathbf{x},\mathbf{w})$ that minimizes this error is given by the conditional expectation of $t$ given $\mathbf{x}$. Use this result to show that the second derivative of $E$ with respect to two elements $w_r$ and $w_s$ of the vector $\mathbf{w}$, is given by

$$
\frac{\partial^2 E}{\partial w_r \partial w_s} = \int \frac{\partial y}{\partial w_r} \frac{\partial y}{\partial w_s} p(\mathbf{x}) \, d\mathbf{x}. \tag{5.194}
$$

Note that, for a finite sample from $p(\mathbf{x})$, we obtain (5.84).

## 5.18 Skip-Layer Connection Derivatives ($\star$)

Consider a two-layer network of the form shown in Figure 5.1 with the addition of extra parameters corresponding to skip-layer connections that go directly from the inputs to the outputs. By extending the discussion of Section 5.3.2, write down the equations for the derivatives of the error function with respect to these additional parameters.

## 5.19 Logistic Cross-Entropy Hessian Approximation ($\star$)

Derive the expression (5.85) for the outer product approximation to the Hessian matrix for a network having a single output with a logistic sigmoid output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.
[Page 307]

## 5.20 Softmax Cross-Entropy Hessian Approximation ($\star$)

Derive an expression for the outer product approximation to the Hessian matrix for a network having $K$ outputs with a softmax output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.

## 5.21 Sequential Hessian Inverse Update ($\star\star$)

Extend the expression (5.86) for the outer product approximation of the Hessian matrix to the case of $K > 1$ output units. Hence, derive a recursive expression analogous to (5.87) for incrementing the number $N$ of patterns and a similar expression for incrementing the number $K$ of outputs. Use these results, together with the identity (5.88), to find sequential update expressions analogous to (5.89) for finding the inverse of the Hessian by incrementally including both extra patterns and extra outputs.

## 5.22 Exact Two-Layer Network Hessian ($\star\star$)

Derive the results (5.93), (5.94), and (5.95) for the elements of the Hessian matrix of a two-layer feed-forward network by application of the chain rule of calculus.

## 5.23 Exact Hessian With Skip-Layers ($\star$)

Extend the results of Section 5.4.5 for the exact Hessian of a two-layer network to include skip-layer connections that go directly from inputs to outputs.

## 5.24 Network Transformation Invariance ($\star$)

Verify that the network function defined by (5.113) and (5.114) is invariant under the transformation (5.115) applied to the inputs, provided the weights and biases are simultaneously transformed using (5.116) and (5.117). Similarly, show that the network outputs can be transformed according (5.118) by applying the transformation (5.119) and (5.120) to the second-layer weights and biases.

## 5.25 Gradient Descent Weight Evolution ($\star\star$)

Consider a quadratic error function of the form

$$
E = E_0 + \frac{1}{2} (\mathbf{w} - \mathbf{w}^{\star})^T \mathbf{H} (\mathbf{w} - \mathbf{w}^{\star}) \tag{5.195}
$$

where $\mathbf{w}^{\star}$ represents the minimum, and the Hessian matrix $\mathbf{H}$ is positive definite and constant. Suppose the initial weight vector $\mathbf{w}^{(0)}$ is chosen to be at the origin and is updated using simple gradient descent

$$
\mathbf{w}^{(\tau)} = \mathbf{w}^{(\tau-1)} - \rho \nabla E \tag{5.196}
$$

where $\tau$ denotes the step number, and $\rho$ is the learning rate (which is assumed to be small). Show that, after $\tau$ steps, the components of the weight vector parallel to the eigenvectors of $\mathbf{H}$ can be written

$$
w_j^{(\tau)} = \{1 - (1 - \rho \eta_j)^{\tau}\} w_j^{\star} \tag{5.197}
$$

where $w_j \equiv \mathbf{w}^T\mathbf{u}_j$, and $\mathbf{u}_j$ and $\eta_j$ are the eigenvectors and eigenvalues, respectively, of $\mathbf{H}$ so that

$$
\mathbf{H}\mathbf{u}_j = \eta_j \mathbf{u}_j. \tag{5.198}
$$

Show that as $\tau \rightarrow \infty$, this gives $\mathbf{w}^{(\tau)} \rightarrow \mathbf{w}^{\star}$ as expected, provided $|1 - \rho \eta_j| < 1$. Now suppose that training is halted after a finite number $\tau$ of steps. Show that the
[Page 308]

components of the weight vector parallel to the eigenvectors of the Hessian satisfy

$$
w_j^{(\tau)} \simeq w_j^{\star} \quad \text{when } \eta_j \gg (\rho \tau)^{-1} \tag{5.199}
$$

$$
|w_j^{(\tau)}| \ll |w_j^{\star}| \quad \text{when } \eta_j \ll (\rho \tau)^{-1}. \tag{5.200}
$$

Compare this result with the discussion in Section 3.5.3 of regularization with simple weight decay, and hence show that $(\rho\tau)^{-1}$ is analogous to the regularization parameter $\lambda$. The above results also show that the effective number of parameters in the network, as defined by (3.91), grows as the training progresses.

## 5.26 Tangent Propagation Backpropagation Equations ($\star\star$)

Consider a multilayer perceptron with arbitrary feed-forward topology, which is to be trained by minimizing the tangent propagation error function (5.127) in which the regularizing function is given by (5.128). Show that the regularization term $\Omega$ can be written as a sum over patterns of terms of the form

$$
\Omega_n = \frac{1}{2} \sum_k (\mathcal{G} y_k)^2 \tag{5.201}
$$

where $\mathcal{G}$ is a differential operator defined by

$$
\mathcal{G} \equiv \sum_i \tau_i \frac{\partial}{\partial x_i}. \tag{5.202}
$$

By acting on the forward propagation equations

$$
z_j = h(a_j), \quad a_j = \sum_i w_{ji} z_i \tag{5.203}
$$

with the operator $\mathcal{G}$, show that $\Omega_n$ can be evaluated by forward propagation using the following equations:

$$
\alpha_j = h'(a_j) \beta_j, \quad \beta_j = \sum_i w_{ji} \alpha_i \tag{5.204}
$$

where we have defined the new variables

$$
\alpha_j \equiv \mathcal{G} z_j, \quad \beta_j \equiv \mathcal{G} a_j. \tag{5.205}
$$

Now show that the derivatives of $\Omega_n$ with respect to a weight $w_{rs}$ in the network can be written in the form

$$
\frac{\partial \Omega_n}{\partial w_{rs}} = \sum_k \alpha_k \{\phi_{kr} z_s + \delta_{kr} \alpha_s\} \tag{5.206}
$$

where we have defined

$$
\delta_{kr} \equiv \frac{\partial y_k}{\partial a_r}, \quad \phi_{kr} \equiv \mathcal{G} \delta_{kr}. \tag{5.207}
$$

Write down the backpropagation equations for $\delta_{kr}$, and hence derive a set of backpropagation equations for the evaluation of the $\phi_{kr}$.
[Page 309]

## 5.27 Random Noise Tikhonov Regularization ($\star$)

Consider the framework for training with transformed data in the special case in which the transformation consists simply of the addition of random noise $\mathbf{x} \rightarrow \mathbf{x} + \boldsymbol{\xi}$ where $\boldsymbol{\xi}$ has a Gaussian distribution with zero mean and unit covariance. By following an argument analogous to that of Section 5.5.5, show that the resulting regularizer reduces to the Tikhonov form (5.135).

## 5.28 Backpropagation with Shared Weights ($\star$)

Consider a neural network, such as the convolutional network discussed in Section 5.5.6, in which multiple weights are constrained to have the same value. Discuss how the standard backpropagation algorithm must be modified in order to ensure that such constraints are satisfied when evaluating the derivatives of an error function with respect to the adjustable parameters in the network.

## 5.29 Verify Mixture Equation Transformation ($\star$)

Verify the result (5.141).

## 5.30 Verify Second Mixture Transformation ($\star$)

Verify the result (5.142).

## 5.31 Verify Third Mixture Transformation ($\star$)

Verify the result (5.143).

## 5.32 Mixing Coefficient Derivatives ($\star\star$)

Show that the derivatives of the mixing coefficients $\{\pi_k\}$, defined by (5.146), with respect to the auxiliary parameters $\{\eta_j\}$ are given by

$$
\frac{\partial \pi_k}{\partial \eta_j} = \delta_{jk} \pi_j - \pi_j \pi_k. \tag{5.208}
$$

Hence, by making use of the constraint $\sum_k \pi_k = 1$, derive the result (5.147).

## 5.33 Robot Arm Forward Kinematics ($\star$)

Write down a pair of equations that express the Cartesian coordinates $(x_1,x_2)$ for the robot arm shown in Figure 5.18 in terms of the joint angles $\theta_1$ and $\theta_2$ and the lengths $L_1$ and $L_2$ of the links. Assume the origin of the coordinate system is given by the attachment point of the lower arm. These equations define the ‘forward kinematics’ of the robot arm.

## 5.34 MDN Mixing Coefficient Derivative ($\star\star$)

Derive the result (5.155) for the derivative of the error function with respect to the network output activations controlling the mixing coefficients in the mixture density network.

## 5.35 MDN Component Means Derivative ($\star\star$)

Derive the result (5.156) for the derivative of the error function with respect to the network output activations controlling the component means in the mixture density network.

## 5.36 MDN Component Variances Derivative ($\star\star$)

Derive the result (5.157) for the derivative of the error function with respect to the network output activations controlling the component variances in the mixture density network.

## 5.37 MDN Conditional Mean Variance ($\star$)

Verify the results (5.158) and (5.160) for the conditional mean and variance of the mixture density network model.

## 5.38 Bayesian Network Predictive Distribution ($\star$)

Using the general result (2.115), derive the predictive distribution (5.172) for the Laplace approximation to the Bayesian neural network model.
[Page 310]

## 5.39 Hyperparameter Evidence Laplace Approximation ($\star$)

Make use of the Laplace approximation result (4.135) to show that the evidence function for the hyperparameters $\alpha$ and $\beta$ in the Bayesian neural network model can be approximated by (5.175).

## 5.40 Multiclass Bayesian Neural Networks ($\star$)

Outline the modifications needed to the framework for Bayesian neural networks, discussed in Section 5.7.3, to handle multiclass problems using networks having softmax output-unit activation functions.

## 5.41 Marginal Likelihood Cross-Entropy Logistic ($\star$)

By following analogous steps to those given in Section 5.7.1 for regression networks, derive the result (5.183) for the marginal likelihood in the case of a network having a cross-entropy error function and logistic-sigmoid output-unit activation function.
