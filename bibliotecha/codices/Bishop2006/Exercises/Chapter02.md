# Chapter 2 Exercises

[Page 147]


## 2.1 Properties of the Bernoulli Distribution ($\star$)

Verify that the Bernoulli distribution (2.2) satisfies the following properties

$$
\sum_{x=0}^{1} p(x|\mu) = 1 \tag{2.257}
$$

$$
\mathbb{E}[x] = \mu \tag{2.258}
$$

$$
\text{var}[x] = \mu(1 - \mu). \tag{2.259}
$$

Show that the entropy $H[x]$ of a Bernoulli distributed random binary variable $x$ is given by

$$
H[x] = -\mu \ln \mu - (1 - \mu) \ln (1 - \mu). \tag{2.260}
$$

## 2.2 Symmetric Bernoulli Distribution Properties ($\star$)

The form of the Bernoulli distribution given by (2.2) is not symmetric between the two values of $x$. In some situations, it will be more convenient to use an equivalent formulation for which $x \in \{-1, 1\}$, in which case the distribution can be written

$$
p(x|\mu) = \left( \frac{1 - \mu}{2} \right)^{(1 - x)/2} \left( \frac{1 + \mu}{2} \right)^{(1 + x)/2} \tag{2.261}
$$

where $\mu \in [-1, 1]$. Show that the distribution (2.261) is normalized, and evaluate its mean, variance, and entropy.

## 2.3 Normalization of Binomial Distribution ($\star$)

In this exercise, we prove that the binomial distribution (2.9) is normalized. First use the definition (2.10) of the number of combinations of $m$ identical objects chosen from a total of $N$ to show that

$$
\binom{N}{m} + \binom{N}{m - 1} = \binom{N + 1}{m} . \tag{2.262}
$$
[Page 148]

Use this result to prove by induction the following result
$$
(1 + x)^N = \sum_{m=0}^N \binom{N}{m} x^m \tag{2.263}
$$
which is known as the binomial theorem, and which is valid for all real values of $x$. Finally, show that the binomial distribution is normalized, so that
$$
\sum_{m=0}^N \binom{N}{m} \mu^m (1 - \mu)^{N-m} = 1 \tag{2.264}
$$
which can be done by first pulling out a factor $(1 - \mu)^N$ out of the summation and then making use of the binomial theorem.

## 2.4 Mean and Variance of Binomial ($\star$)

Show that the mean of the binomial distribution is given by (2.11). To do this, differentiate both sides of the normalization condition (2.264) with respect to $\mu$ and then rearrange to obtain an expression for the mean of $n$. Similarly, by differentiating (2.264) twice with respect to $\mu$ and making use of the result (2.11) for the mean of the binomial distribution prove the result (2.12) for the variance of the binomial.

## 2.5 Normalization of Beta Distribution ($\star$)

In this exercise, we prove that the beta distribution, given by (2.13), is correctly normalized, so that (2.14) holds. This is equivalent to showing that
$$
\int_0^1 \mu^{a-1} (1 - \mu)^{b-1} d\mu = \frac{\Gamma(a)\Gamma(b)}{\Gamma(a + b)}. \tag{2.265}
$$

From the definition (1.141) of the gamma function, we have
$$
\Gamma(a)\Gamma(b) = \int_0^\infty \exp(-x) x^{a-1} dx \int_0^\infty \exp(-y) y^{b-1} dy. \tag{2.266}
$$
Use this expression to prove (2.265) as follows. First bring the integral over $y$ inside the integrand of the integral over $x$, next make the change of variable $t = y + x$ where $x$ is fixed, then interchange the order of the $x$ and $t$ integrations, and finally make the change of variable $x = t\mu$ where $t$ is fixed.

## 2.6 Properties of Beta Distribution ($\star$)

