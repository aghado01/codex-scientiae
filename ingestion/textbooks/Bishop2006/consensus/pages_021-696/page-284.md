[Page 284]

will be one-dimensional, and will be parameterized by $\xi$. Let the vector that results from acting on $\mathbf{x}_n$ by this transformation be denoted by $\mathbf{s}(\mathbf{x}_n,\xi)$, which is defined so that $\mathbf{s}(\mathbf{x},0) = \mathbf{x}$. Then the tangent to the curve $\mathcal{M}$ is given by the directional derivative $\boldsymbol{\tau} = \partial\mathbf{s}/\partial\xi$, and the tangent vector at the point $\mathbf{x}_n$ is given by
$$
\boldsymbol{\tau}_n = \frac{\partial \mathbf{s}(\mathbf{x}_n, \xi)}{\partial \xi} \Bigg|_{\xi=0}. \tag{5.125}
$$

Under a transformation of the input vector, the network output vector will, in general, change. The derivative of output $k$ with respect to $\xi$ is given by
$$
\frac{\partial y_k}{\partial \xi} \Bigg|_{\xi=0} = \sum_{i=1}^{D} \frac{\partial y_k}{\partial x_i} \frac{\partial x_i}{\partial \xi} \Bigg|_{\xi=0} = \sum_{i=1}^{D} J_{ki} \tau_i \tag{5.126}
$$
where $J_{ki}$ is the $(k,i)$ element of the Jacobian matrix $\mathbf{J}$, as discussed in Section 5.3.4. The result (5.126) can be used to modify the standard error function, so as to encourage local invariance in the neighbourhood of the data points, by the addition to the original error function $E$ of a regularization function $\Omega$ to give a total error function of the form
$$
\widetilde{E} = E + \lambda \Omega \tag{5.127}
$$
where $\lambda$ is a regularization coefficient and
$$
\Omega = \frac{1}{2} \sum_{n} \sum_{k} \left( \frac{\partial y_{nk}}{\partial \xi} \Bigg|_{\xi=0} \right)^2 = \frac{1}{2} \sum_{n} \sum_{k} \left( \sum_{i=1}^{D} J_{nki} \tau_{ni} \right)^2 . \tag{5.128}
$$

The regularization function will be zero when the network mapping function is invariant under the transformation in the neighbourhood of each pattern vector, and the value of the parameter $\lambda$ determines the balance between fitting the training data and learning the invariance property.

In a practical implementation, the tangent vector $\boldsymbol{\tau}_n$ can be approximated using finite differences, by subtracting the original vector $\mathbf{x}_n$ from the corresponding vector after transformation using a small value of $\xi$, and then dividing by $\xi$. This is illustrated in Figure 5.16.

The regularization function depends on the network weights through the Jacobian $\mathbf{J}$. A backpropagation formalism for computing the derivatives of the regularizer with respect to the network weights is easily obtained by extension of the techniques introduced in Section 5.3.

If the transformation is governed by $L$ parameters (e.g., $L = 3$ for the case of translations combined with in-plane rotations in a two-dimensional image), then the manifold $\mathcal{M}$ will have dimensionality $L$, and the corresponding regularizer is given by the sum of terms of the form (5.128), one for each transformation. If several transformations are considered at the same time, and the network mapping is made invariant to each separately, then it will be (locally) invariant to combinations of the transformations (Simard et al., 1992).
