[Page 334]

![The image is a graph that depicts the behavior of a function, specifically a sine function, with a specific set of parameters. The graph is defined by two sets of points: the x-axis and the y-axis. The x-axis is labeled with the values 0 and 1, while the y-axis is labeled with the values 0.5 and 0.5. The graph shows a sinusoidal function, which is a type of function that has a general shape with a minimum at the origin (0, 0) and a maximum at the origin (1, 1). The function is defined by a sine function, which is a type of function that has a sine function. The sine function is defined by the equation: f(x) = a * sin(b * x) where a is the amplitude, b is the phase shift, and x is the variable. The amplitude of the sine function is](../images/imageFile141.png)

Figure 6.11 The left plot shows a sample from a Gaussian process prior over functions $a(\mathbf{x})$, and the right plot shows the result of transforming this sample using a logistic sigmoid function.

bution over the target variable $t$ is then given by the Bernoulli distribution

$$
p(t|a) = \sigma(a)^t(1 - \sigma(a))^{1-t}. \tag{6.73}
$$

As usual, we denote the training set inputs by $\mathbf{x}_1,\dots,\mathbf{x}_N$ with corresponding observed target variables $\mathbf{t} = (t_1,\dots,t_N)^T$. We also consider a single test point $\mathbf{x}_{N+1}$ with target value $t_{N+1}$. Our goal is to determine the predictive distribution $p(t_{N+1}|\mathbf{t})$, where we have left the conditioning on the input variables implicit. To do this we introduce a Gaussian process prior over the vector $\mathbf{a}_{N+1}$, which has components $a(\mathbf{x}_1),\dots,a(\mathbf{x}_{N+1})$. This in turn deﬁnes a non-Gaussian process over $\mathbf{t}_{N+1}$, and by conditioning on the training data $\mathbf{t}_N$ we obtain the required predictive distribution. The Gaussian process prior for $\mathbf{a}_{N+1}$ takes the form

$$
p(\mathbf{a}_{N+1}) = \mathcal{N}(\mathbf{a}_{N+1}|\mathbf{0},\mathbf{C}_{N+1}). \tag{6.74}
$$

Unlike the regression case, the covariance matrix no longer includes a noise term because we assume that all of the training data points are correctly labelled. However, for numerical reasons it is convenient to introduce a noise-like term governed by a parameter $\nu$ that ensures that the covariance matrix is positive deﬁnite. Thus the covariance matrix $\mathbf{C}_{N+1}$ has elements given by

$$
C(\mathbf{x}_n,\mathbf{x}_m) = k(\mathbf{x}_n,\mathbf{x}_m) + \nu\delta_{nm} \tag{6.75}
$$

where $k(\mathbf{x}_n,\mathbf{x}_m)$ is any positive semideﬁnite kernel function of the kind considered in Section 6.2, and the value of $\nu$ is typically ﬁxed in advance. We shall assume that the kernel function $k(\mathbf{x},\mathbf{x}')$ is governed by a vector $\boldsymbol{\theta}$ of parameters, and we shall later discuss how $\boldsymbol{\theta}$ may be learned from the training data.

For two-class problems, it is sufﬁcient to predict $p(t_{N+1} = 1|\mathbf{t}_N)$ because the value of $p(t_{N+1} = 0|\mathbf{t}_N)$ is then given by $1 - p(t_{N+1} = 1|\mathbf{t}_N)$. The required