Make use of the result (2.265) to show that the mean, variance, and mode of the beta distribution (2.13) are given respectively by
$$
\mathbb{E}[\mu] = \frac{a}{a + b} \tag{2.267}
$$
$$
\text{var}[\mu] = \frac{ab}{(a + b)^2(a + b + 1)} \tag{2.268}
$$
$$
\text{mode}[\mu] = \frac{a - 1}{a + b - 2}. \tag{2.269}
$$
[Page 149]

## 2.7 Posterior Mean of Binomial Variable ($\star$)

Consider a binomial random variable $x$ given by (2.9), with prior distribution for $\mu$ given by the beta distribution (2.13), and suppose we have observed $m$ occurrences of $x = 1$ and $l$ occurrences of $x = 0$. Show that the posterior mean value of $x$ lies between the prior mean and the maximum likelihood estimate for $\mu$. To do this, show that the posterior mean can be written as $\lambda$ times the prior mean plus $(1 - \lambda)$ times the maximum likelihood estimate, where $0 \le \lambda \le 1$. This illustrates the concept of the posterior distribution being a compromise between the prior distribution and the maximum likelihood solution.

## 2.8 Conditional Expectation and Variance Rules ($\star$)

Consider two variables $x$ and $y$ with joint distribution $p(x,y)$. Prove the following two results
$$
\begin{aligned}
\mathbb{E}[x] &= \mathbb{E}_y [\mathbb{E}_x[x|y]] \tag{2.270} \\
\text{var}[x] &= \mathbb{E}_y [\text{var}_x[x|y]] + \text{var}_y [\mathbb{E}_x[x|y]]. \tag{2.271}
\end{aligned}
$$

Here $\mathbb{E}_x[x|y]$ denotes the expectation of $x$ under the conditional distribution $p(x|y)$, with a similar notation for the conditional variance.

## 2.9 Normalization of Dirichlet Distribution ($\star$)

In this exercise, we prove the normalization of the Dirichlet distribution (2.38) using induction. We have already shown in Exercise 2.5 that the beta distribution, which is a special case of the Dirichlet for $M = 2$, is normalized. We now assume that the Dirichlet distribution is normalized for $M - 1$ variables and prove that it is normalized for $M$ variables. To do this, consider the Dirichlet distribution over $M$ variables, and take account of the constraint $\sum_{k=1}^{M} \mu_k = 1$ by eliminating $\mu_M$, so that the Dirichlet is written
$$
p_M(\mu_1,\ldots,\mu_{M-1}) = C_M \prod_{k=1}^{M-1} \mu_k^{\alpha_k-1} \left( 1 - \sum_{j=1}^{M-1} \mu_j \right)^{\alpha_M-1} \tag{2.272}
$$
and our goal is to find an expression for $C_M$. To do this, integrate over $\mu_{M-1}$, taking care over the limits of integration, and then make a change of variable so that this integral has limits $0$ and $1$. By assuming the correct result for $C_{M-1}$ and making use of (2.265), derive the expression for $C_M$.

## 2.10 Moments of Dirichlet Distribution ($\star$)

Using the property $\Gamma(x + 1) = x\Gamma(x)$ of the gamma function, derive the following results for the mean, variance, and covariance of the Dirichlet distribution given by (2.38)
$$
\mathbb{E}[\mu_j] = \frac{\alpha_j}{\alpha_0} \tag{2.273}
$$
$$
\text{var}[\mu_j] = \frac{\alpha_j(\alpha_0 - \alpha_j)}{\alpha_0^2(\alpha_0 + 1)} \tag{2.274}
$$
$$
\text{cov}[\mu_j\mu_l] = -\frac{\alpha_j\alpha_l}{\alpha_0^2(\alpha_0 + 1)}, \quad j \neq l \tag{2.275}
$$
where $\alpha_0$ is defined by (2.39).
[Page 150]

- 2.11 ( ) www By expressing the expectation of $\ln \mu_j$ under the Dirichlet distribution (2.38) as a derivative with respect to $\alpha_j$, show that

$$
\mathbb{E}[\ln \mu_j] = \psi(\alpha_j) - \psi(\alpha_0) \tag{2.276}
$$

