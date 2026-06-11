[Page 309]

5.27 ( $\star$ ) www Consider the framework for training with transformed data in the special case in which the transformation consists simply of the addition of random noise $\mathbf{x} \rightarrow \mathbf{x} + \boldsymbol{\xi}$ where $\boldsymbol{\xi}$ has a Gaussian distribution with zero mean and unit covariance. By following an argument analogous to that of Section 5.5.5, show that the resulting regularizer reduces to the Tikhonov form (5.135).

5.28 ( $\star$ ) www Consider a neural network, such as the convolutional network discussed in Section 5.5.6, in which multiple weights are constrained to have the same value. Discuss how the standard backpropagation algorithm must be modiﬁed in order to ensure that such constraints are satisﬁed when evaluating the derivatives of an error function with respect to the adjustable parameters in the network.

5.29 ( $\star$ ) www Verify the result (5.141).

5.30 ( $\star$ ) Verify the result (5.142).

5.31 ( $\star$ ) Verify the result (5.143).

5.32 ( $\star\star$ ) Show that the derivatives of the mixing coefﬁcients $\{\pi_k\}$, deﬁned by (5.146), with respect to the auxiliary parameters $\{\eta_j\}$ are given by

$$
\frac{\partial \pi_k}{\partial \eta_j} = \delta_{jk} \pi_j - \pi_j \pi_k. \tag{5.208}
$$

Hence, by making use of the constraint $\sum_k \pi_k = 1$, derive the result (5.147).

5.33 ( $\star$ ) Write down a pair of equations that express the Cartesian coordinates $(x_1,x_2)$ for the robot arm shown in Figure 5.18 in terms of the joint angles $\theta_1$ and $\theta_2$ and the lengths $L_1$ and $L_2$ of the links. Assume the origin of the coordinate system is given by the attachment point of the lower arm. These equations deﬁne the ‘forward kinematics’ of the robot arm.

5.34 ( $\star\star$ ) www Derive the result (5.155) for the derivative of the error function with respect to the network output activations controlling the mixing coefﬁcients in the mixture density network.

5.35 ( $\star\star$ ) Derive the result (5.156) for the derivative of the error function with respect to the network output activations controlling the component means in the mixture density network.

5.36 ( $\star\star$ ) Derive the result (5.157) for the derivative of the error function with respect to the network output activations controlling the component variances in the mixture density network.

5.37 ( $\star$ ) Verify the results (5.158) and (5.160) for the conditional mean and variance of the mixture density network model.

5.38 ( $\star$ ) Using the general result (2.115), derive the predictive distribution (5.172) for the Laplace approximation to the Bayesian neural network model.
