[Page 38]

Figure 1.12 The concept of probability for discrete variables can be extended to that of a probability density $p(x)$ over a continuous variable $x$ and is such that the probability of $x$ lying in the interval $(x, x+\delta x)$ is given by $p(x)\delta x$ for $\delta x \to 0$. The probability density can be expressed as the derivative of a cumulative distribution function $P(x)$.

![The image consists of a graph with two lines. The graph is titled P(x) and P(x). The x-axis is labeled as dz and the y-axis is labeled as η. The graph shows two lines, one blue line and another red line. The blue line is a straight line, while the red line is a curved line. The blue line starts at the point (0, 0) and extends upwards, while the red line starts at the point (0, 0) and extends downwards. The graph shows that the blue line is a straight line, while the red line is a curved line. The blue line has a higher value than the red line. This means that the blue line is more likely to be a straight line than the red line. The graph also shows that the blue line is not a straight line, but rather a curved line. This means that the blue line is not a straight line,](../images/imageFile15.png)

Because probabilities are nonnegative, and because the value of $x$ must lie somewhere on the real axis, the probability density $p(x)$ must satisfy the two conditions

$$
p(x) \ge 0 \tag{1.25}
$$

$$
\int_{-\infty}^{\infty} p(x) \, \mathrm{d}x = 1. \tag{1.26}
$$

Under a nonlinear change of variable, a probability density transforms differently from a simple function, due to the Jacobian factor. For instance, if we consider a change of variables $x = g(y)$, then a function $f(x)$ becomes $\tilde{f}(y) = f(g(y))$. Now consider a probability density $p_x(x)$ that corresponds to a density $p_y(y)$ with respect to the new variable $y$, where the suffices denote the fact that $p_x(x)$ and $p_y(y)$ are different densities. Observations falling in the range $(x, x + \delta x)$ will, for small values of $\delta x$, be transformed into the range $(y, y + \delta y)$ where $p_x(x)\delta x \simeq p_y(y)\delta y$, and hence

$$
\begin{align}
p_y(y) &= p_x(x) \left| \frac{\mathrm{d}x}{\mathrm{d}y} \right| \nonumber \\
&= p_x(g(y)) |g'(y)|. \tag{1.27}
\end{align}
$$

One consequence of this property is that the concept of the maximum of a probability density is dependent on the choice of variable.

The probability that $x$ lies in the interval $(-\infty, z)$ is given by the cumulative distribution function defined by

$$
P(z) = \int_{-\infty}^{z} p(x) \, \mathrm{d}x \tag{1.28}
$$

which satisfies $P'(x) = p(x)$, as shown in Figure 1.12.

If we have several continuous variables $x_1, \ldots, x_D$, denoted collectively by the vector $\mathbf{x}$, then we can define a joint probability density $p(\mathbf{x}) = p(x_1, \ldots, x_D)$ such