where $\alpha_0$ is given by (2.39) and

$$
\psi(a) \equiv \frac{d}{da} \ln \Gamma(a) \tag{2.277}
$$

is the digamma function.

- 2.12 ( ) The uniform distribution for a continuous variable $x$ is defined by

$$
U(x|a,b) = \frac{1}{b - a}, \quad a \le x \le b. \tag{2.278}
$$

Verify that this distribution is normalized, and find expressions for its mean and variance.

- 2.13 ( ) Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians $p(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ and $q(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\mathbf{m},\mathbf{L})$.

- 2.14 ( ) www This exercise demonstrates that the multivariate distribution with maximum entropy, for a given covariance, is a Gaussian. The entropy of a distribution $p(\mathbf{x})$ is given by

$$
H[\mathbf{x}] = - \int p(\mathbf{x})\ln p(\mathbf{x}) \, d\mathbf{x}. \tag{2.279}
$$

We wish to maximize $H[\mathbf{x}]$ over all distributions $p(\mathbf{x})$ subject to the constraints that $p(\mathbf{x})$ be normalized and that it have a specific mean and covariance, so that

$$
\int p(\mathbf{x}) \, d\mathbf{x} = 1 \tag{2.280}
$$

$$
\int p(\mathbf{x})\mathbf{x} \, d\mathbf{x} = \boldsymbol{\mu} \tag{2.281}
$$

$$
\int p(\mathbf{x})(\mathbf{x} - \boldsymbol{\mu})(\mathbf{x} - \boldsymbol{\mu})^{\text{T}} \, d\mathbf{x} = \boldsymbol{\Sigma}. \tag{2.282}
$$

By performing a variational maximization of (2.279) and using Lagrange multipliers to enforce the constraints (2.280), (2.281), and (2.282), show that the maximum likelihood distribution is given by the Gaussian (2.43).

- 2.15 ( ) Show that the entropy of the multivariate Gaussian $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ is given by

$$
H[\mathbf{x}] = \frac{1}{2} \ln |\boldsymbol{\Sigma}| + \frac{D}{2} (1 + \ln(2\pi)) \tag{2.283}
$$

where $D$ is the dimensionality of $\mathbf{x}$.
[Page 151]

## 2.16 Entropy of Sum of Gaussians ($\star$)

Consider two random variables $x_1$ and $x_2$ having Gaussian distributions with means $\mu_1, \mu_2$ and precisions $\tau_1, \tau_2$ respectively. Derive an expression for the differential entropy of the variable $x = x_1 + x_2$. To do this, first find the distribution of $x$ by using the relation

$$
p(x) = \int_{-\infty}^{\infty} p(x|x_2)p(x_2) \,dx_2 \tag{2.284}
$$

and completing the square in the exponent. Then observe that this represents the convolution of two Gaussian distributions, which itself will be Gaussian, and finally make use of the result (1.110) for the entropy of the univariate Gaussian.

## 2.17 Symmetry of Gaussian Precision Matrix ($\star$)

Consider the multivariate Gaussian distribution given by (2.43). By writing the precision matrix (inverse covariance matrix) $\boldsymbol{\Sigma}^{-1}$ as the sum of a symmetric and an anti-symmetric matrix, show that the anti-symmetric term does not appear in the exponent of the Gaussian, and hence that the precision matrix may be taken to be symmetric without loss of generality. Because the inverse of a symmetric matrix is also symmetric (see Exercise 2.22), it follows that the covariance matrix may also be chosen to be symmetric without loss of generality.

## 2.18 Properties of Real Symmetric Matrices ($\star$)

Consider a real, symmetric matrix $\boldsymbol{\Sigma}$ whose eigenvalue equation is given by (2.45). By taking the complex conjugate of this equation and subtracting the original equation, and then forming the inner product with eigenvector $\mathbf{u}_i$, show that the eigenvalues $\lambda_i$ are real. Similarly, use the symmetry property of $\boldsymbol{\Sigma}$ to show that two eigenvectors $\mathbf{u}_i$ and $\mathbf{u}_j$ will be orthogonal provided $\lambda_j \neq \lambda_i$. Finally, show that without loss of generality, the set of eigenvectors can be chosen to be orthonormal, so that they satisfy (2.46), even if some of the eigenvalues are zero.

## 2.19 Eigenvector Expansion of Covariance Matrix ($\star$)

Show that a real, symmetric matrix $\boldsymbol{\Sigma}$ having the eigenvector equation (2.45) can be expressed as an expansion in the eigenvectors, with coefficients given by the eigenvalues, of the form (2.48). Similarly, show that the inverse matrix $\boldsymbol{\Sigma}^{-1}$ has a representation of the form (2.49).

## 2.20 Positive Definite Matrix Eigenvalues ($\star$)

A positive definite matrix $\boldsymbol{\Sigma}$ can be defined as one for which the quadratic form

$$
\mathbf{a}^{\text{T}}\boldsymbol{\Sigma}\mathbf{a} \tag{2.285}
$$

is positive for any real value of the vector $\mathbf{a}$. Show that a necessary and sufficient condition for $\boldsymbol{\Sigma}$ to be positive definite is that all of the eigenvalues $\lambda_i$ of $\boldsymbol{\Sigma}$, defined by (2.45), are positive.

## 2.21 Independent Parameters of Symmetric Matrix ($\star$)

Show that a real, symmetric matrix of size $D \times D$ has $D(D+1)/2$ independent parameters.

## 2.22 Inverse of Symmetric Matrix ($\star$)

Show that the inverse of a symmetric matrix is itself symmetric.

## 2.23 Volume of Constant Mahalanobis Distance ($\star\star$)

By diagonalizing the coordinate system using the eigenvector expansion (2.45), show that the volume contained within the hyperellipsoid corresponding to a constant
[Page 152]

Mahalanobis distance $\Delta$ is given by

$$
V_{D} |\boldsymbol{\Sigma}|^{1/2} \Delta^{D} \tag{2.286}
$$

where $V_{D}$ is the volume of the unit sphere in $D$ dimensions, and the Mahalanobis distance is defined by (2.44).

## 2.24 Partitioned Matrix Inversion Formula

Prove the identity (2.76) by multiplying both sides by the matrix

$$
\begin{pmatrix}
\mathbf{A} & \mathbf{B} \\
\mathbf{C} & \mathbf{D}
\end{pmatrix}
\tag{2.287}
$$

and making use of the definition (2.77).

## 2.25 Marginalizing Multivariate Gaussian Partitions

In Sections 2.3.1 and 2.3.2, we considered the conditional and marginal distributions for a multivariate Gaussian. More generally, we can consider a partitioning of the components of $\mathbf{x}$ into three groups $\mathbf{x}_{a}$, $\mathbf{x}_{b}$, and $\mathbf{x}_{c}$, with a corresponding partitioning of the mean vector $\boldsymbol{\mu}$ and of the covariance matrix $\boldsymbol{\Sigma}$ in the form

$$
\boldsymbol{\mu} =
\begin{pmatrix}
\boldsymbol{\mu}_{a} \\
\boldsymbol{\mu}_{b} \\
\boldsymbol{\mu}_{c}
\end{pmatrix},
\quad
\boldsymbol{\Sigma} =
\begin{pmatrix}
\boldsymbol{\Sigma}_{aa} & \boldsymbol{\Sigma}_{ab} & \boldsymbol{\Sigma}_{ac} \\
\boldsymbol{\Sigma}_{ba} & \boldsymbol{\Sigma}_{bb} & \boldsymbol{\Sigma}_{bc} \\
\boldsymbol{\Sigma}_{ca} & \boldsymbol{\Sigma}_{cb} & \boldsymbol{\Sigma}_{cc}
\end{pmatrix}.
\tag{2.288}
$$

By making use of the results of Section 2.3, find an expression for the conditional distribution $p(\mathbf{x}_{a}|\mathbf{x}_{b})$ in which $\mathbf{x}_{c}$ has been marginalized out.

## 2.26 Woodbury Matrix Inversion Formula

A very useful result from linear algebra is the Woodbury matrix inversion formula given by

$$
(\mathbf{A} + \mathbf{B}\mathbf{C}\mathbf{D})^{-1} = \mathbf{A}^{-1} - \mathbf{A}^{-1}\mathbf{B}(\mathbf{C}^{-1} + \mathbf{D}\mathbf{A}^{-1}\mathbf{B})^{-1}\mathbf{D}\mathbf{A}^{-1}. \tag{2.289}
$$

By multiplying both sides by $(\mathbf{A} + \mathbf{B}\mathbf{C}\mathbf{D})$ prove the correctness of this result.

## 2.27 Mean and Covariance of Sum

Let $\mathbf{x}$ and $\mathbf{z}$ be two independent random vectors, so that $p(\mathbf{x},\mathbf{z}) = p(\mathbf{x})p(\mathbf{z})$. Show that the mean of their sum $\mathbf{y} = \mathbf{x}+\mathbf{z}$ is given by the sum of the means of each of the variable separately. Similarly, show that the covariance matrix of $\mathbf{y}$ is given by the sum of the covariance matrices of $\mathbf{x}$ and $\mathbf{z}$. Confirm that this result agrees with that of Exercise 1.10.

## 2.28 Marginal and Conditional Gaussian Distributions

Consider a joint distribution over the variable

$$
\mathbf{z} =
\begin{pmatrix}
\mathbf{x} \\
\mathbf{y}
\end{pmatrix}
\tag{2.290}
$$

whose mean and covariance are given by (2.108) and (2.105) respectively. By making use of the results (2.92) and (2.93) show that the marginal distribution $p(\mathbf{x})$ is given (2.99). Similarly, by making use of the results (2.81) and (2.82) show that the conditional distribution $p(\mathbf{y}|\mathbf{x})$ is given by (2.100).
[Page 153]

- 2.29 ($\star$) Using the partitioned matrix inversion formula (2.76), show that the inverse of the precision matrix (2.104) is given by the covariance matrix (2.105).

- 2.30 ($\star$) By starting from (2.107) and making use of the result (2.105), verify the result (2.108).

- 2.31 ($\star$) Consider two multidimensional random vectors $\mathbf{x}$ and $\mathbf{z}$ having Gaussian distributions $p(\mathbf{x}) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu}_x, \boldsymbol{\Sigma}_x)$ and $p(\mathbf{z}) = \mathcal{N}(\mathbf{z}|\boldsymbol{\mu}_z, \boldsymbol{\Sigma}_z)$ respectively, together with their sum $\mathbf{y} = \mathbf{x} + \mathbf{z}$. Use the results (2.109) and (2.110) to find an expression for the marginal distribution $p(\mathbf{y})$ by considering the linear-Gaussian model comprising the product of the marginal distribution $p(\mathbf{x})$ and the conditional distribution $p(\mathbf{y}|\mathbf{x})$.

