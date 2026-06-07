[Page 541]

10.29 ($\star$) www Show that the function $f(x) = \ln(x)$ is concave for $0 < x < \infty$ by computing its second derivative. Determine the form of the dual function $g(\lambda)$ deﬁned by (10.133), and verify that minimization of $\lambda x - g(\lambda)$ with respect to $\lambda$ according to (10.132) indeed recovers the function $\ln(x)$.

10.30 ($\star$) By evaluating the second derivative, show that the log logistic function $f(x) = -\ln(1 + e^{-x})$ is concave. Derive the variational upper bound (10.137) directly by making a second order Taylor expansion of the log logistic function around a point $x = \xi$.

10.31 ($\star$) By ﬁnding the second derivative with respect to $x$, show that the function $f(x) = -\ln(e^{x/2} + e^{-x/2})$ is a concave function of $x$. Now consider the second derivatives with respect to the variable $x^2$ and hence show that it is a convex function of $x^2$. Plot graphs of $f(x)$ against $x$ and against $x^2$. Derive the lower bound (10.144) on the logistic sigmoid function directly by making a ﬁrst order Taylor series expansion of the function $f(x)$ in the variable $x^2$ centred on the value $\xi^2$.

10.32 ($\star$) www Consider the variational treatment of logistic regression with sequential learning in which data points are arriving one at a time and each must be processed and discarded before the next data point arrives. Show that a Gaussian approximation to the posterior distribution can be maintained through the use of the lower bound (10.151), in which the distribution is initialized using the prior, and as each data point is absorbed its corresponding variational parameter $\xi_n$ is optimized.

10.33 ($\star$) By differentiating the quantity $Q(\boldsymbol{\xi}, \boldsymbol{\xi}^{\text{old}})$ deﬁned by (10.161) with respect to the variational parameter $\xi_n$ show that the update equation for $\xi_n$ for the Bayesian logistic regression model is given by (10.163).

10.34 ($\star$) In this exercise we derive re-estimation equations for the variational parameters $\boldsymbol{\xi}$ in the Bayesian logistic regression model of Section 4.5 by direct maximization of the lower bound given by (10.164). To do this set the derivative of $\mathcal{L}(\boldsymbol{\xi})$ with respect to $\xi_n$ equal to zero, making use of the result (3.117) for the derivative of the log of a determinant, together with the expressions (10.157) and (10.158) which deﬁne the mean and covariance of the variational posterior distribution $q(\mathbf{w})$.

10.35 ($\star$) Derive the result (10.164) for the lower bound $\mathcal{L}(\boldsymbol{\xi})$ in the variational logistic regression model. This is most easily done by substituting the expressions for the Gaussian prior $q(\mathbf{w}) = \mathcal{N}(\mathbf{w}|\mathbf{m}_0, \mathbf{S}_0)$, together with the lower bound $h(\mathbf{w}, \boldsymbol{\xi})$ on the likelihood function, into the integral (10.159) which deﬁnes $\mathcal{L}(\boldsymbol{\xi})$. Next gather together the terms which depend on $\mathbf{w}$ in the exponential and complete the square to give a Gaussian integral, which can then be evaluated by invoking the standard result for the normalization coefﬁcient of a multivariate Gaussian. Finally take the logarithm to obtain (10.164).

10.36 ($\star$) Consider the ADF approximation scheme discussed in Section 10.7, and show that inclusion of the factor $f_j(\boldsymbol{\theta})$ leads to an update of the model evidence of the form

$$
p_j(\mathcal{D}) \simeq p_{j-1}(\mathcal{D})Z_j \tag{10.242}
$$
