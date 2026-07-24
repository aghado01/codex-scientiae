# Chapter 9 Exercises

[Page 475]


## 9.1 K-means Algorithm Convergence ($\star$)

Consider the $K$-means algorithm discussed in Section 9.1. Show that as a consequence of there being a finite number of possible assignments for the set of discrete indicator variables $r_{nk}$, and that for each such assignment there is a unique optimum for the $\{\boldsymbol{\mu}_k\}$, the $K$-means algorithm must converge after a finite number of iterations.

## 9.2 Stochastic K-means Estimation ($\star$)

Apply the Robbins-Monro sequential estimation procedure described in Section 2.3.5 to the problem of finding the roots of the regression function given by the derivatives of $J$ in (9.1) with respect to $\boldsymbol{\mu}_k$. Show that this leads to a stochastic $K$-means algorithm in which, for each data point $\mathbf{x}_n$, the nearest prototype $\boldsymbol{\mu}_k$ is updated using (9.5).
[Page 476]

## 9.3 Marginal of Gaussian Mixture ($\star$)

Consider a Gaussian mixture model in which the marginal distribution $p(\mathbf{z})$ for the latent variable is given by (9.10), and the conditional distribution $p(\mathbf{x}|\mathbf{z})$ for the observed variable is given by (9.11). Show that the marginal distribution $p(\mathbf{x})$, obtained by summing $p(\mathbf{z})p(\mathbf{x}|\mathbf{z})$ over all possible values of $\mathbf{z}$, is a Gaussian mixture of the form (9.7).

## 9.4 EM for Posterior Maximization ($\star$)

Suppose we wish to use the EM algorithm to maximize the posterior distribution over parameters $p(\boldsymbol{\theta}|\mathbf{X})$ for a model containing latent variables, where $\mathbf{X}$ is the observed data set. Show that the E step remains the same as in the maximum likelihood case, whereas in the M step the quantity to be maximized is given by $\mathcal{Q}(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}}) + \ln p(\boldsymbol{\theta})$ where $\mathcal{Q}(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}})$ is defined by (9.30).

## 9.5 Posterior Factorization in Mixtures ($\star$)

Consider the directed graph for a Gaussian mixture model shown in Figure 9.6. By making use of the d-separation criterion discussed in Section 8.2, show that the posterior distribution of the latent variables factorizes with respect to the different data points so that

$$
p(\mathbf{Z}|\mathbf{X}, \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi}) = \prod_{n=1}^N p(\mathbf{z}_n|\mathbf{x}_n, \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi}). \tag{9.80}
$$

## 9.6 EM with Common Covariance ($\star\star$)

Consider a special case of a Gaussian mixture model in which the covariance matrices $\boldsymbol{\Sigma}_k$ of the components are all constrained to have a common value $\boldsymbol{\Sigma}$. Derive the EM equations for maximizing the likelihood function under such a model.

## 9.7 Independent Fitting of Components ($\star\star$)

Verify that maximization of the complete-data log likelihood (9.36) for a Gaussian mixture model leads to the result that the means and covariances of each component are fitted independently to the corresponding group of data points, and the mixing coefficients are given by the fractions of points in each group.

## 9.8 Maximizing with Respect to Means ($\star$)

Show that if we maximize (9.40) with respect to $\boldsymbol{\mu}_k$ while keeping the responsibilities $\gamma(z_{nk})$ fixed, we obtain the closed form solution given by (9.17).

## 9.9 Maximizing Covariances and Mixing Coefficients ($\star$)

Show that if we maximize (9.40) with respect to $\boldsymbol{\Sigma}_k$ and $\pi_k$ while keeping the responsibilities $\gamma(z_{nk})$ fixed, we obtain the closed form solutions given by (9.19) and (9.22).

## 9.10 Conditional of Mixture Distribution ($\star\star$)

Consider a density model given by a mixture distribution

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|k) \tag{9.81}
$$

