[Page 342]

6.18 ( ) Consider a Nadaraya-Watson model with one input variable $x$ and one target variable $t$ having Gaussian components with isotropic covariances, so that the covariance matrix is given by $\sigma^2\mathbf{I}$ where $\mathbf{I}$ is the unit matrix. Write down expressions for the conditional density $p(t|x)$ and for the conditional mean $\mathbb{E}[t|x]$ and variance $\operatorname{var}[t|x]$, in terms of the kernel function $k(x,x_n)$.

6.19 ( ) Another viewpoint on kernel regression comes from a consideration of regression problems in which the input variables as well as the target variables are corrupted with additive noise. Suppose each target value $t_n$ is generated as usual by taking a function $y(\mathbf{z}_n)$ evaluated at a point $\mathbf{z}_n$, and adding Gaussian noise. The value of $\mathbf{z}_n$ is not directly observed, however, but only a noise corrupted version $\mathbf{x}_n = \mathbf{z}_n + \boldsymbol{\xi}_n$ where the random variable $\boldsymbol{\xi}$ is governed by some distribution $g(\boldsymbol{\xi})$. Consider a set of observations $\{\mathbf{x}_n,t_n\}$, where $n = 1,\dots,N$, together with a corresponding sum-of-squares error function deﬁned by averaging over the distribution of input noise to give

$$
E = \frac{1}{2} \sum_{n=1}^N \int \{y(\mathbf{x}_n - \boldsymbol{\xi}_n) - t_n\}^2 g(\boldsymbol{\xi}_n) d\boldsymbol{\xi}_n. \tag{6.99}
$$

By minimizing $E$ with respect to the function $y(\mathbf{z})$ using the calculus of variations (Appendix D), show that optimal solution for $y(\mathbf{x})$ is given by a Nadaraya-Watson kernel regression solution of the form (6.45) with a kernel of the form (6.46).

6.20 ( ) www Verify the results (6.66) and (6.67).

6.21 ( ) www Consider a Gaussian process regression model in which the kernel function is deﬁned in terms of a ﬁxed set of nonlinear basis functions. Show that the predictive distribution is identical to the result (3.58) obtained in Section 3.3.2 for the Bayesian linear regression model. To do this, note that both models have Gaussian predictive distributions, and so it is only necessary to show that the conditional mean and variance are the same. For the mean, make use of the matrix identity (C.6), and for the variance, make use of the matrix identity (C.7).

6.22 ( ) Consider a regression problem with $N$ training set input vectors $\mathbf{x}_1,\dots,\mathbf{x}_N$ and $L$ test set input vectors $\mathbf{x}_{N+1},\dots,\mathbf{x}_{N+L}$, and suppose we deﬁne a Gaussian process prior over functions $t(\mathbf{x})$. Derive an expression for the joint predictive distribution for $t(\mathbf{x}_{N+1}),\dots,t(\mathbf{x}_{N+L})$, given the values of $t(\mathbf{x}_1),\dots,t(\mathbf{x}_N)$. Show the marginal of this distribution for one of the test observations $t_j$ where $N + 1 \leqslant j \leqslant N + L$ is given by the usual Gaussian process regression result (6.66) and (6.67).

6.23 ( ) www Consider a Gaussian process regression model in which the target variable $\mathbf{t}$ has dimensionality $D$. Write down the conditional distribution of $\mathbf{t}_{N+1}$ for a test input vector $\mathbf{x}_{N+1}$, given a training set of input vectors $\mathbf{x}_1,\dots,\mathbf{x}_{N+1}$ and corresponding target observations $\mathbf{t}_1,\dots,\mathbf{t}_N$.

6.24 ( ) Show that a diagonal matrix $\mathbf{W}$ whose elements satisfy $0 < W_{ii} < 1$ is positive deﬁnite. Show that the sum of two positive deﬁnite matrices is itself positive deﬁnite.
