[Page 165]

![The image contains a diagram with three different shapes. The shapes are labeled as q=0.5, q=1, and q=2. The diagram is a triangle with vertices labeled q=0.5, q=1, and q=2. The triangle has two sides labeled q=0.5 and q=1, and two angles labeled q=0.5 and q=1. The triangle is also a right triangle, with the right angle at the vertex q=2.](../images/imageFile75.png)

Figure 3.3 Contours of the regularization term in (3.29) for various values of the parameter $q$.

zero. It has the advantage that the error function remains a quadratic function of $\mathbf{w}$, and so its exact minimizer can be found in closed form. Speciﬁcally, setting the gradient of (3.27) with respect to $\mathbf{w}$ to zero, and solving for $\mathbf{w}$ as before, we obtain
$$
\mathbf{w} = (\lambda\mathbf{I} + \mathbf{\Phi}^{\mathrm{T}}\mathbf{\Phi})^{-1}\mathbf{\Phi}^{\mathrm{T}}\mathbf{t}. \tag{3.28}
$$
This represents a simple extension of the least-squares solution (3.15).

A more general regularizer is sometimes used, for which the regularized error takes the form
$$
\frac{1}{2} \sum_{n=1}^{N} \{t_n - \mathbf{w}^{\mathrm{T}}\boldsymbol{\phi}(\mathbf{x}_n)\}^2 + \frac{\lambda}{2} \sum_{j=1}^{M} |w_j|^q \tag{3.29}
$$
where $q = 2$ corresponds to the quadratic regularizer (3.27). Figure 3.3 shows contours of the regularization function for different values of $q$.

The case of $q = 1$ is know as the lasso in the statistics literature (Tibshirani, 1996). It has the property that if $\lambda$ is sufﬁciently large, some of the coefﬁcients $w_j$ are driven to zero, leading to a sparse model in which the corresponding basis functions play no role. To see this, we ﬁrst note that minimizing (3.29) is equivalent to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint
$$
\sum_{j=1}^{M} |w_j|^q \le \eta \tag{3.30}
$$
for an appropriate value of the parameter $\eta$, where the two approaches can be related using Lagrange multipliers. The origin of the sparsity can be seen from Figure 3.4, which shows that the minimum of the error function, subject to the constraint (3.30). As $\lambda$ is increased, so an increasing number of parameters are driven to zero.

Regularization allows complex models to be trained on data sets of limited size without severe over-ﬁtting, essentially by limiting the effective model complexity. However, the problem of determining the optimal model complexity is then shifted from one of ﬁnding the appropriate number of basis functions to one of determining a suitable value of the regularization coefﬁcient $\lambda$. We shall return to the issue of model complexity later in this chapter.
