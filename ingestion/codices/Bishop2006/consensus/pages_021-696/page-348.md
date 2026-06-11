[Page 348]

does not depend on $n$. Direct solution of this optimization problem would be very complex, and so we shall convert it into an equivalent problem that is much easier to solve. To do this we note that if we make the rescaling $\mathbf{w} \to \kappa\mathbf{w}$ and $b \to \kappa b$, then the distance from any point $\mathbf{x}_n$ to the decision surface, given by $t_n y(\mathbf{x}_n)/\|\mathbf{w}\|$, is unchanged. We can use this freedom to set

$$
t_n(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) + b) = 1 \tag{7.4}
$$

for the point that is closest to the surface. In this case, all data points will satisfy the constraints

$$
t_n(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) + b) \geqslant 1, \quad n = 1,\dots,N. \tag{7.5}
$$

This is known as the canonical representation of the decision hyperplane. In the case of data points for which the equality holds, the constraints are said to be active, whereas for the remainder they are said to be inactive. By deﬁnition, there will always be at least one active constraint, because there will always be a closest point, and once the margin has been maximized there will be at least two active constraints. The optimization problem then simply requires that we maximize $\|\mathbf{w}\|^{-1}$, which is equivalent to minimizing $\|\mathbf{w}\|^2$, and so we have to solve the optimization problem

$$
\arg \min_{\mathbf{w},b} \frac{1}{2} \|\mathbf{w}\|^2 \tag{7.6}
$$

subject to the constraints given by (7.5). The factor of $1/2$ in (7.6) is included for later convenience. This is an example of a quadratic programming problem in which we are trying to minimize a quadratic function subject to a set of linear inequality constraints. It appears that the bias parameter $b$ has disappeared from the optimization. However, it is determined implicitly via the constraints, because these require that changes to $\mathbf{w}$ be compensated by changes to $b$. We shall see how this works shortly.

In order to solve this constrained optimization problem, we introduce Lagrange multipliers $a_n \geqslant 0$, with one multiplier $a_n$ for each of the constraints in (7.5), giving the Lagrangian function

$$
L(\mathbf{w},b,\mathbf{a}) = \frac{1}{2} \|\mathbf{w}\|^2 - \sum_{n=1}^N a_n \{t_n(\mathbf{w}^T\boldsymbol{\phi}(\mathbf{x}_n) + b) - 1\} \tag{7.7}
$$

where $\mathbf{a} = (a_1,\dots,a_N)^T$. Note the minus sign in front of the Lagrange multiplier term, because we are minimizing with respect to $\mathbf{w}$ and $b$, and maximizing with respect to $\mathbf{a}$. Setting the derivatives of $L(\mathbf{w},b,\mathbf{a})$ with respect to $\mathbf{w}$ and $b$ equal to zero, we obtain the following two conditions

$$
\mathbf{w} = \sum_{n=1}^N a_n t_n \boldsymbol{\phi}(\mathbf{x}_n) \tag{7.8}
$$

$$
0 = \sum_{n=1}^N a_n t_n. \tag{7.9}
$$
