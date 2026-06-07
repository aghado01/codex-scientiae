[Page 493]

$q_\mu(\mu)$ in the form

$$
\mathbb{E}[\mu] = \overline{x}, \quad \mathbb{E}[\mu^2] = \overline{x}^2 + \frac{1}{N\mathbb{E}[\tau]}. \tag{10.32}
$$

We can now substitute these moments into (10.31) and then solve for $\mathbb{E}[\tau]$ to give

$$
\frac{1}{\mathbb{E}[\tau]} = \frac{1}{N-1} (\overline{x^2} - \overline{x}^2) = \frac{1}{N-1} \sum_{n=1}^N (x_n - \overline{x})^2. \tag{10.33}
$$

We recognize the right-hand side as the familiar unbiased estimator for the variance of a univariate Gaussian distribution, and so we see that the use of a Bayesian approach has avoided the bias of the maximum likelihood solution.

### 10.1.4 Model comparison

As well as performing inference over the hidden variables $\mathbf{Z}$, we may also wish to compare a set of candidate models, labelled by the index $m$, and having prior probabilities $p(m)$. Our goal is then to approximate the posterior probabilities $p(m|\mathbf{X})$, where $\mathbf{X}$ is the observed data. This is a slightly more complex situation than that considered so far because different models may have different structure and indeed different dimensionality for the hidden variables $\mathbf{Z}$. We cannot therefore simply consider a factorized approximation $q(\mathbf{Z})q(m)$, but must instead recognize that the posterior over $\mathbf{Z}$ must be conditioned on $m$, and so we must consider $q(\mathbf{Z}, m) = q(\mathbf{Z}|m)q(m)$. We can readily verify the following decomposition based on this variational distribution

$$
\ln p(\mathbf{X}) = \mathcal{L} - \sum_m \sum_{\mathbf{Z}} q(\mathbf{Z}|m)q(m) \ln \left\{ \frac{p(\mathbf{Z}, m|\mathbf{X})}{q(\mathbf{Z}|m)q(m)} \right\} \tag{10.34}
$$

where $\mathcal{L}$ is a lower bound on $\ln p(\mathbf{X})$ and is given by

$$
\mathcal{L} = \sum_m \sum_{\mathbf{Z}} q(\mathbf{Z}|m)q(m) \ln \left\{ \frac{p(\mathbf{Z}, \mathbf{X}, m)}{q(\mathbf{Z}|m)q(m)} \right\}. \tag{10.35}
$$

Here we are assuming discrete $\mathbf{Z}$, but the same analysis applies to continuous latent variables provided the summations are replaced with integrations. We can maximize $\mathcal{L}$ with respect to the distribution $q(m)$ using a Lagrange multiplier, with the result

$$
q(m) \propto p(m)\exp\{\mathcal{L}_m\}. \tag{10.36}
$$

However, if we maximize $\mathcal{L}$ with respect to the $q(\mathbf{Z}|m)$, we ﬁnd that the solutions for different $m$ are coupled, as we expect because they are conditioned on $m$. We proceed instead by ﬁrst optimizing each of the $q(\mathbf{Z}|m)$ individually by optimization