and suppose that we partition the vector $\mathbf{x}$ into two parts so that $\mathbf{x} = (\mathbf{x}_a, \mathbf{x}_b)$. Show that the conditional density $p(\mathbf{x}_b|\mathbf{x}_a)$ is itself a mixture distribution and find expressions for the mixing coefficients and for the component densities.
[Page 477]

## 9.11 K-means as EM Limit ($\star$)

In Section 9.3.2, we obtained a relationship between $K$ means and EM for Gaussian mixtures by considering a mixture model in which all components have covariance $\epsilon\mathbf{I}$. Show that in the limit $\epsilon \to 0$, maximizing the expected completedata log likelihood for this model, given by (9.40), is equivalent to minimizing the distortion measure $J$ for the $K$-means algorithm given by (9.1).

## 9.12 Mean and Covariance of Mixtures ($\star$)

Consider a mixture distribution of the form

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|k) \tag{9.82}
$$

where the elements of $\mathbf{x}$ could be discrete or continuous or a combination of these. Denote the mean and covariance of $p(\mathbf{x}|k)$ by $\boldsymbol{\mu}_k$ and $\boldsymbol{\Sigma}_k$, respectively. Show that the mean and covariance of the mixture distribution are given by (9.49) and (9.50).

## 9.13 EM for Identical Bernoulli Components ($\star\star$)

Using the re-estimation equations for the EM algorithm, show that a mixture of Bernoulli distributions, with its parameters set to values corresponding to a maximum of the likelihood function, has the property that

$$
\mathbb{E}[\mathbf{x}] = \frac{1}{N} \sum_{n=1}^N \mathbf{x}_n \equiv \overline{\mathbf{x}}. \tag{9.83}
$$

Hence show that if the parameters of this model are initialized such that all components have the same mean $\boldsymbol{\mu}_k = \boldsymbol{\mu}$ for $k = 1,\dots,K$, then the EM algorithm will converge after one iteration, for any choice of the initial mixing coefficients, and that this solution has the property $\boldsymbol{\mu}_k = \overline{\mathbf{x}}$. Note that this represents a degenerate case of the mixture model in which all of the components are identical, and in practice we try to avoid such solutions by using an appropriate initialization.

## 9.14 Marginalizing Bernoulli Joint Distribution ($\star$)

Consider the joint distribution of latent and observed variables for the Bernoulli distribution obtained by forming the product of $p(\mathbf{x}|\mathbf{z}, \boldsymbol{\mu})$ given by (9.52) and $p(\mathbf{z}|\boldsymbol{\pi})$ given by (9.53). Show that if we marginalize this joint distribution with respect to $\mathbf{z}$, then we obtain (9.47).

## 9.15 M-step for Bernoulli Means ($\star\star$)

Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to $\boldsymbol{\mu}_k$, we obtain the M step equation (9.59).

## 9.16 M-step for Bernoulli Mixing Coefficients ($\star$)

Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to the mixing coefficients $\pi_k$, using a Lagrange multiplier to enforce the summation constraint, we obtain the M step equation (9.60).

## 9.17 Bounded Bernoulli Log Likelihood ($\star$)

Show that as a consequence of the constraint $0 \le p(x_{ni}|\mu_{ki}) \le 1$ for the discrete variable $x_{ni}$, the incomplete-data log likelihood function for a mixture of Bernoulli distributions is bounded above, and hence that there are no singularities for which the likelihood goes to infinity.
[Page 478]

## 9.18 EM for Bayesian Bernoulli Mixture ($\star$)

Consider a Bernoulli mixture model as discussed in Section 9.3.3, together with a prior distribution $p(\boldsymbol{\mu}_k|a_k,b_k)$ over each of the parameter vectors $\boldsymbol{\mu}_k$ given by the beta distribution (2.13), and a Dirichlet prior $p(\boldsymbol{\pi}|\boldsymbol{\alpha})$ given by (2.38). Derive the EM algorithm for maximizing the posterior probability $p(\boldsymbol{\mu},\boldsymbol{\pi}|\mathbf{X})$.

