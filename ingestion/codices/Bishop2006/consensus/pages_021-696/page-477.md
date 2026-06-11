[Page 477]

9.11 ( $\star$ ) In Section 9.3.2, we obtained a relationship between $K$ means and EM for Gaussian mixtures by considering a mixture model in which all components have covariance $\epsilon\mathbf{I}$. Show that in the limit $\epsilon \to 0$, maximizing the expected completedata log likelihood for this model, given by (9.40), is equivalent to minimizing the distortion measure $J$ for the $K$-means algorithm given by (9.1).

9.12 ( $\star$ ) www Consider a mixture distribution of the form

$$
p(\mathbf{x}) = \sum_{k=1}^K \pi_k p(\mathbf{x}|k) \tag{9.82}
$$

where the elements of $\mathbf{x}$ could be discrete or continuous or a combination of these. Denote the mean and covariance of $p(\mathbf{x}|k)$ by $\boldsymbol{\mu}_k$ and $\boldsymbol{\Sigma}_k$, respectively. Show that the mean and covariance of the mixture distribution are given by (9.49) and (9.50).

9.13 ( $\star\star$ ) Using the re-estimation equations for the EM algorithm, show that a mixture of Bernoulli distributions, with its parameters set to values corresponding to a maximum of the likelihood function, has the property that

$$
\mathbb{E}[\mathbf{x}] = \frac{1}{N} \sum_{n=1}^N \mathbf{x}_n \equiv \overline{\mathbf{x}}. \tag{9.83}
$$

Hence show that if the parameters of this model are initialized such that all components have the same mean $\boldsymbol{\mu}_k = \boldsymbol{\mu}$ for $k = 1,\dots,K$, then the EM algorithm will converge after one iteration, for any choice of the initial mixing coefﬁcients, and that this solution has the property $\boldsymbol{\mu}_k = \overline{\mathbf{x}}$. Note that this represents a degenerate case of the mixture model in which all of the components are identical, and in practice we try to avoid such solutions by using an appropriate initialization.

9.14 ( $\star$ ) Consider the joint distribution of latent and observed variables for the Bernoulli distribution obtained by forming the product of $p(\mathbf{x}|\mathbf{z}, \boldsymbol{\mu})$ given by (9.52) and $p(\mathbf{z}|\boldsymbol{\pi})$ given by (9.53). Show that if we marginalize this joint distribution with respect to $\mathbf{z}$, then we obtain (9.47).

9.15 ( $\star\star$ ) www Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to $\boldsymbol{\mu}_k$, we obtain the M step equation (9.59).

9.16 ( $\star$ ) Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to the mixing coefﬁcients $\pi_k$, using a Lagrange multiplier to enforce the summation constraint, we obtain the M step equation (9.60).

9.17 ( $\star$ ) www Show that as a consequence of the constraint $0 \le p(x_{ni}|\mu_{ki}) \le 1$ for the discrete variable $x_{ni}$, the incomplete-data log likelihood function for a mixture of Bernoulli distributions is bounded above, and hence that there are no singularities for which the likelihood goes to inﬁnity.
