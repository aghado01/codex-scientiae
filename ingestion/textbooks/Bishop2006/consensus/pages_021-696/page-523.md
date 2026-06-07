[Page 523]

Speciﬁcally, we consider once again a simple isotropic Gaussian prior distribution of the form

$$
p(\mathbf{w}|\alpha) = \mathcal{N}(\mathbf{w}|\mathbf{0}, \alpha^{-1}\mathbf{I}). \tag{10.165}
$$

Our analysis is readily extended to more general Gaussian priors, for instance if we wish to associate a different hyperparameter with different subsets of the parameters $w_j$. As usual, we consider a conjugate hyperprior over $\alpha$ given by a gamma distribution

$$
p(\alpha) = \text{Gam}(\alpha|a_0, b_0) \tag{10.166}
$$

governed by the constants $a_0$ and $b_0$.

The marginal likelihood for this model now takes the form

$$
p(\mathbf{t}) = \iint p(\mathbf{w}, \alpha, \mathbf{t}) \text{d}\mathbf{w} \text{d}\alpha \tag{10.167}
$$

where the joint distribution is given by

$$
p(\mathbf{w}, \alpha, \mathbf{t}) = p(\mathbf{t}|\mathbf{w})p(\mathbf{w}|\alpha)p(\alpha). \tag{10.168}
$$

We are now faced with an analytically intractable integration over $\mathbf{w}$ and $\alpha$, which we shall tackle by using both the local and global variational approaches in the same model

To begin with, we introduce a variational distribution $q(\mathbf{w}, \alpha)$, and then apply the decomposition (10.2), which in this instance takes the form

$$
\ln p(\mathbf{t}) = \mathcal{L}(q) + \text{KL}(q || p) \tag{10.169}
$$

where the lower bound $\mathcal{L}(q)$ and the Kullback-Leibler divergence $\text{KL}(q || p)$ are deﬁned by

$$
\mathcal{L}(q) = \iint q(\mathbf{w}, \alpha) \ln \left\{ \frac{p(\mathbf{w}, \alpha, \mathbf{t})}{q(\mathbf{w}, \alpha)} \right\} \text{d}\mathbf{w} \text{d}\alpha \tag{10.170}
$$

$$
\text{KL}(q || p) = -\iint q(\mathbf{w}, \alpha) \ln \left\{ \frac{p(\mathbf{w}, \alpha|\mathbf{t})}{q(\mathbf{w}, \alpha)} \right\} \text{d}\mathbf{w} \text{d}\alpha. \tag{10.171}
$$

At this point, the lower bound $\mathcal{L}(q)$ is still intractable due to the form of the likelihood factor $p(\mathbf{t}|\mathbf{w})$. We therefore apply the local variational bound to each of the logistic sigmoid factors as before. This allows us to use the inequality (10.152) and place a lower bound on $\mathcal{L}(q)$, which will therefore also be a lower bound on the log marginal likelihood

$$
\begin{aligned}
\ln p(\mathbf{t}) \geqslant \mathcal{L}(q) &\geqslant \widetilde{\mathcal{L}}(q, \boldsymbol{\xi}) \\
&= \iint q(\mathbf{w}, \alpha) \ln \left\{ \frac{h(\mathbf{w}, \boldsymbol{\xi})p(\mathbf{w}|\alpha)p(\alpha)}{q(\mathbf{w}, \alpha)} \right\} \text{d}\mathbf{w} \text{d}\alpha.
\end{aligned} \tag{10.172}
$$

Next we assume that the variational distribution factorizes between parameters and hyperparameters so that

$$
q(\mathbf{w}, \alpha) = q(\mathbf{w})q(\alpha). \tag{10.173}
$$
