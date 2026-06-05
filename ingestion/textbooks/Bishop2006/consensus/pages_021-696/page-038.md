[Page 38]

Figure 1.12 The concept of probability for discrete variables can be extended to that of a probability density $p(x)$ over a continuous variable $x$ and is such that the probability of $x$ lying in the interval $(x, x + \delta x)$ is given by $p(x)\delta x$ for $\delta x \to 0$. The probability density can be expressed as the derivative of a cumulative distribution function $P(x)$.

![image 15](../../../../../images/imageFile15.png)

Because probabilities are nonnegative, and because the value of $x$ must lie somewhere on the real axis, the probability density $p(x)$ must satisfy the two conditions

$$
p(x) \geq 0 \tag{1.25}
$$

$$
\int_{-\infty}^{\infty} p(x)\,dx = 1. \tag{1.26}
$$

Under a nonlinear change of variable, a probability density transforms differently from a simple function, due to the Jacobian factor. For instance, if we consider a change of variables $x = g(y)$, then a function $f(x)$ becomes $f(y) = f(g(y))$. Now consider a probability density $p_x(x)$ that corresponds to a density $p_y(y)$ with respect to the new variable $y$, where the sufﬁces denote the fact that $p_x(x)$ and $p_y(y)$ are different densities. Observations falling in the range $(x, x + \delta x)$ will, for small values of $\delta x$, be transformed into the range $(y, y + \delta y)$ where $p_x(x)\delta x = p_y(y)\delta y$, and hence

$$
p_y(y) = p_x(x)\left|\frac{dx}{dy}\right| = p_x(g(y))\left|g'(y)\right|. \tag{1.27}
$$

One consequence of this property is that the concept of the maximum of a probability density is dependent on the choice of variable. The probability that $x$ lies in the interval $(-\infty, z)$ is given by the cumulative distribution function deﬁned by

$$
P(z) = \int_{-\infty}^{z} p(x)\,dx. \tag{1.28}
$$

which satisﬁes $P'(x) = p(x)$, as shown in Figure 1.12.

If we have several continuous variables $x_1, \ldots, x_D$, denoted collectively by the vector $\mathbf{x}$, then we can deﬁne a joint probability density $p(\mathbf{x}) = p(x_1, \ldots, x_D)$ such
