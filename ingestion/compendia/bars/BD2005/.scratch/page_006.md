[Page 6]

$$
y_{ij} = \sum_{l=1}^{k} b_{il}(x_{ij}'\mu_l)_+ + \varepsilon_{ij},
$$

where $\varepsilon_{ij} \overset{\text{iid}}{\sim} N(0, \tau^{-1})$. The value of the $j$th response of subject $i$ is approximated by a linear combination of the positive portion (denoted by the $+$ subscript) of the inner products of the basis functions with the covariate vector, $x_{ij}$. We require that each model contain an intercept basis, so we define $(x_{ij}'\mu_1)_+ \equiv 1$ for all $i, j$. We extend previous methods by allowing the spline coefficients, $b_i$, to be subject-specific, assuming that observations within subject $i$ are conditionally independent given $b_i$.

Each piecewise linear model is linear in the basis function transformations of the covariate vectors:

$$
y_i = \theta_i b_i + \varepsilon_i,
$$

where $y_i$ and $\varepsilon_i$ are the $n_i \times 1$ vectors of responses and random errors and $b_i$ is the $k \times 1$ vector of subject-specific basis coefficients for subject $i$. The $n_i \times k$ design matrix, $\theta_i$, contains the basis function transformations of the covariate vectors for subject $i$:

$$
\theta_i = \begin{pmatrix}
1 & (x_{i1}'\mu_2)_+ & \cdots & (x_{i1}'\mu_k)_+ \\
1 & (x_{i2}'\mu_2)_+ & \cdots & (x_{i2}'\mu_k)_+ \\
\vdots & \vdots & & \vdots \\
1 & (x_{in_i}'\mu_2)_+ & \cdots & (x_{in_i}'\mu_k)_+
\end{pmatrix}
$$

Since we use only the positive portion of each linear spline, it is possible that a basis function does not contribute to the model for a given subject (i.e. $\theta_i$ contains a column of zeros, which is non-informative about the corresponding element of $b_i$). To address this problem, we standardize each column of the population design matrix, $\Theta = (\theta_1', \ldots, \theta_m')'$, to have mean 0 and variance 1. Assuming independent subjects, this model specification yields the likelihood:

$$
L(y \mid b, \tau, M) \propto \prod_{i=1}^{m} \tau^{n_i/2} \exp\!\left[-\frac{\tau}{2}(y_i - \theta_i b_i)'(y_i - \theta_i b_i)\right]
$$