- 2.32 ($\star$) www This exercise and the next provide practice at manipulating the quadratic forms that arise in linear-Gaussian models, as well as giving an independent check of results derived in the main text. Consider a joint distribution $p(\mathbf{x}, \mathbf{y})$ defined by the marginal and conditional distributions given by (2.99) and (2.100). By examining the quadratic form in the exponent of the joint distribution, and using the technique of 'completing the square' discussed in Section 2.3, find expressions for the mean and covariance of the marginal distribution $p(\mathbf{y})$ in which the variable $\mathbf{x}$ has been integrated out. To do this, make use of the Woodbury matrix inversion formula (2.289). Verify that these results agree with (2.109) and (2.110) obtained using the results of Chapter 2.

- 2.33 ($\star$) Consider the same joint distribution as in Exercise 2.32, but now use the technique of completing the square to find expressions for the mean and covariance of the conditional distribution $p(\mathbf{x}|\mathbf{y})$. Again, verify that these agree with the corresponding expressions (2.111) and (2.112).

- 2.34 ($\star$) www To find the maximum likelihood solution for the covariance matrix of a multivariate Gaussian, we need to maximize the log likelihood function (2.118) with respect to $\boldsymbol{\Sigma}$, noting that the covariance matrix must be symmetric and positive definite. Here we proceed by ignoring these constraints and doing a straightforward maximization. Using the results (C.21), (C.26), and (C.28) from Appendix C, show that the covariance matrix $\boldsymbol{\Sigma}$ that maximizes the log likelihood function (2.118) is given by the sample covariance (2.122). We note that the final result is necessarily symmetric and positive definite (provided the sample covariance is nonsingular).

