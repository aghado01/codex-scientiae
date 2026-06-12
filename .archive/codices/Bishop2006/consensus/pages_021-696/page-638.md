[Page 638]

Gaussian emission densities we have $p(\mathbf{x}|\boldsymbol{\phi}_k) = \mathcal{N}(\mathbf{x}|\boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k)$, and maximization of the function $Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}})$ then gives

$$
\boldsymbol{\mu}_k = \frac{\sum_{n=1}^N \gamma(z_{nk})\mathbf{x}_n}{\sum_{n=1}^N \gamma(z_{nk})} \tag{13.20}
$$
$$
\boldsymbol{\Sigma}_k = \frac{\sum_{n=1}^N \gamma(z_{nk})(\mathbf{x}_n - \boldsymbol{\mu}_k)(\mathbf{x}_n - \boldsymbol{\mu}_k)^{\text{T}}}{\sum_{n=1}^N \gamma(z_{nk})}. \tag{13.21}
$$

For the case of discrete multinomial observed variables, the conditional distribution of the observations takes the form

$$
p(\mathbf{x}|\mathbf{z}) = \prod_{i=1}^D \prod_{k=1}^K \mu_{ik}^{x_i z_k} \tag{13.22}
$$

and the corresponding M-step equations are given by

$$
\mu_{ik} = \frac{\sum_{n=1}^N \gamma(z_{nk})x_{ni}}{\sum_{n=1}^N \gamma(z_{nk})}. \tag{13.23}
$$

An analogous result holds for Bernoulli observed variables.

The EM algorithm requires initial values for the parameters of the emission distribution. One way to set these is ﬁrst to treat the data initially as i.i.d. and ﬁt the emission density by maximum likelihood, and then use the resulting values to initialize the parameters for EM.

### 13.2.2 The forward-backward algorithm

Next we seek an efﬁcient procedure for evaluating the quantities $\gamma(z_{nk})$ and $\xi(z_{n-1,j}, z_{nk})$, corresponding to the E step of the EM algorithm. The graph for the hidden Markov model, shown in Figure 13.5, is a tree, and so we know that the posterior distribution of the latent variables can be obtained efﬁciently using a twostage message passing algorithm. In the particular context of the hidden Markov model, this is known as the forward-backward algorithm (Rabiner, 1989), or the Baum-Welch algorithm (Baum, 1972). There are in fact several variants of the basic algorithm, all of which lead to the exact marginals, according to the precise form of
