[Page 478]

9.18 ( $\star$ ) Consider a Bernoulli mixture model as discussed in Section 9.3.3, together with a prior distribution $p(\boldsymbol{\mu}_k|a_k,b_k)$ over each of the parameter vectors $\boldsymbol{\mu}_k$ given by the beta distribution (2.13), and a Dirichlet prior $p(\boldsymbol{\pi}|\boldsymbol{\alpha})$ given by (2.38). Derive the EM algorithm for maximizing the posterior probability $p(\boldsymbol{\mu},\boldsymbol{\pi}|\mathbf{X})$.

9.19 ( $\star$ ) Consider a $D$-dimensional variable $\mathbf{x}$ each of whose components $i$ is itself a multinomial variable of degree $M$ so that $\mathbf{x}$ is a binary vector with components $x_{ij}$ where $i = 1,\dots,D$ and $j = 1,\dots,M$, subject to the constraint that $\sum_j x_{ij} = 1$ for all $i$. Suppose that the distribution of these variables is described by a mixture of the discrete multinomial distributions considered in Section 2.2 so that

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|\boldsymbol{\mu}_k) \tag{9.84}
$$

where

$$
p(\mathbf{x}|\boldsymbol{\mu}_k) = \prod_{i=1}^D \prod_{j=1}^M \mu_{kij}^{x_{ij}}. \tag{9.85}
$$

The parameters $\mu_{kij}$ represent the probabilities $p(x_{ij} = 1|\boldsymbol{\mu}_k)$ and must satisfy $0 \le \mu_{kij} \le 1$ together with the constraint $\sum_j \mu_{kij} = 1$ for all values of $k$ and $i$. Given an observed data set $\{\mathbf{x}_n\}$, where $n = 1,\dots,N$, derive the E and M step equations of the EM algorithm for optimizing the mixing coefﬁcients $\pi_k$ and the component parameters $\mu_{kij}$ of this distribution by maximum likelihood.

9.20 ( $\star$ ) www Show that maximization of the expected complete-data log likelihood function (9.62) for the Bayesian linear regression model leads to the M step reestimation result (9.63) for $\alpha$.

9.21 ( $\star$ ) Using the evidence framework of Section 3.5, derive the M-step re-estimation equations for the parameter $\beta$ in the Bayesian linear regression model, analogous to the result (9.63) for $\alpha$.

9.22 ( $\star$ ) By maximization of the expected complete-data log likelihood deﬁned by (9.66), derive the M step equations (9.67) and (9.68) for re-estimating the hyperparameters of the relevance vector machine for regression.

9.23 ( $\star$ ) www In Section 7.2.1 we used direct maximization of the marginal likelihood to derive the re-estimation equations (7.87) and (7.88) for ﬁnding values of the hyperparameters $\alpha$ and $\beta$ for the regression RVM. Similarly, in Section 9.3.4 we used the EM algorithm to maximize the same marginal likelihood, giving the re-estimation equations (9.67) and (9.68). Show that these two sets of re-estimation equations are formally equivalent.

9.24 ( $\star$ ) Verify the relation (9.70) in which $\mathcal{L}(q,\boldsymbol{\theta})$ and $\text{KL}(q \| p)$ are deﬁned by (9.71) and (9.72), respectively.