- 2.35 ($\star$) Use the result (2.59) to prove (2.62). Now, using the results (2.59), and (2.62), show that

$$
\mathbb{E}[\mathbf{x}_n \mathbf{x}_m^{\mathrm{T}}] = \boldsymbol{\mu}\boldsymbol{\mu}^{\mathrm{T}} + I_{nm}\boldsymbol{\Sigma} \tag{2.291}
$$

where $\mathbf{x}_n$ denotes a data point sampled from a Gaussian distribution with mean $\boldsymbol{\mu}$ and covariance $\boldsymbol{\Sigma}$, and $I_{nm}$ denotes the $(n, m)$ element of the identity matrix. Hence prove the result (2.124).

- 2.36 ($\star$) www Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the variance of a univariate Gaussian
[Page 154]

distribution, by starting with the maximum likelihood expression
$$
\sigma_{\text{ML}}^2 = \frac{1}{N} \sum_{n=1}^N (x_n - \mu)^2. \tag{2.292}
$$
Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefficients $a_N$.

- 2.37 ( ) Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the covariance of a multivariate Gaussian distribution, by starting with the maximum likelihood expression (2.122). Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefficients $a_N$.

- 2.38 ( ) Use the technique of completing the square for the quadratic form in the exponent to derive the results (2.141) and (2.142).

