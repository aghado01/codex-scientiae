[Page 189]

Multiplying through by $2\alpha$ and rearranging, we obtain
$$
\alpha \mathbf{m}_N^T \mathbf{m}_N = M - \alpha \sum_i \frac{1}{\lambda_i + \alpha} = \gamma. \tag{3.90}
$$

Since there are $M$ terms in the sum over $i$, the quantity $\gamma$ can be written
$$
\gamma = \sum_i \frac{\lambda_i}{\alpha + \lambda_i}. \tag{3.91}
$$

The interpretation of the quantity $\gamma$ will be discussed shortly. From (3.90) we see that the value of $\alpha$ that maximizes the marginal likelihood satisfies
$$
\alpha = \frac{\gamma}{\mathbf{m}_N^T \mathbf{m}_N}. \tag{3.92}
$$

Note that this is an implicit solution for $\alpha$ not only because $\gamma$ depends on $\alpha$, but also because the mode $\mathbf{m}_N$ of the posterior distribution itself depends on the choice of $\alpha$. We therefore adopt an iterative procedure in which we make an initial choice for $\alpha$ and use this to find $\mathbf{m}_N$, which is given by (3.53), and also to evaluate $\gamma$, which is given by (3.91). These values are then used to re-estimate $\alpha$ using (3.92), and the process repeated until convergence. Note that because the matrix $\mathbf{\Phi}^T \mathbf{\Phi}$ is fixed, we can compute its eigenvalues once at the start and then simply multiply these by $\beta$ to obtain the $\lambda_i$.

It should be emphasized that the value of $\alpha$ has been determined purely by looking at the training data. In contrast to maximum likelihood methods, no independent data set is required in order to optimize the model complexity.

We can similarly maximize the log marginal likelihood (3.86) with respect to $\beta$. To do this, we note that the eigenvalues $\lambda_i$ defined by (3.87) are proportional to $\beta$, and hence $d\lambda_i/d\beta = \lambda_i/\beta$ giving
$$
\frac{d}{d\beta} \ln |\mathbf{A}| = \frac{d}{d\beta} \sum_i \ln(\lambda_i + \alpha) = \frac{1}{\beta} \sum_i \frac{\lambda_i}{\lambda_i + \alpha} = \frac{\gamma}{\beta}. \tag{3.93}
$$

The stationary point of the marginal likelihood therefore satisfies
$$
0 = \frac{N}{2\beta} - \frac{1}{2} \sum_{n=1}^N \{t_n - \mathbf{m}_N^T \boldsymbol{\phi}(\mathbf{x}_n)\}^2 - \frac{\gamma}{2\beta} \tag{3.94}
$$
and rearranging we obtain
$$
\frac{1}{\beta} = \frac{1}{N - \gamma} \sum_{n=1}^N \{t_n - \mathbf{m}_N^T \boldsymbol{\phi}(\mathbf{x}_n)\}^2. \tag{3.95}
$$

Again, this is an implicit solution for $\beta$ and can be solved by choosing an initial value for $\beta$ and then using this to calculate $\mathbf{m}_N$ and $\gamma$ and then re-estimate $\beta$ using (3.95), repeating until convergence. If both $\alpha$ and $\beta$ are to be determined from the data, then their values can be re-estimated together after each update of $\gamma$.
