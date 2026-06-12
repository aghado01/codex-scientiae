[Page 301]

Section 3.5.3 where $\gamma$ represents the effective number of parameters and is deﬁned by

$$
\gamma = \sum_{i=1}^W \frac{\lambda_i}{\alpha + \lambda_i}. \tag{5.179}
$$

Note that this result was exact for the linear regression case. For the nonlinear neural network, however, it ignores the fact that changes in $\alpha$ will cause changes in the Hessian $\mathbf{H}$, which in turn will change the eigenvalues. We have therefore implicitly ignored terms involving the derivatives of $\lambda_i$ with respect to $\alpha$.

Similarly, from (3.95) we see that maximizing the evidence with respect to $\beta$ gives the re-estimation formula

$$
\frac{1}{\beta} = \frac{1}{N - \gamma} \sum_{n=1}^N \{y(\mathbf{x}_n,\mathbf{w}_{\text{MAP}}) - t_n\}^2. \tag{5.180}
$$

As with the linear model, we need to alternate between re-estimation of the hyperparameters $\alpha$ and $\beta$ and updating of the posterior distribution. The situation with a neural network model is more complex, however, due to the multimodality of the posterior distribution. As a consequence, the solution for $\mathbf{w}_{\text{MAP}}$ found by maximizing the log posterior will depend on the initialization of $\mathbf{w}$. Solutions that differ only

Section 5.1.1 as a consequence of the interchange and sign reversal symmetries in the hidden units are identical so far as predictions are concerned, and it is irrelevant which of the equivalent solutions is found. However, there may be inequivalent solutions as well, and these will generally yield different values for the optimized hyperparameters.

In order to compare different models, for example neural networks having different numbers of hidden units, we need to evaluate the model evidence $p(\mathcal{D})$. This can be approximated by taking (5.175) and substituting the values of $\alpha$ and $\beta$ obtained from the iterative optimization of these hyperparameters. A more careful evaluation is obtained by marginalizing over $\alpha$ and $\beta$, again by making a Gaussian approximation (MacKay, 1992c; Bishop, 1995a). In either case, it is necessary to evaluate the determinant $|\mathbf{A}|$ of the Hessian matrix. This can be problematic in practice because the determinant, unlike the trace, is sensitive to the small eigenvalues that are often difﬁcult to determine accurately.

The Laplace approximation is based on a local quadratic expansion around a mode of the posterior distribution over weights. We have seen in Section 5.1.1 that any given mode in a two-layer network is a member of a set of $M!2^M$ equivalent modes that differ by interchange and sign-change symmetries, where $M$ is the number of hidden units. When comparing networks having different numbers of hidden units, this can be taken into account by multiplying the evidence by a factor of $M!2^M$.

### 5.7.3 Bayesian neural networks for classiﬁcation

So far, we have used the Laplace approximation to develop a Bayesian treatment of neural network regression models. We now discuss the modiﬁcations to