- 2.39 ( ) Starting from the results (2.141) and (2.142) for the posterior distribution of the mean of a Gaussian random variable, dissect out the contributions from the first $N - 1$ data points and hence obtain expressions for the sequential update of $\mu_N$ and $\sigma_N^2$. Now derive the same results starting from the posterior distribution $p(\mu|x_1,\ldots,x_{N-1}) = \mathcal{N}(\mu|\mu_{N-1},\sigma_{N-1}^2)$ and multiplying by the likelihood function $p(x_N|\mu) = \mathcal{N}(x_N|\mu,\sigma^2)$ and then completing the square and normalizing to obtain the posterior distribution after $N$ observations.

- 2.40 ( ) www Consider a $D$-dimensional Gaussian random variable $\mathbf{x}$ with distribution $\mathcal{N}(\mathbf{x}|\boldsymbol{\mu},\boldsymbol{\Sigma})$ in which the covariance $\boldsymbol{\Sigma}$ is known and for which we wish to infer the mean $\boldsymbol{\mu}$ from a set of observations $\mathbf{X} = \{\mathbf{x}_1,\ldots,\mathbf{x}_N\}$. Given a prior distribution $p(\boldsymbol{\mu}) = \mathcal{N}(\boldsymbol{\mu}|\boldsymbol{\mu}_0,\boldsymbol{\Sigma}_0)$, find the corresponding posterior distribution $p(\boldsymbol{\mu}|\mathbf{X})$.

- 2.41 ( ) Use the definition of the gamma function (1.141) to show that the gamma distribution (2.146) is normalized.

- 2.42 ( ) Evaluate the mean, variance, and mode of the gamma distribution (2.146).

