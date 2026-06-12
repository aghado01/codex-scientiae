[Page 360]

Figure 7.6 Plot of an $\epsilon$-insensitive error function (in red) in which the error increases linearly with distance beyond the insensitive region. Also shown for comparison is the quadratic error function (in green).

![The image consists of a graph with two lines. The graph is a line graph with two lines, one of which is a straight line. The line on the left side of the graph is a straight line with a positive slope. The line on the right side of the graph is a straight line with a negative slope. The line on the left side of the graph is a straight line with a positive slope. The line on the right side of the graph is a straight line with a negative slope. The graph is labeled as E(z) = 0 and the x-axis is labeled as z and the y-axis is labeled as z.](../images/imageFile151.png)

minimize a regularized error function given by

$$
\frac{1}{2} \sum_{n=1}^N \{y_n - t_n\}^2 + \frac{\lambda}{2} \|\mathbf{w}\|^2. \tag{7.50}
$$

To obtain sparse solutions, the quadratic error function is replaced by an $\epsilon$-insensitive error function (Vapnik, 1995), which gives zero error if the absolute difference between the prediction $y(\mathbf{x})$ and the target $t$ is less than $\epsilon$ where $\epsilon > 0$. A simple example of an $\epsilon$-insensitive error function, having a linear cost associated with errors outside the insensitive region, is given by

$$
E_{\epsilon}(y(\mathbf{x}) - t) = \begin{cases} 0, & \text{if } |y(\mathbf{x}) - t| < \epsilon; \\ |y(\mathbf{x}) - t| - \epsilon, & \text{otherwise} \end{cases} \tag{7.51}
$$

and is illustrated in Figure 7.6.

We therefore minimize a regularized error function given by

$$
C \sum_{n=1}^N E_{\epsilon}(y(\mathbf{x}_n) - t_n) + \frac{1}{2} \|\mathbf{w}\|^2 \tag{7.52}
$$

where $y(\mathbf{x})$ is given by (7.1). By convention the (inverse) regularization parameter, denoted $C$, appears in front of the error term.

As before, we can re-express the optimization problem by introducing slack variables. For each data point $\mathbf{x}_n$, we now need two slack variables $\xi_n \geqslant 0$ and $\widehat{\xi}_n \geqslant 0$, where $\xi_n > 0$ corresponds to a point for which $t_n > y(\mathbf{x}_n) + \epsilon$, and $\widehat{\xi}_n > 0$ corresponds to a point for which $t_n < y(\mathbf{x}_n) - \epsilon$, as illustrated in Figure 7.7.

The condition for a target point to lie inside the $\epsilon$-tube is that $y_n - \epsilon \leqslant t_n \leqslant y_n + \epsilon$, where $y_n = y(\mathbf{x}_n)$. Introducing the slack variables allows points to lie outside the tube provided the slack variables are nonzero, and the corresponding conditions are

$$
t_n \leqslant y(\mathbf{x}_n) + \epsilon + \xi_n \tag{7.53}
$$

$$
t_n \geqslant y(\mathbf{x}_n) - \epsilon - \widehat{\xi}_n. \tag{7.54}
$$
