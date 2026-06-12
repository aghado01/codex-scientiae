[Page 327]

where the covariance matrix $\mathbf{C}$ has elements

$$
C(\mathbf{x}_n,\mathbf{x}_m) = k(\mathbf{x}_n,\mathbf{x}_m) + \beta^{-1}\delta_{nm}. \tag{6.62}
$$

This result reﬂects the fact that the two Gaussian sources of randomness, namely that associated with $y(\mathbf{x})$ and that associated with $\epsilon$, are independent and so their covariances simply add.

One widely used kernel function for Gaussian process regression is given by the exponential of a quadratic form, with the addition of constant and linear terms to give

$$
k(\mathbf{x}_n,\mathbf{x}_m) = \theta_0 \exp\left\{ -\frac{\theta_1}{2} \|\mathbf{x}_n - \mathbf{x}_m\|^2 \right\} + \theta_2 + \theta_3 \mathbf{x}_n^T\mathbf{x}_m. \tag{6.63}
$$

Note that the term involving $\theta_3$ corresponds to a parametric model that is a linear function of the input variables. Samples from this prior are plotted for various values of the parameters $\theta_0,\dots,\theta_3$ in Figure 6.5, and Figure 6.6 shows a set of points sampled from the joint distribution (6.60) along with the corresponding values deﬁned by (6.61).

So far, we have used the Gaussian process viewpoint to build a model of the joint distribution over sets of data points. Our goal in regression, however, is to make predictions of the target variables for new inputs, given a set of training data. Let us suppose that $\mathbf{t}_N = (t_1,\dots,t_N)^T$, corresponding to input values $\mathbf{x}_1,\dots,\mathbf{x}_N$, comprise the observed training set, and our goal is to predict the target variable $t_{N+1}$ for a new input vector $\mathbf{x}_{N+1}$. This requires that we evaluate the predictive distribution $p(t_{N+1}|\mathbf{t}_N)$. Note that this distribution is conditioned also on the variables $\mathbf{x}_1,\dots,\mathbf{x}_N$ and $\mathbf{x}_{N+1}$. However, to keep the notation simple we will not show these conditioning variables explicitly.

To ﬁnd the conditional distribution $p(t_{N+1}|\mathbf{t})$, we begin by writing down the joint distribution $p(\mathbf{t}_{N+1})$, where $\mathbf{t}_{N+1}$ denotes the vector $(t_1,\dots,t_N,t_{N+1})^T$. We then apply the results from Section 2.3.1 to obtain the required conditional distribution, as illustrated in Figure 6.7.

From (6.61), the joint distribution over $t_1,\dots,t_{N+1}$ will be given by

$$
p(\mathbf{t}_{N+1}) = \mathcal{N}(\mathbf{t}_{N+1}|\mathbf{0},\mathbf{C}_{N+1}) \tag{6.64}
$$

where $\mathbf{C}_{N+1}$ is an $(N + 1) \times (N + 1)$ covariance matrix with elements given by (6.62). Because this joint distribution is Gaussian, we can apply the results from Section 2.3.1 to ﬁnd the conditional Gaussian distribution. To do this, we partition the covariance matrix as follows

$$
\mathbf{C}_{N+1} = \left( \begin{array}{cc} \mathbf{C}_N & \mathbf{k} \\ \mathbf{k}^T & c \end{array} \right) \tag{6.65}
$$

where $\mathbf{C}_N$ is the $N \times N$ covariance matrix with elements given by (6.62) for $n,m = 1,\dots,N$, the vector $\mathbf{k}$ has elements $k(\mathbf{x}_n,\mathbf{x}_{N+1})$ for $n = 1,\dots,N$, and the scalar
