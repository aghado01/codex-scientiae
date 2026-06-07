[Page 361]

Figure 7.7 Illustration of SVM regression, showing the regression curve together with the insensitive ‘tube’. Also shown are examples of the slack variables $\xi$ and $\widehat{\xi}$. Points above the $\epsilon$-tube have $\xi > 0$ and $\widehat{\xi} = 0$, points below the $\epsilon$-tube have $\xi = 0$ and $\widehat{\xi} > 0$, and points inside the $\epsilon$-tube have $\xi = \widehat{\xi} = 0$.

![The image depicts a curved line that appears to be a graph or a diagram. The graph is a curved line with a slight curve, indicating that it is not a straight line but a curved one. The graph is marked with a series of points, each marked with a letter. The points are connected by a curved line, which is a type of curve that is commonly used in mathematics and physics to represent data points. The graph has a specific shape: - The x-axis is labeled with the letter y and is labeled as y(x). - The y-axis is labeled with the letter x and is labeled as x. - The graph has a curved line that starts at the point labeled y(x) and extends to the point labeled x. - The line starts at point y(x) and extends to point x with a slight curve. - The line then extends to point y](../images/imageFile152.png)

The error function for support vector regression can then be written as

$$
C \sum_{n=1}^N (\xi_n + \widehat{\xi}_n) + \frac{1}{2} \|\mathbf{w}\|^2 \tag{7.55}
$$

which must be minimized subject to the constraints $\xi_n \geqslant 0$ and $\widehat{\xi}_n \geqslant 0$ as well as (7.53) and (7.54). This can be achieved by introducing Lagrange multipliers $a_n \geqslant 0$, $\widehat{a}_n \geqslant 0$, $\mu_n \geqslant 0$, and $\widehat{\mu}_n \geqslant 0$ and optimizing the Lagrangian

$$
\begin{aligned} L &= C \sum_{n=1}^N (\xi_n + \widehat{\xi}_n) + \frac{1}{2} \|\mathbf{w}\|^2 - \sum_{n=1}^N (\mu_n\xi_n + \widehat{\mu}_n\widehat{\xi}_n) \\ &- \sum_{n=1}^N a_n(\epsilon + \xi_n + y_n - t_n) - \sum_{n=1}^N \widehat{a}_n(\epsilon + \widehat{\xi}_n - y_n + t_n). \end{aligned} \tag{7.56}
$$

We now substitute for $y(\mathbf{x})$ using (7.1) and then set the derivatives of the Lagrangian with respect to $\mathbf{w}$, $b$, $\xi_n$, and $\widehat{\xi}_n$ to zero, giving

$$
\frac{\partial L}{\partial \mathbf{w}} = 0 \quad \Rightarrow \quad \mathbf{w} = \sum_{n=1}^N (a_n - \widehat{a}_n)\phi(\mathbf{x}_n) \tag{7.57}
$$

$$
\frac{\partial L}{\partial b} = 0 \quad \Rightarrow \quad \sum_{n=1}^N (a_n - \widehat{a}_n) = 0 \tag{7.58}
$$

$$
\frac{\partial L}{\partial \xi_n} = 0 \quad \Rightarrow \quad a_n + \mu_n = C \tag{7.59}
$$

$$
\frac{\partial L}{\partial \widehat{\xi}_n} = 0 \quad \Rightarrow \quad \widehat{a}_n + \widehat{\mu}_n = C. \tag{7.60}
$$

Using these results to eliminate the corresponding variables from the Lagrangian, we see that the dual problem involves maximizing
