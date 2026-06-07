[Page 516]

Figure 10.12 The left-hand plot shows the logistic sigmoid function $\sigma(x)$ deﬁned by (10.134) in red, together with two examples of the exponential upper bound (10.137) shown in blue. The right-hand plot shows the logistic sigmoid again in red together with the Gaussian lower bound (10.144) shown in blue. Here the parameter $\xi = 2.5$, and the bound is exact at $x = \xi$ and $x = -\xi$, denoted by the dashed green lines.

![image 245](../images/imageFile245.png)

and taking the exponential, we obtain an upper bound on the logistic sigmoid itself of the form

$$
\sigma(x) \leqslant \exp( \lambda x - g(\lambda) ) \tag{10.137}
$$

which is plotted for two values of $\lambda$ on the left-hand plot in Figure 10.12.

We can also obtain a lower bound on the sigmoid having the functional form of a Gaussian. To do this, we follow Jaakkola and Jordan (2000) and make transformations both of the input variable and of the function itself. First we take the log of the logistic function and then decompose it so that

$$
\begin{aligned}
\ln \sigma(x) &= -\ln(1 + e^{-x}) = -\ln \{ e^{-x/2}(e^{x/2} + e^{-x/2}) \} \\
&= x/2 - \ln(e^{x/2} + e^{-x/2}).
\end{aligned} \tag{10.138}
$$

We now note that the function $f(x) = -\ln(e^{x/2} + e^{-x/2})$ is a convex function of the variable $x^2$, as can again be veriﬁed by ﬁnding the second derivative. This leads to a lower bound on $f(x)$, which is a linear function of $x^2$ whose conjugate function is given by

$$
g(\lambda) = \max_{x^2} \{ \lambda x^2 - f( \sqrt{x^2} ) \}. \tag{10.139}
$$

The stationarity condition leads to

$$
0 = \lambda - \frac{d}{d(x^2)} f(x) = \lambda - \frac{dx}{d(x^2)} \frac{d}{dx} f(x) = \lambda + \frac{1}{4x} \tanh\left( \frac{x}{2} \right). \tag{10.140}
$$

If we denote this value of $x$, corresponding to the contact point of the tangent line for this particular value of $\lambda$, by $\xi$, then we have

$$
\lambda(\xi) = -\frac{1}{4\xi} \tanh\left( \frac{\xi}{2} \right) = -\frac{1}{2\xi} \left[ \sigma(\xi) - \frac{1}{2} \right]. \tag{10.141}
$$
