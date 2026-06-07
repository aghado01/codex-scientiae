[Page 191]

single variable $x$ is given by
$$
\sigma_{\text{ML}}^{2} = \frac{1}{N} \sum_{n=1}^{N} (x_n - \mu_{\text{ML}})^{2}
\tag{3.96}
$$
and that this estimate is biased because the maximum likelihood solution $\mu_{\text{ML}}$ for the mean has fitted some of the noise on the data. In effect, this has used up one degree of freedom in the model. The corresponding unbiased estimate is given by (1.59) and takes the form
$$
\sigma_{\text{MAP}}^{2} = \frac{1}{N - 1} \sum_{n=1}^{N} (x_n - \mu_{\text{ML}})^{2}.
\tag{3.97}
$$
We shall see in Section 10.1.3 that this result can be obtained from a Bayesian treatment in which we marginalize over the unknown mean. The factor of $N - 1$ in the denominator of the Bayesian result takes account of the fact that one degree of freedom has been used in fitting the mean and removes the bias of maximum likelihood. Now consider the corresponding results for the linear regression model. The mean of the target distribution is now given by the function $\mathbf{w}^{\text{T}}\boldsymbol{\phi}(\mathbf{x})$, which contains $M$ parameters. However, not all of these parameters are tuned to the data. The effective number of parameters that are determined by the data is $\gamma$, with the remaining $M - \gamma$ parameters set to small values by the prior. This is reflected in the Bayesian result for the variance that has a factor $N - \gamma$ in the denominator, thereby correcting for the bias of the maximum likelihood result.

We can illustrate the evidence framework for setting hyperparameters using the sinusoidal synthetic data set from Section 1.1, together with the Gaussian basis function model comprising $9$ basis functions, so that the total number of parameters in the model is given by $M = 10$ including the bias. Here, for simplicity of illustration, we have set $\beta$ to its true value of $11.1$ and then used the evidence framework to determine $\alpha$, as shown in Figure 3.16.

We can also see how the parameter $\alpha$ controls the magnitude of the parameters $\{w_i\}$, by plotting the individual parameters versus the effective number $\gamma$ of parameters, as shown in Figure 3.17.

If we consider the limit $N \gg M$ in which the number of data points is large in relation to the number of parameters, then from (3.87) all of the parameters will be well determined by the data because $\mathbf{\Phi}^{\text{T}}\mathbf{\Phi}$ involves an implicit sum over data points, and so the eigenvalues $\lambda_i$ increase with the size of the data set. In this case, $\gamma = M$, and the re-estimation equations for $\alpha$ and $\beta$ become
$$
\alpha = \frac{M}{2E_W(\mathbf{m}_N)}
\tag{3.98}
$$

$$
\beta = \frac{N}{2E_D(\mathbf{m}_N)}
\tag{3.99}
$$
where $E_W$ and $E_D$ are defined by (3.25) and (3.26), respectively. These results can be used as an easy-to-compute approximation to the full evidence re-estimation
