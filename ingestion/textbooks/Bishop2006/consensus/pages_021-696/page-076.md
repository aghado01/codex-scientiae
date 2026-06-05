[Page 76]

Figure 1.31 A convex function $f(x)$ is one for which every chord (shown in blue) lies on or above the function (shown in red).

![image 37](../../../../../images/imageFile37.png)

and the corresponding value of the function is $f(\lambda a + (1 - \lambda)b)$. Convexity then implies

$$
f(\lambda a + (1 - \lambda)b) \le \lambda f(a) + (1 - \lambda)f(b). \tag{1.114}
$$

This is equivalent to the requirement that the second derivative of the function be everywhere positive. Examples of convex functions are $x \ln x$ (for $x > 0$) and $x^2$. A function is called strictly convex if the equality is satisﬁed only for $\lambda = 0$ and $\lambda = 1$. If a function has the opposite property, namely that every chord lies on or below the function, it is called concave, with a corresponding deﬁnition for strictly concave. If a function $f(x)$ is convex, then $-f(x)$ will be concave.

Using the technique of proof by induction, we can show from (1.114) that a convex function $f(x)$ satisﬁes

$$
f\left(\sum_{i=1}^{M} \lambda_i x_i\right) \le \sum_{i=1}^{M} \lambda_i f(x_i). \tag{1.115}
$$

where $\lambda_i \ge 0$ and $\sum_i \lambda_i = 1$, for any set of points $\{x_i\}$. The result (1.115) is known as Jensen’s inequality. If we interpret the $\lambda_i$ as the probability distribution over a discrete variable $x$ taking the values $\{x_i\}$, then (1.115) can be written

$$
f(\mathbb{E}[x]) \le \mathbb{E}[f(x)]. \tag{1.116}
$$

where $\mathbb{E}[\cdot]$ denotes the expectation. For continuous variables, Jensen’s inequality takes the form

$$
f\left(\int x p(x)\, dx\right) \le \int f(x)p(x)\, dx. \tag{1.117}
$$

We can apply Jensen’s inequality in the form (1.117) to the Kullback-Leibler divergence (1.113) to give

$$
\mathrm{KL}(p \parallel q) = -\int p(x)\ln \left\{\frac{q(x)}{p(x)}\right\}\, dx \ge -\ln \int q(x)\, dx = 0. \tag{1.118}
$$
