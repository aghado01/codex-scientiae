[Page 307]

5.20 ( $\star$ ) Derive an expression for the outer product approximation to the Hessian matrix for a network having $K$ outputs with a softmax output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.

5.21 ( $\star\star$ ) Extend the expression (5.86) for the outer product approximation of the Hessian matrix to the case of $K > 1$ output units. Hence, derive a recursive expression analogous to (5.87) for incrementing the number $N$ of patterns and a similar expression for incrementing the number $K$ of outputs. Use these results, together with the identity (5.88), to ﬁnd sequential update expressions analogous to (5.89) for ﬁnding the inverse of the Hessian by incrementally including both extra patterns and extra outputs.

5.22 ( $\star\star$ ) Derive the results (5.93), (5.94), and (5.95) for the elements of the Hessian matrix of a two-layer feed-forward network by application of the chain rule of calculus.

5.23 ( $\star$ ) Extend the results of Section 5.4.5 for the exact Hessian of a two-layer network to include skip-layer connections that go directly from inputs to outputs.

5.24 ( $\star$ ) Verify that the network function deﬁned by (5.113) and (5.114) is invariant under the transformation (5.115) applied to the inputs, provided the weights and biases are simultaneously transformed using (5.116) and (5.117). Similarly, show that the network outputs can be transformed according (5.118) by applying the transformation (5.119) and (5.120) to the second-layer weights and biases.

5.25 ( $\star\star$ ) www Consider a quadratic error function of the form

$$
E = E_0 + \frac{1}{2} (\mathbf{w} - \mathbf{w}^{\star})^T \mathbf{H} (\mathbf{w} - \mathbf{w}^{\star}) \tag{5.195}
$$

where $\mathbf{w}^{\star}$ represents the minimum, and the Hessian matrix $\mathbf{H}$ is positive deﬁnite and constant. Suppose the initial weight vector $\mathbf{w}^{(0)}$ is chosen to be at the origin and is updated using simple gradient descent

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

Show that as $\tau \rightarrow \infty$, this gives $\mathbf{w}^{(\tau)} \rightarrow \mathbf{w}^{\star}$ as expected, provided $|1 - \rho \eta_j| < 1$. Now suppose that training is halted after a ﬁnite number $\tau$ of steps. Show that the
