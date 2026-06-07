[Page 514]

![image 243](../images/imageFile243.png)
![image 244](../images/imageFile244.png)

Figure 10.11 In the left-hand plot the red curve shows a convex function $f(x)$, and the blue line represents the linear function $\lambda x$, which is a lower bound on $f(x)$ because $f(x) \geqslant \lambda x$ for all $x$. For the given value of slope $\lambda$ the contact point of the tangent line having the same slope is found by minimizing with respect to $x$ the discrepancy (shown by the green dashed lines) given by $f(x) - \lambda x$. This deﬁnes the dual function $g(\lambda)$, which corresponds to the (negative of the) intercept of the tangent line having slope $\lambda$.

we therefore obtain the tangent line in the form

$$
y(x) = \exp(-\xi) - \exp(-\xi)(x - \xi) \tag{10.126}
$$

which is a linear function parameterized by $\xi$. For consistency with subsequent discussion, let us deﬁne $\lambda = -\exp(-\xi)$ so that

$$
y(x, \lambda) = \lambda x - \lambda + \lambda \ln(-\lambda). \tag{10.127}
$$

Different values of $\lambda$ correspond to different tangent lines, and because all such lines are lower bounds on the function, we have $f(x) \geqslant y(x, \lambda)$. Thus we can write the function in the form

$$
f(x) = \max_\lambda \{ \lambda x - \lambda + \lambda \ln(-\lambda) \}. \tag{10.128}
$$

We have succeeded in approximating the convex function $f(x)$ by a simpler, linear function $y(x, \lambda)$. The price we have paid is that we have introduced a variational parameter $\lambda$, and to obtain the tightest bound we must optimize with respect to $\lambda$.

We can formulate this approach more generally using the framework of convex duality (Rockafellar, 1972; Jordan et al., 1999). Consider the illustration of a convex function $f(x)$ shown in the left-hand plot in Figure 10.11. In this example, the function $\lambda x$ is a lower bound on $f(x)$ but it is not the best lower bound that can be achieved by a linear function having slope $\lambda$, because the tightest bound is given by the tangent line. Let us write the equation of the tangent line, having slope $\lambda$ as $\lambda x - g(\lambda)$ where the (negative) intercept $g(\lambda)$ clearly depends on the slope $\lambda$ of the tangent. To determine the intercept, we note that the line must be moved vertically by an amount equal to the smallest vertical distance between the line and the function, as shown in Figure 10.11. Thus

$$
\begin{aligned}
g(\lambda) &= -\min_x \{ f(x) - \lambda x \} \\
&= \max_x \{ \lambda x - f(x) \}.
\end{aligned} \tag{10.129}
$$
