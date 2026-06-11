[Page 300]

where the input-dependent variance is given by
$$
\sigma^{2}(\mathbf{x}) = \beta^{-1} + \mathbf{g}^{T}\mathbf{A}^{-1}\mathbf{g}. \tag{5.173}
$$

We see that the predictive distribution $p(t|\mathbf{x},\mathcal{D})$ is a Gaussian whose mean is given by the network function $y(\mathbf{x},\mathbf{w}_{\text{MAP}})$ with the parameter set to their MAP value. The variance has two terms, the ﬁrst of which arises from the intrinsic noise on the target variable, whereas the second is an $\mathbf{x}$-dependent term that expresses the uncertainty in the interpolant due to the uncertainty in the model parameters $\mathbf{w}$. This should be compared with the corresponding predictive distribution for the linear regression model, given by (3.58) and (3.59).

### 5.7.2 Hyperparameter optimization

So far, we have assumed that the hyperparameters $\alpha$ and $\beta$ are ﬁxed and known. We can make use of the evidence framework, discussed in Section 3.5, together with the Gaussian approximation to the posterior obtained using the Laplace approximation, to obtain a practical procedure for choosing the values of such hyperparameters.

The marginal likelihood, or evidence, for the hyperparameters is obtained by integrating over the network weights
$$
p(\mathcal{D}|\alpha,\beta) = \int p(\mathcal{D}|\mathbf{w},\beta)p(\mathbf{w}|\alpha) \, d\mathbf{w}. \tag{5.174}
$$

This is easily evaluated by making use of the Laplace approximation result (4.135). Taking logarithms then gives
$$
\ln p(\mathcal{D}|\alpha,\beta) \simeq -E(\mathbf{w}_{\text{MAP}}) - \frac{1}{2} \ln |\mathbf{A}| + \frac{W}{2} \ln \alpha + \frac{N}{2} \ln \beta - \frac{N}{2} \ln (2\pi) \tag{5.175}
$$

where $W$ is the total number of parameters in $\mathbf{w}$, and the regularized error function is deﬁned by
$$
E(\mathbf{w}_{\text{MAP}}) = \frac{\beta}{2} \sum_{n=1}^{N} \{ y(\mathbf{x}_{n}, \mathbf{w}_{\text{MAP}}) - t_{n} \}^{2} + \frac{\alpha}{2} \mathbf{w}_{\text{MAP}}^{T} \mathbf{w}_{\text{MAP}}. \tag{5.176}
$$

We see that this takes the same form as the corresponding result (3.86) for the linear regression model.

In the evidence framework, we make point estimates for $\alpha$ and $\beta$ by maximizing $\ln p(\mathcal{D}|\alpha,\beta)$. Consider ﬁrst the maximization with respect to $\alpha$, which can be done by analogy with the linear regression case discussed in Section 3.5.2. We ﬁrst deﬁne the eigenvalue equation
$$
\beta \mathbf{H} \mathbf{u}_{i} = \lambda_{i} \mathbf{u}_{i} \tag{5.177}
$$

where $\mathbf{H}$ is the Hessian matrix comprising the second derivatives of the sum-of-squares error function, evaluated at $\mathbf{w} = \mathbf{w}_{\text{MAP}}$. By analogy with (3.92), we obtain
$$
\alpha = \frac{\gamma}{\mathbf{w}_{\text{MAP}}^{T} \mathbf{w}_{\text{MAP}}} \tag{5.178}
$$
