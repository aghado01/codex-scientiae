[Page 306]

- 5.11 ( ) www Consider a quadratic error function deﬁned by (5.32), in which the Hessian matrix H has an eigenvalue equation given by (5.33). Show that the con-

tours of constant error are ellipses whose axes are aligned with the eigenvectors ui, with lengths that are inversely proportional to the square root of the corresponding

eigenvalues λi.

- 5.12 ( ) www By considering the local Taylor expansion (5.32) of an error function about a stationary point w , show that the necessary and sufﬁcient condition for the stationary point to be a local minimum of the error function is that the Hessian matrix H, deﬁned by (5.30) with w = w , be positive deﬁnite.

- 5.13 ( ) Show that as a consequence of the symmetry of the Hessian matrix H, the number of independent elements in the quadratic error function (5.28) is given by W(W + 3)/2.
- 5.14 ( ) By making a Taylor expansion, verify that the terms that are O( ) cancel on the right-hand side of (5.69).
- 5.15 ( ) In Section 5.3.4, we derived a procedure for evaluating the Jacobian matrix of a neural network using a backpropagation procedure. Derive an alternative formalism for ﬁnding the Jacobian based on forward propagation equations.
- 5.16 ( ) The outer product approximation to the Hessian matrix for a neural network using a sum-of-squares error function is given by (5.84). Extend this result to the case of multiple outputs.
- 5.17 ( ) Consider a squared loss function of the form

E =

1 2 {y(x,w) − t}2 p(x,t)dxdt (5.193)

where y(x,w) is a parametric function such as a neural network. The result (1.89) shows that the function y(x,w) that minimizes this error is given by the conditional expectation of t given x. Use this result to show that the second derivative of E with respect to two elements wr and ws of the vector w, is given by

∂2E ∂wr∂ws

=

∂y ∂wr

∂y ∂ws

p(x)dx. (5.194) Note that, for a ﬁnite sample from p(x), we obtain (5.84).

- 5.18 ( ) Consider a two-layer network of the form shown in Figure 5.1 with the addition of extra parameters corresponding to skip-layer connections that go directly from the inputs to the outputs. By extending the discussion of Section 5.3.2, write down the equations for the derivatives of the error function with respect to these additional parameters.
- 5.19 ( ) www Derive the expression (5.85) for the outer product approximation to the Hessian matrix for a network having a single output with a logistic sigmoid output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.