- 2.43 ( ) The following distribution
$$
p(x|\sigma^2, q) = \frac{q}{2(2\sigma^2)^{1/q}\Gamma(1/q)} \exp \left( - \frac{|x|^q}{2\sigma^2} \right) \tag{2.293}
$$
is a generalization of the univariate Gaussian distribution. Show that this distribution is normalized so that
$$
\int_{-\infty}^{\infty} p(x|\sigma^2, q) \, dx = 1 \tag{2.294}
$$
and that it reduces to the Gaussian when $q = 2$. Consider a regression model in which the target variable is given by $t = y(\mathbf{x},\mathbf{w}) + \epsilon$ and $\epsilon$ is a random noise
[Page 155]

variable drawn from the distribution (2.293). Show that the log likelihood function over $\mathbf{w}$ and $\sigma^2$, for an observed data set of input vectors $\mathbf{X} = \{\mathbf{x}_1,\ldots,\mathbf{x}_N\}$ and corresponding target variables $\mathbf{t} = (t_1,\ldots,t_N)^{\mathrm{T}}$, is given by

$$
\ln p(\mathbf{t}|\mathbf{X},\mathbf{w},\sigma^2) = -\frac{1}{2\sigma^2} \sum_{n=1}^N |y(\mathbf{x}_n,\mathbf{w}) - t_n|^q - \frac{N}{q} \ln(2\sigma^2) + \text{const} \tag{2.295}
$$

where 'const' denotes terms independent of both $\mathbf{w}$ and $\sigma^2$. Note that, as a function of $\mathbf{w}$, this is the $L_q$ error function considered in Section 1.5.5.

## 2.44 Conjugate Prior for Univariate Gaussian ($\star$)

Consider a univariate Gaussian distribution $\mathcal{N}(x|\mu,\tau^{-1})$ having conjugate Gaussian-gamma prior given by (2.154), and a data set $\mathbf{x} = \{x_1,\ldots,x_N\}$ of i.i.d. observations. Show that the posterior distribution is also a Gaussian-gamma distribution of the same functional form as the prior, and write down expressions for the parameters of this posterior distribution.

## 2.45 Wishart Conjugate Prior for Precision ($\star$)

Verify that the Wishart distribution defined by (2.155) is indeed a conjugate prior for the precision matrix of a multivariate Gaussian.

## 2.46 Evaluating Student t-Distribution Integral ($\star$)

Verify that evaluating the integral in (2.158) leads to the result (2.159).

## 2.47 Gaussian Limit of t-Distribution ($\star$)

Show that in the limit $\nu \to \infty$, the t-distribution (2.159) becomes a Gaussian. Hint: ignore the normalization coefficient, and simply look at the dependence on $x$.

## 2.48 Normalization of Multivariate t-Distribution ($\star$)

By following analogous steps to those used to derive the univariate Student's t-distribution (2.159), verify the result (2.162) for the multivariate form of the Student's t-distribution, by marginalizing over the variable $\eta$ in (2.161). Using the definition (2.161), show by exchanging integration variables that the multivariate t-distribution is correctly normalized.

## 2.49 Properties of Multivariate t-Distribution ($\star$)

By using the definition (2.161) of the multivariate Student's t-distribution as a convolution of a Gaussian with a gamma distribution, verify the properties (2.164), (2.165), and (2.166) for the multivariate t-distribution defined by (2.162).

## 2.50 Gaussian Limit of Multivariate t-Distribution ($\star$)

Show that in the limit $\nu \to \infty$, the multivariate Student's t-distribution (2.162) reduces to a Gaussian with mean $\boldsymbol{\mu}$ and precision $\boldsymbol{\Lambda}$.

## 2.51 Proof of Periodic Trigonometric Identities ($\star$)

The various trigonometric identities used in the discussion of periodic variables in this chapter can be proven easily from the relation

$$
\exp(iA) = \cos A + i\sin A \tag{2.296}
$$

in which $i$ is the square root of minus one. By considering the identity

$$
\exp(iA)\exp(-iA) = 1 \tag{2.297}
$$

prove the result (2.177). Similarly, using the identity

$$
\cos(A - B) = \Re \exp\{i(A - B)\} \tag{2.298}
$$
[Page 156]

