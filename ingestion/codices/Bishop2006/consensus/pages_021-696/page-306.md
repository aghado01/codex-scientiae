[Page 306]

5.11 ( $\star$ ) www Consider a quadratic error function deﬁned by (5.32), in which the Hessian matrix $\mathbf{H}$ has an eigenvalue equation given by (5.33). Show that the contours of constant error are ellipses whose axes are aligned with the eigenvectors $\mathbf{u}_i$, with lengths that are inversely proportional to the square root of the corresponding eigenvalues $\lambda_i$.

5.12 ( $\star$ ) www By considering the local Taylor expansion (5.32) of an error function about a stationary point $\mathbf{w}^{\star}$, show that the necessary and sufﬁcient condition for the stationary point to be a local minimum of the error function is that the Hessian matrix $\mathbf{H}$, deﬁned by (5.30) with $\mathbf{w} = \mathbf{w}^{\star}$, be positive deﬁnite.

5.13 ( $\star$ ) Show that as a consequence of the symmetry of the Hessian matrix $\mathbf{H}$, the number of independent elements in the quadratic error function (5.28) is given by $W(W + 3)/2$.

5.14 ( $\star$ ) By making a Taylor expansion, verify that the terms that are $O(\epsilon)$ cancel on the right-hand side of (5.69).

5.15 ( $\star\star$ ) In Section 5.3.4, we derived a procedure for evaluating the Jacobian matrix of a neural network using a backpropagation procedure. Derive an alternative formalism for ﬁnding the Jacobian based on forward propagation equations.

5.16 ( $\star$ ) The outer product approximation to the Hessian matrix for a neural network using a sum-of-squares error function is given by (5.84). Extend this result to the case of multiple outputs.

5.17 ( $\star$ ) Consider a squared loss function of the form

$$
E = \frac{1}{2} \iint \{y(\mathbf{x},\mathbf{w}) - t\}^2 p(\mathbf{x},t) \, d\mathbf{x} \, dt \tag{5.193}
$$

where $y(\mathbf{x},\mathbf{w})$ is a parametric function such as a neural network. The result (1.89) shows that the function $y(\mathbf{x},\mathbf{w})$ that minimizes this error is given by the conditional expectation of $t$ given $\mathbf{x}$. Use this result to show that the second derivative of $E$ with respect to two elements $w_r$ and $w_s$ of the vector $\mathbf{w}$, is given by

$$
\frac{\partial^2 E}{\partial w_r \partial w_s} = \int \frac{\partial y}{\partial w_r} \frac{\partial y}{\partial w_s} p(\mathbf{x}) \, d\mathbf{x}. \tag{5.194}
$$

Note that, for a ﬁnite sample from $p(\mathbf{x})$, we obtain (5.84).

5.18 ( $\star$ ) Consider a two-layer network of the form shown in Figure 5.1 with the addition of extra parameters corresponding to skip-layer connections that go directly from the inputs to the outputs. By extending the discussion of Section 5.3.2, write down the equations for the derivatives of the error function with respect to these additional parameters.

5.19 ( $\star$ ) www Derive the expression (5.85) for the outer product approximation to the Hessian matrix for a network having a single output with a logistic sigmoid output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.
