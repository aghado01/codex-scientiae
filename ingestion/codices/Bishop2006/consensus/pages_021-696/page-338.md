[Page 338]

where $\Psi(\mathbf{a}_N^\star) = \ln p(\mathbf{a}_N^\star|\boldsymbol{\theta}) + \ln p(\mathbf{t}_N|\mathbf{a}_N^\star)$. We also need to evaluate the gradient of $\ln p(\mathbf{t}_N|\boldsymbol{\theta})$ with respect to the parameter vector $\boldsymbol{\theta}$. Note that changes in $\boldsymbol{\theta}$ will cause changes in $\mathbf{a}_N^\star$, leading to additional terms in the gradient. Thus, when we differentiate (6.90) with respect to $\boldsymbol{\theta}$, we obtain two sets of terms, the ﬁrst arising from the dependence of the covariance matrix $\mathbf{C}_N$ on $\boldsymbol{\theta}$, and the rest arising from dependence of $\mathbf{a}_N^\star$ on $\boldsymbol{\theta}$.

The terms arising from the explicit dependence on $\boldsymbol{\theta}$ can be found by using (6.80) together with the results (C.21) and (C.22), and are given by

$$
\frac{\partial \ln p(\mathbf{t}_N|\boldsymbol{\theta})}{\partial \theta_j} = \frac{1}{2} {\mathbf{a}_N^\star}^T \mathbf{C}_N^{-1} \frac{\partial \mathbf{C}_N}{\partial \theta_j} \mathbf{C}_N^{-1} \mathbf{a}_N^\star - \frac{1}{2} \operatorname{Tr} \left[ (\mathbf{I} + \mathbf{C}_N\mathbf{W}_N)^{-1}\mathbf{W}_N \frac{\partial \mathbf{C}_N}{\partial \theta_j} \right]. \tag{6.91}
$$

To compute the terms arising from the dependence of $\mathbf{a}_N^\star$ on $\boldsymbol{\theta}$, we note that the Laplace approximation has been constructed such that $\Psi(\mathbf{a}_N)$ has zero gradient at $\mathbf{a}_N = \mathbf{a}_N^\star$, and so $\Psi(\mathbf{a}_N^\star)$ gives no contribution to the gradient as a result of its dependence on $\mathbf{a}_N^\star$. This leaves the following contribution to the derivative with respect to a component $\theta_j$ of $\boldsymbol{\theta}$

$$
-\frac{1}{2} \sum_{n=1}^N \frac{\partial \ln|\mathbf{W}_N + \mathbf{C}_N^{-1}|}{\partial a_n^\star} \frac{\partial a_n^\star}{\partial \theta_j} = -\frac{1}{2} \sum_{n=1}^N \left[ (\mathbf{I} + \mathbf{C}_N\mathbf{W}_N)^{-1}\mathbf{C}_N \right]_{nn} \sigma_n^\star(1 - \sigma_n^\star)(1 - 2\sigma_n^\star) \frac{\partial a_n^\star}{\partial \theta_j} \tag{6.92}
$$

where $\sigma_n^\star = \sigma(a_n^\star)$, and again we have used the result (C.22) together with the deﬁnition of $\mathbf{W}_N$. We can evaluate the derivative of $\mathbf{a}_N^\star$ with respect to $\theta_j$ by differentiating the relation (6.84) with respect to $\theta_j$ to give

$$
\frac{\partial \mathbf{a}_N^\star}{\partial \theta_j} = \frac{\partial \mathbf{C}_N}{\partial \theta_j} (\mathbf{t}_N - \boldsymbol{\sigma}_N) - \mathbf{C}_N\mathbf{W}_N \frac{\partial \mathbf{a}_N^\star}{\partial \theta_j}. \tag{6.93}
$$

Rearranging then gives

$$
\frac{\partial \mathbf{a}_N^\star}{\partial \theta_j} = (\mathbf{I} + \mathbf{W}_N\mathbf{C}_N)^{-1} \frac{\partial \mathbf{C}_N}{\partial \theta_j} (\mathbf{t}_N - \boldsymbol{\sigma}_N). \tag{6.94}
$$

Combining (6.91), (6.92), and (6.94), we can evaluate the gradient of the log likelihood function, which can be used with standard nonlinear optimization algorithms in order to determine a value for $\boldsymbol{\theta}$.

We can illustrate the application of the Laplace approximation for Gaussian processes using the synthetic two-class data set shown in Figure 6.12. Extension of the Laplace approximation to Gaussian processes involving $K > 2$ classes, using the softmax activation function, is straightforward (Williams and Barber, 1998).
