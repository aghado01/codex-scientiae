[Page 286]

in which the parameter $\xi$ is drawn from a distribution $p(\xi)$, then the error function defined over this expanded data set can be written as

$$
\widetilde{E} = \frac{1}{2} \iint \{y(s(\mathbf{x}, \xi)) - t\}^2 p(t|\mathbf{x}) p(\mathbf{x}) p(\xi) \, \mathrm{d}\mathbf{x} \, \mathrm{d}t \, \mathrm{d}\xi \tag{5.130}
$$

We now assume that the distribution $p(\xi)$ has zero mean with small variance, so that we are only considering small transformations of the original input vectors. We can then expand the transformation function as a Taylor series in powers of $\xi$ to give

$$
\begin{aligned}
s(\mathbf{x}, \xi) &= s(\mathbf{x}, 0) + \xi \left. \frac{\partial}{\partial \xi} s(\mathbf{x}, \xi) \right|_{\xi=0} + \frac{\xi^2}{2} \left. \frac{\partial^2}{\partial \xi^2} s(\mathbf{x}, \xi) \right|_{\xi=0} + O(\xi^3) \\
&= \mathbf{x} + \xi \boldsymbol{\tau} + \frac{1}{2} \xi^2 \boldsymbol{\tau}^\prime + O(\xi^3)
\end{aligned}
$$

where $\boldsymbol{\tau}^\prime$ denotes the second derivative of $s(\mathbf{x}, \xi)$ with respect to $\xi$ evaluated at $\xi = 0$. This allows us to expand the model function to give

$$
y(s(\mathbf{x}, \xi)) = y(\mathbf{x}) + \xi \boldsymbol{\tau}^T \nabla y(\mathbf{x}) + \frac{\xi^2}{2} \left[ (\boldsymbol{\tau}^\prime)^T \nabla y(\mathbf{x}) + \boldsymbol{\tau}^T \nabla \nabla y(\mathbf{x}) \boldsymbol{\tau} \right] + O(\xi^3).
$$

Substituting into the mean error function (5.130) and expanding, we then have

$$
\begin{aligned}
\widetilde{E} &= \frac{1}{2} \iint \{y(\mathbf{x}) - t\}^2 p(t|\mathbf{x}) p(\mathbf{x}) \, \mathrm{d}\mathbf{x} \, \mathrm{d}t \\
&\quad + \mathbb{E}[\xi] \iint \{y(\mathbf{x}) - t\} \boldsymbol{\tau}^T \nabla y(\mathbf{x}) p(t|\mathbf{x}) p(\mathbf{x}) \, \mathrm{d}\mathbf{x} \, \mathrm{d}t \\
&\quad + \frac{\mathbb{E}[\xi^2]}{2} \iint \left[ \{y(\mathbf{x}) - t\} \left\{ (\boldsymbol{\tau}^\prime)^T \nabla y(\mathbf{x}) + \boldsymbol{\tau}^T \nabla \nabla y(\mathbf{x}) \boldsymbol{\tau} \right\} + \left( \boldsymbol{\tau}^T \nabla y(\mathbf{x}) \right)^2 \right] p(t|\mathbf{x}) p(\mathbf{x}) \, \mathrm{d}\mathbf{x} \, \mathrm{d}t + O(\xi^3).
\end{aligned}
$$

Because the distribution of transformations has zero mean we have $\mathbb{E}[\xi] = 0$. Also, we shall denote $\mathbb{E}[\xi^2]$ by $\lambda$. Omitting terms of $O(\xi^3)$, the average error function then becomes

$$
\widetilde{E} = E + \lambda \Omega \tag{5.131}
$$

where $E$ is the original sum-of-squares error, and the regularization term $\Omega$ takes the form

$$
\Omega = \frac{1}{2} \int \left[ \{y(\mathbf{x}) - \mathbb{E}[t|\mathbf{x}]\} \left\{ (\boldsymbol{\tau}^\prime)^T \nabla y(\mathbf{x}) + \boldsymbol{\tau}^T \nabla \nabla y(\mathbf{x}) \boldsymbol{\tau} \right\} + (\boldsymbol{\tau}^T \nabla y(\mathbf{x}))^2 \right] p(\mathbf{x}) \, \mathrm{d}\mathbf{x} \tag{5.132}
$$

in which we have performed the integration over $t$.
