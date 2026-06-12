[Page 307]

5.20 ( ) Derive an expression for the outer product approximation to the Hessian matrix for a network having K outputs with a softmax output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-ofsquares error function.

5.21 ( ) Extend the expression (5.86) for the outer product approximation of the Hessian matrix to the case of K > 1 output units. Hence, derive a recursive expression analogous to (5.87) for incrementing the number N of patterns and a similar expression for incrementing the number K of outputs. Use these results, together with the identity (5.88), to ﬁnd sequential update expressions analogous to (5.89) for ﬁnding the inverse of the Hessian by incrementally including both extra patterns and extra outputs.

5.22 ( ) Derive the results (5.93), (5.94), and (5.95) for the elements of the Hessian matrix of a two-layer feed-forward network by application of the chain rule of calculus.

5.23 ( ) Extend the results of Section 5.4.5 for the exact Hessian of a two-layer network to include skip-layer connections that go directly from inputs to outputs.

5.24 ( ) Verify that the network function deﬁned by (5.113) and (5.114) is invariant under the transformation (5.115) applied to the inputs, provided the weights and biases are simultaneously transformed using (5.116) and (5.117). Similarly, show that the network outputs can be transformed according (5.118) by applying the transformation (5.119) and (5.120) to the second-layer weights and biases.

5.25 ( ) www Consider a quadratic error function of the form

$$
E = E _ { 0 } + \frac { 1 } { 2 } ( w - w ^ { * } ) ^ { T } H ( w - w ^ { * } )
$$

where w represents the minimum, and the Hessian matrix H is positive deﬁnite and constant. Suppose the initial weight vector w (0) is chosen to be at the origin and is updated using simple gradient descent

$$
w ^ { ( \tau ) } = w ^ { ( \tau - 1 ) } - \rho \nabla E
$$

where τ denotes the step number, and ρ is the learning rate (which is assumed to be small). Show that, after τ steps, the components of the weight vector parallel to the eigenvectors of H can be written

$$
w _ { j } ^ { ( \tau ) } = \{ 1 - ( 1 - \rho \eta _ { j } ) ^ { \tau } \} w _ { j } ^ { * }
$$

where w j = w T u j , and u j and η j are the eigenvectors and eigenvalues, respectively, of H so that

$$
H u _ { j } = \eta _ { j } u _ { j } .
$$

Show that as τ → ∞ , this gives w ( τ ) → w as expected, provided | 1 − ρη j | < 1 . Now suppose that training is halted after a ﬁnite number τ of steps. Show that the
