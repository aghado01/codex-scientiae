[Page 114]

which is the mean of the observed set of data points. The maximization of (2.118) with respect to $\Sigma$ is rather more involved. The simplest approach is to ignore the symmetry constraint and show that the resulting solution is symmetric as required. Alternative derivations of this result, which impose the symmetry and positive deﬁniteness constraints explicitly, can be found in Magnus and Neudecker (1999). The result is as expected and takes the form

$$
\Sigma_{ML} = \frac{1}{N}\sum_{n=1}^{N}(\mathbf{x}_n - \boldsymbol{\mu}_{ML})(\mathbf{x}_n - \boldsymbol{\mu}_{ML})^T \tag{2.122}
$$

which involves $\boldsymbol{\mu}_{ML}$ because this is the result of a joint maximization with respect to $\boldsymbol{\mu}$ and $\Sigma$. Note that the solution (2.121) for $\boldsymbol{\mu}_{ML}$ does not depend on $\Sigma_{ML}$, and so we can ﬁrst evaluate $\boldsymbol{\mu}_{ML}$ and then use this to evaluate $\Sigma_{ML}$.

If we evaluate the expectations of the maximum likelihood solutions under the true distribution, we obtain the following results

$$
\mathbb{E}[\boldsymbol{\mu}_{ML}] = \boldsymbol{\mu} \tag{2.123}
$$

$$
\mathbb{E}[\Sigma_{ML}] = \frac{N - 1}{N}\Sigma. \tag{2.124}
$$

We see that the expectation of the maximum likelihood estimate for the mean is equal to the true mean. However, the maximum likelihood estimate for the covariance has an expectation that is less than the true value, and hence it is biased. We can correct this bias by deﬁning a different estimator $\Sigma$ given by

$$
\Sigma = \frac{1}{N - 1}\sum_{n=1}^{N}(\mathbf{x}_n - \boldsymbol{\mu}_{ML})(\mathbf{x}_n - \boldsymbol{\mu}_{ML})^T. \tag{2.125}
$$

Clearly from (2.122) and (2.124), the expectation of $\Sigma$ is equal to $\Sigma$.

###### 2.3.5 Sequential estimation

Our discussion of the maximum likelihood solution for the parameters of a Gaussian distribution provides a convenient opportunity to give a more general discussion of the topic of sequential estimation for maximum likelihood. Sequential methods allow data points to be processed one at a time and then discarded and are important for on-line applications, and also where large data sets are involved so that batch processing of all data points at once is infeasible.

Consider the result (2.121) for the maximum likelihood estimator of the mean $\boldsymbol{\mu}_{ML}$, which we will denote by $\boldsymbol{\mu}_{ML}^{(N)}$ when it is based on $N$ observations. If we