where $\Re$ denotes the real part, prove (2.178). Finally, by using $\sin(A - B) = \Im \exp\{i(A - B)\}$, where $\Im$ denotes the imaginary part, prove the result (2.183).

## 2.52 Gaussian Limit of von Mises ($\star$)

For large $m$, the von Mises distribution (2.179) becomes sharply peaked around the mode $\theta_0$. By defining $\xi = m^{1/2}(\theta - \theta_0)$ and making the Taylor expansion of the cosine function given by

$$
\cos \alpha = 1 - \frac{\alpha^2}{2} + O(\alpha^4) \tag{2.299}
$$

show that as $m \to \infty$, the von Mises distribution tends to a Gaussian.

## 2.53 Solving von Mises Maximum Likelihood ($\star$)

Using the trigonometric identity (2.183), show that solution of (2.182) for $\theta_0$ is given by (2.184).

## 2.54 Extrema of von Mises Distribution ($\star$)

By computing first and second derivatives of the von Mises distribution (2.179), and using $I_0(m) > 0$ for $m > 0$, show that the maximum of the distribution occurs when $\theta = \theta_0$ and that the minimum occurs when $\theta = \theta_0 + \pi \pmod{2\pi}$.

## 2.55 Maximum Likelihood of von Mises ($\star$)

By making use of the result (2.168), together with (2.184) and the trigonometric identity (2.178), show that the maximum likelihood solution $m_{\text{ML}}$ for the concentration of the von Mises distribution satisfies $A(m_{\text{ML}}) = r$ where $r$ is the radius of the mean of the observations viewed as unit vectors in the two-dimensional Euclidean plane, as illustrated in Figure 2.17.

## 2.56 Exponential Family Form Identifications ($\star$)

Express the beta distribution (2.13), the gamma distribution (2.146), and the von Mises distribution (2.179) as members of the exponential family (2.194) and thereby identify their natural parameters.

## 2.57 Multivariate Gaussian Exponential Family Form ($\star\star$)

Verify that the multivariate Gaussian distribution can be cast in exponential family form (2.194) and derive expressions for $\boldsymbol{\eta}$, $\mathbf{u}(\mathbf{x})$, $h(\mathbf{x})$ and $g(\boldsymbol{\eta})$ analogous to (2.220)–(2.223).

## 2.58 Negative Gradient of Exponential Family ($\star$)

The result (2.226) showed that the negative gradient of $\ln g(\boldsymbol{\eta})$ for the exponential family is given by the expectation of $\mathbf{u}(\mathbf{x})$. By taking the second derivatives of (2.195), show that

$$
-\nabla \nabla \ln g(\boldsymbol{\eta}) = \mathbb{E}[\mathbf{u}(\mathbf{x})\mathbf{u}(\mathbf{x})^T] - \mathbb{E}[\mathbf{u}(\mathbf{x})]\mathbb{E}[\mathbf{u}(\mathbf{x})^T] = \mathrm{cov}[\mathbf{u}(\mathbf{x})]. \tag{2.300}
$$

## 2.59 Normalization of Scaled Density Function ($\star$)

By changing variables using $y = x/\sigma$, show that the density (2.236) will be correctly normalized, provided $f(x)$ is correctly normalized.

## 2.60 Maximum Likelihood for Histogram Density ($\star\star$)

Consider a histogram-like density model in which the space $\mathbf{x}$ is divided into fixed regions for which the density $p(\mathbf{x})$ takes the constant value $h_i$ over the $i^{\text{th}}$ region, and that the volume of region $i$ is denoted $\Delta_i$. Suppose we have a set of $N$ observations of $\mathbf{x}$ such that $n_i$ of these observations fall in region $i$. Using a Lagrange multiplier to enforce the normalization constraint on the density, derive an expression for the maximum likelihood estimator for the $\{h_i\}$.

## 2.61 Improper Distribution of K-Nearest-Neighbour ($\star$)

Show that the $K$-nearest-neighbour density model defines an improper distribution whose integral over all space is divergent.
