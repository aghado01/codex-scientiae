[Page 258]

where cubic and higher terms have been omitted. Here $\mathbf{b}$ is defined to be the gradient of $E$ evaluated at $\widehat{\mathbf{w}}$
$$
\mathbf{b} \equiv \nabla E \big|_{\mathbf{w}=\widehat{\mathbf{w}}} \tag{5.29}
$$
and the Hessian matrix $\mathbf{H} = \nabla\nabla E$ has elements
$$
(\mathbf{H})_{ij} \equiv \frac{\partial E}{\partial w_i \partial w_j} \bigg|_{\mathbf{w}=\widehat{\mathbf{w}}}. \tag{5.30}
$$

From (5.28), the corresponding local approximation to the gradient is given by
$$
\nabla E \simeq \mathbf{b} + \mathbf{H}(\mathbf{w} - \widehat{\mathbf{w}}). \tag{5.31}
$$

For points $\mathbf{w}$ that are sufficiently close to $\widehat{\mathbf{w}}$, these expressions will give reasonable approximations for the error and its gradient.

Consider the particular case of a local quadratic approximation around a point $\mathbf{w}^{\star}$ that is a minimum of the error function. In this case there is no linear term, because $\nabla E = 0$ at $\mathbf{w}^{\star}$, and (5.28) becomes
$$
E(\mathbf{w}) = E(\mathbf{w}^{\star}) + \frac{1}{2} (\mathbf{w} - \mathbf{w}^{\star})^T \mathbf{H} (\mathbf{w} - \mathbf{w}^{\star}) \tag{5.32}
$$

where the Hessian $\mathbf{H}$ is evaluated at $\mathbf{w}^{\star}$. In order to interpret this geometrically, consider the eigenvalue equation for the Hessian matrix
$$
\mathbf{H}\mathbf{u}_i = \lambda_i \mathbf{u}_i \tag{5.33}
$$
where the eigenvectors $\mathbf{u}_i$ form a complete orthonormal set (Appendix C) so that
$$
\mathbf{u}_i^T \mathbf{u}_j = \delta_{ij}. \tag{5.34}
$$
We now expand $(\mathbf{w} - \mathbf{w}^{\star})$ as a linear combination of the eigenvectors in the form
$$
\mathbf{w} - \mathbf{w}^{\star} = \sum_{i} \alpha_i \mathbf{u}_i. \tag{5.35}
$$

This can be regarded as a transformation of the coordinate system in which the origin is translated to the point $\mathbf{w}^{\star}$, and the axes are rotated to align with the eigenvectors (through the orthogonal matrix whose columns are the $\mathbf{u}_i$), and is discussed in more detail in Appendix C. Substituting (5.35) into (5.32), and using (5.33) and (5.34), allows the error function to be written in the form
$$
E(\mathbf{w}) = E(\mathbf{w}^{\star}) + \frac{1}{2} \sum_{i} \lambda_i \alpha_i^2. \tag{5.36}
$$

A matrix $\mathbf{H}$ is said to be positive definite if, and only if,
$$
\mathbf{v}^T \mathbf{H} \mathbf{v} > 0 \quad \text{for all } \mathbf{v}. \tag{5.37}
$$
