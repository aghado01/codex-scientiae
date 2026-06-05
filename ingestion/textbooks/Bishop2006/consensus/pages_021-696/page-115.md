[Page 115]

Figure 2.10 A schematic illustration of two correlated random variables $z$ and $\theta$, together with the regression function $f(\theta)$ given by the conditional expectation $\mathbb{E}[z \mid \theta]$. The Robbins-Monro algorithm provides a general sequential procedure for ﬁnding the root $\theta^*$ of such functions.

dissect out the contribution from the ﬁnal data point $x_N$, we obtain

$$
\mu_{ML}^{(N)} = \frac{1}{N}\sum_{n=1}^{N} x_n = \frac{1}{N}x_N + \frac{1}{N}\sum_{n=1}^{N-1} x_n = \frac{1}{N}x_N + \frac{N - 1}{N}\mu_{ML}^{(N-1)}
$$

$$
= \mu_{ML}^{(N-1)} + \frac{1}{N}(x_N - \mu_{ML}^{(N-1)}). \tag{2.126}
$$

This result has a nice interpretation, as follows. After observing $N - 1$ data points we have estimated $\mu$ by $\mu_{ML}^{(N-1)}$. We now observe data point $x_N$, and we obtain our revised estimate $\mu_{ML}^{(N)}$ by moving the old estimate a small amount, proportional to $1/N$, in the direction of the ‘error signal’ $(x_N - \mu_{ML}^{(N-1)})$. Note that, as $N$ increases, so the contribution from successive data points gets smaller.

The result (2.126) will clearly give the same answer as the batch result (2.121) because the two formulae are equivalent. However, we will not always be able to derive a sequential algorithm by this route, and so we seek a more general formulation of sequential learning, which leads us to the Robbins-Monro algorithm. Consider a pair of random variables $\theta$ and $z$ governed by a joint distribution $p(z, \theta)$. The conditional expectation of $z$ given $\theta$ deﬁnes a deterministic function $f(\theta)$ that is given by

$$
f(\theta) \equiv \mathbb{E}[z \mid \theta] = \int z p(z \mid \theta)\, dz \tag{2.127}
$$

and is illustrated schematically in Figure 2.10. Functions deﬁned in this way are called regression functions.

Our goal is to ﬁnd the root $\theta^*$ at which $f(\theta^*) = 0$. If we had a large data set of observations of $z$ and $\theta$, then we could model the regression function directly and then obtain an estimate of its root. Suppose, however, that we observe values of $z$ one at a time and we wish to ﬁnd a corresponding sequential estimation scheme for $\theta$. The following general procedure for solving such problems was given by
