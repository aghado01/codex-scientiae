[Page 259]

![The image depicts a circular diagram with a central point labeled as W. This point is positioned at the center of the circle. The diagram is labeled with the following labels: - W: The point where the line segment W intersects the circle. - (\alpha_1): The angle between the line segment W and the radius of the circle. - (\alpha_2): The angle between the line segment W and the radius of the circle. - (\alpha_3): The angle between the line segment W and the radius of the circle. - (\alpha_4): The angle between the line segment W and the radius of the circle. - (\alpha_5): The angle between the line segment W and the radius of the circle. - (\alpha_6): The angle between the line segment W and the radius of the circle. - (\alpha_7): The angle between](../images/imageFile112.png)

Figure 5.6 In the neighbourhood of a minimum $\mathbf{w}^{\star}$, the error function can be approximated by a quadratic. Contours of constant error are then ellipses whose axes are aligned with the eigenvectors $\mathbf{u}_i$ of the Hessian matrix, with lengths that are inversely proportional to the square roots of the corresponding eigenvalues $\lambda_i$.

Because the eigenvectors $\{\mathbf{u}_i\}$ form a complete set, an arbitrary vector $\mathbf{v}$ can be written in the form
$$
\mathbf{v} = \sum_{i} c_i \mathbf{u}_i. \tag{5.38}
$$

From (5.33) and (5.34), we then have
$$
\mathbf{v}^{\mathrm{T}} \mathbf{H} \mathbf{v} = \sum_{i} c_i^2 \lambda_i \tag{5.39}
$$

and so $\mathbf{H}$ will be positive definite if, and only if, all of its eigenvalues are positive. In the new coordinate system, whose basis vectors are given by the eigenvectors $\{\mathbf{u}_i\}$, the contours of constant $E$ are ellipses centred on the origin, as illustrated in Figure 5.6. For a one-dimensional weight space, a stationary point $w^{\star}$ will be a minimum if
$$
\left. \frac{\partial^2 E}{\partial w^2} \right|_{w^{\star}} > 0. \tag{5.40}
$$

The corresponding result in $D$-dimensions is that the Hessian matrix, evaluated at $\mathbf{w}^{\star}$, should be positive definite.

### 5.2.3 Use of gradient information

As we shall see in Section 5.3, it is possible to evaluate the gradient of an error function efficiently by means of the backpropagation procedure. The use of this gradient information can lead to significant improvements in the speed with which the minima of the error function can be located. We can see why this is so, as follows.

In the quadratic approximation to the error function, given in (5.28), the error surface is specified by the quantities $\mathbf{b}$ and $\mathbf{H}$, which contain a total of $W(W + 3)/2$ independent elements (because the matrix $\mathbf{H}$ is symmetric), where $W$ is the dimensionality of $\mathbf{w}$ (i.e., the total number of adaptive parameters in the network). The location of the minimum of this quadratic approximation therefore depends on $\mathcal{O}(W^2)$ parameters, and we should not expect to be able to locate the minimum until we have gathered $\mathcal{O}(W^2)$ independent pieces of information. If we do not make use of gradient information, we would expect to have to perform $\mathcal{O}(W^2)$ function