## 9.19 EM for Multinomial Mixture ($\star$)

Consider a $D$-dimensional variable $\mathbf{x}$ each of whose components $i$ is itself a multinomial variable of degree $M$ so that $\mathbf{x}$ is a binary vector with components $x_{ij}$ where $i = 1,\dots,D$ and $j = 1,\dots,M$, subject to the constraint that $\sum_j x_{ij} = 1$ for all $i$. Suppose that the distribution of these variables is described by a mixture of the discrete multinomial distributions considered in Section 2.2 so that

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|\boldsymbol{\mu}_k) \tag{9.84}
$$

where

$$
p(\mathbf{x}|\boldsymbol{\mu}_k) = \prod_{i=1}^D \prod_{j=1}^M \mu_{kij}^{x_{ij}}. \tag{9.85}
$$

The parameters $\mu_{kij}$ represent the probabilities $p(x_{ij} = 1|\boldsymbol{\mu}_k)$ and must satisfy $0 \le \mu_{kij} \le 1$ together with the constraint $\sum_j \mu_{kij} = 1$ for all values of $k$ and $i$. Given an observed data set $\{\mathbf{x}_n\}$, where $n = 1,\dots,N$, derive the E and M step equations of the EM algorithm for optimizing the mixing coefficients $\pi_k$ and the component parameters $\mu_{kij}$ of this distribution by maximum likelihood.

## 9.20 M-step for Bayesian Linear Regression ($\star$)

Show that maximization of the expected complete-data log likelihood function (9.62) for the Bayesian linear regression model leads to the M step reestimation result (9.63) for $\alpha$.

## 9.21 M-step for Regression Parameter ($\star$)

Using the evidence framework of Section 3.5, derive the M-step re-estimation equations for the parameter $\beta$ in the Bayesian linear regression model, analogous to the result (9.63) for $\alpha$.

## 9.22 M-step for RVM Hyperparameters ($\star$)

By maximization of the expected complete-data log likelihood defined by (9.66), derive the M step equations (9.67) and (9.68) for re-estimating the hyperparameters of the relevance vector machine for regression.

## 9.23 Equivalence of RVM Re-estimations ($\star$)

In Section 7.2.1 we used direct maximization of the marginal likelihood to derive the re-estimation equations (7.87) and (7.88) for finding values of the hyperparameters $\alpha$ and $\beta$ for the regression RVM. Similarly, in Section 9.3.4 we used the EM algorithm to maximize the same marginal likelihood, giving the re-estimation equations (9.67) and (9.68). Show that these two sets of re-estimation equations are formally equivalent.

## 9.24 Verify Variational Lower Bound ($\star$)

Verify the relation (9.70) in which $\mathcal{L}(q,\boldsymbol{\theta})$ and $\text{KL}(q \| p)$ are defined by (9.71) and (9.72), respectively.
[Page 479]

## 9.25 Lower Bound Gradient Equivalence ($\star$)

Show that the lower bound $\mathcal{L}(q,\boldsymbol{\theta})$ given by (9.71), with $q(\mathbf{Z}) = p(\mathbf{Z}|\mathbf{X},\boldsymbol{\theta}^{(\text{old})})$, has the same gradient with respect to $\boldsymbol{\theta}$ as the log likelihood function $\ln p(\mathbf{X}|\boldsymbol{\theta})$ at the point $\boldsymbol{\theta} = \boldsymbol{\theta}^{(\text{old})}$.

## 9.26 Incremental EM for Means ($\star$)

Consider the incremental form of the EM algorithm for a mixture of Gaussians, in which the responsibilities are recomputed only for a specific data point $\mathbf{x}_m$. Starting from the M-step formulae (9.17) and (9.18), derive the results (9.78) and (9.79) for updating the component means.

## 9.27 Incremental EM for Covariances ($\star\star$)

Derive M-step formulae for updating the covariance matrices and mixing coefficients in a Gaussian mixture model when the responsibilities are updated incrementally, analogous to the result (9.78) for updating the means.
[Page 480]
