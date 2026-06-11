[Page 687]

logistic regression models (Section 14.5.2). In the simplest case, the mixing coefﬁcients are independent of the input variables. If we make a further generalization to allow the mixing coefﬁcients also to depend on the inputs then we obtain a mixture of experts model. Finally, if we allow each component in the mixture model to be itself a mixture of experts model, then we obtain a hierarchical mixture of experts.

### 14.5.1 Mixtures of linear regression models

One of the many advantages of giving a probabilistic interpretation to the linear regression model is that it can then be used as a component in more complex probabilistic models. This can be done, for instance, by viewing the conditional distribution representing the linear regression model as a node in a directed probabilistic graph. Here we consider a simple example corresponding to a mixture of linear regression models, which represents a straightforward extension of the Gaussian mixture model discussed in Section 9.2 to the case of conditional Gaussian distributions.

We therefore consider $K$ linear regression models, each governed by its own weight parameter $\mathbf{w}_k$. In many applications, it will be appropriate to use a common noise variance, governed by a precision parameter $\beta$, for all $K$ components, and this is the case we consider here. We will once again restrict attention to a single target variable $t$, though the extension to multiple outputs is straightforward. If we denote the mixing coefﬁcients by $\pi_k$, then the mixture distribution can be written

$$
p(t|\boldsymbol{\theta}) = \sum_{k=1}^K \pi_k \mathcal{N}(t|\mathbf{w}_k^{\text{T}}\boldsymbol{\phi}, \beta^{-1}) \tag{14.34}
$$

where $\boldsymbol{\theta}$ denotes the set of all adaptive parameters in the model, namely $\mathbf{W} = \{\mathbf{w}_k\}$, $\boldsymbol{\pi} = \{\pi_k\}$, and $\beta$. The log likelihood function for this model, given a data set of observations $\{\boldsymbol{\phi}_n, t_n\}$, then takes the form

$$
\ln p(\mathbf{t}|\boldsymbol{\theta}) = \sum_{n=1}^N \ln \left( \sum_{k=1}^K \pi_k \mathcal{N}(t_n|\mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n, \beta^{-1}) \right) \tag{14.35}
$$

where $\mathbf{t} = (t_1, \dots, t_N)^{\text{T}}$ denotes the vector of target variables.

In order to maximize this likelihood function, we can once again appeal to the EM algorithm, which will turn out to be a simple extension of the EM algorithm for unconditional Gaussian mixtures of Section 9.2. We can therefore build on our experience with the unconditional mixture and introduce a set $\mathbf{Z} = \{\mathbf{z}_n\}$ of binary latent variables where $z_{nk} \in \{0, 1\}$ in which, for each data point $n$, all of the elements $k = 1, \dots, K$ are zero except for a single value of $1$ indicating which component of the mixture was responsible for generating that data point. The joint distribution over latent and observed variables can be represented by the graphical model shown in Figure 14.7.

The complete-data log likelihood function then takes the form

$$
\ln p(\mathbf{t}, \mathbf{Z}|\boldsymbol{\theta}) = \sum_{n=1}^N \sum_{k=1}^K z_{nk} \ln \left\{ \pi_k \mathcal{N}(t_n|\mathbf{w}_k^{\text{T}}\boldsymbol{\phi}_n, \beta^{-1}) \right\}. \tag{14.36}
$$
